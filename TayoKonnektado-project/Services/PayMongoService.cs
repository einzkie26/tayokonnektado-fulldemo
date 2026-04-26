using System.Text;
using System.Text.Json;

namespace TayoKonnektado_project.Services
{
    public class PayMongoService
    {
        private readonly HttpClient _httpClient;
        private readonly string _secretKey;
        private readonly string _appBaseUrl;

        public PayMongoService(IConfiguration configuration)
        {
            _httpClient = new HttpClient();
            _secretKey = configuration["PayMongo:SecretKey"]!;
            _appBaseUrl = configuration["AppBaseUrl"] ?? "http://localhost:5173";
            var authToken = Convert.ToBase64String(Encoding.UTF8.GetBytes($"{_secretKey}:"));
            _httpClient.DefaultRequestHeaders.Add("Authorization", $"Basic {authToken}");
        }

        public async Task<string> CreatePaymentIntent(decimal amount, string description)
        {
            var payload = new
            {
                data = new
                {
                    attributes = new
                    {
                        amount = (int)(amount * 100),
                        payment_method_allowed = new[] { "card", "gcash" },
                        currency = "PHP",
                        description,
                        capture_type = "manual"
                    }
                }
            };

            var content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("https://api.paymongo.com/v1/payment_intents", content);
            var result = await response.Content.ReadAsStringAsync();
            
            Console.WriteLine($"PayMongo CreatePaymentIntent Response: {result}");
            
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception($"PayMongo API error: {result}");
            }
            
            var json = JsonDocument.Parse(result);
            var paymentIntentId = json.RootElement.GetProperty("data").GetProperty("id").GetString()!;
            Console.WriteLine($"Created Payment Intent: {paymentIntentId}");
            return paymentIntentId;
        }

        public async Task<string> CreatePaymentMethod(string type, PaymentDetails details)
        {
            object attributes;
            if (type == "card")
            {
                attributes = new
                {
                    type,
                    details = new
                    {
                        card_number = details.CardNumber,
                        exp_month = details.ExpMonth,
                        exp_year = details.ExpYear,
                        cvc = details.Cvc
                    }
                };
            }
            else
            {
                attributes = new { type };
            }

            var payload = new { data = new { attributes } };
            var content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("https://api.paymongo.com/v1/payment_methods", content);
            var result = await response.Content.ReadAsStringAsync();
            
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception($"PayMongo API error: {result}");
            }
            
            var json = JsonDocument.Parse(result);
            if (!json.RootElement.TryGetProperty("data", out var data))
            {
                throw new Exception($"Invalid PayMongo response: {result}");
            }
            
            return data.GetProperty("id").GetString()!;
        }

        public async Task<string> CreateGCashSource(decimal amount, string phoneNumber)
        {
            var payload = new
            {
                data = new
                {
                    attributes = new
                    {
                        amount = (int)(amount * 100),
                        redirect = new
                        {
                            success = $"{_appBaseUrl}/dashboard/account/billing?status=success",
                            failed = $"{_appBaseUrl}/dashboard/account/billing?status=failed"
                        },
                        type = "gcash",
                        currency = "PHP"
                    }
                }
            };

            var content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("https://api.paymongo.com/v1/sources", content);
            var result = await response.Content.ReadAsStringAsync();
            
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception($"PayMongo API error: {result}");
            }
            
            var json = JsonDocument.Parse(result);
            var data = json.RootElement.GetProperty("data");
            var checkoutUrl = data.GetProperty("attributes").GetProperty("redirect").GetProperty("checkout_url").GetString();
            
            return checkoutUrl!;
        }

        public async Task<string> GetPaymentIntentStatus(string paymentIntentId)
        {
            var response = await _httpClient.GetAsync($"https://api.paymongo.com/v1/payment_intents/{paymentIntentId}");
            var result = await response.Content.ReadAsStringAsync();
            
            Console.WriteLine($"PayMongo GetPaymentIntent Response: {result}");
            
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception($"PayMongo API error: {result}");
            }
            
            var json = JsonDocument.Parse(result);
            var status = json.RootElement.GetProperty("data").GetProperty("attributes").GetProperty("status").GetString();
            return status!;
        }

        public async Task<(bool success, string? checkoutUrl)> AttachPaymentIntent(string paymentIntentId, string paymentMethodId, string paymentType)
        {
            var payload = new
            {
                data = new
                {
                    attributes = new
                    {
                        payment_method = paymentMethodId,
                        return_url = $"{_appBaseUrl}/dashboard/account/billing"
                    }
                }
            };

            var content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync($"https://api.paymongo.com/v1/payment_intents/{paymentIntentId}/attach", content);
            var result = await response.Content.ReadAsStringAsync();
            
            Console.WriteLine($"PayMongo AttachPaymentIntent Response: {result}");
            
            if (!response.IsSuccessStatusCode)
            {
                Console.WriteLine($"AttachPaymentIntent failed: {result}");
                return (false, null);
            }

            // For GCash, extract the checkout URL from the response
            if (paymentType == "gcash")
            {
                var json = JsonDocument.Parse(result);
                var attributes = json.RootElement.GetProperty("data").GetProperty("attributes");
                
                if (attributes.TryGetProperty("next_action", out var nextAction) &&
                    nextAction.TryGetProperty("redirect", out var redirect) &&
                    redirect.TryGetProperty("url", out var url))
                {
                    var checkoutUrl = url.GetString();
                    Console.WriteLine($"GCash Checkout URL: {checkoutUrl}");
                    return (true, checkoutUrl);
                }
            }

            return (true, null);
        }

        public async Task<(string sourceId, string checkoutUrl)> CreateSource(decimal amount, string description)
        {
            return await CreateSourceWithRedirect(amount, description,
                $"{_appBaseUrl}/dashboard/account/billing?status=success",
                $"{_appBaseUrl}/dashboard/account/billing?status=failed");
        }

        public async Task<(string sourceId, string checkoutUrl)> CreateSourceForPrepaidTopUp(decimal amount, int prepaidId, string description)
        {
            return await CreateSourceWithRedirect(amount, description,
                $"{_appBaseUrl}/dashboard/services/topup?status=success&prepaidId={prepaidId}",
                $"{_appBaseUrl}/dashboard/services/topup?status=failed&prepaidId={prepaidId}");
        }

        private async Task<(string sourceId, string checkoutUrl)> CreateSourceWithRedirect(decimal amount, string description, string successUrl, string failedUrl)
        {
            var payload = new
            {
                data = new
                {
                    attributes = new
                    {
                        amount = (int)(amount * 100),
                        redirect = new
                        {
                            success = successUrl,
                            failed = failedUrl
                        },
                        type = "gcash",
                        currency = "PHP",
                        description
                    }
                }
            };

            var content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("https://api.paymongo.com/v1/sources", content);
            var result = await response.Content.ReadAsStringAsync();
            
            Console.WriteLine($"Create Source Response: {result}");
            
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception($"PayMongo API error: {result}");
            }
            
            var json = JsonDocument.Parse(result);
            var data = json.RootElement.GetProperty("data");
            var sourceId = data.GetProperty("id").GetString()!;
            
            var attributes = data.GetProperty("attributes");
            string? checkoutUrl = null;
            
            if (attributes.TryGetProperty("redirect", out var redirect))
            {
                if (redirect.TryGetProperty("checkout_url", out var url))
                {
                    checkoutUrl = url.GetString();
                }
            }
            
            if (string.IsNullOrEmpty(checkoutUrl))
            {
                Console.WriteLine($"WARNING: No checkout URL found in PayMongo response. Full response: {result}");
                throw new Exception($"PayMongo did not return a checkout URL. Response: {result}");
            }
            
            return (sourceId, checkoutUrl);
        }

        public async Task<string> CreatePayment(string sourceId, decimal amount, string description)
        {
            var payload = new
            {
                data = new
                {
                    attributes = new
                    {
                        amount = (int)(amount * 100),
                        source = new
                        {
                            id = sourceId,
                            type = "source"
                        },
                        currency = "PHP",
                        description
                    }
                }
            };

            var content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("https://api.paymongo.com/v1/payments", content);
            var result = await response.Content.ReadAsStringAsync();
            
            Console.WriteLine($"Create Payment Response: {result}");
            
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception($"PayMongo API error: {result}");
            }
            
            var json = JsonDocument.Parse(result);
            var paymentId = json.RootElement.GetProperty("data").GetProperty("id").GetString()!;
            return paymentId;
        }

        public async Task<string> GetSourceStatus(string sourceId)
        {
            var response = await _httpClient.GetAsync($"https://api.paymongo.com/v1/sources/{sourceId}");
            var result = await response.Content.ReadAsStringAsync();
            
            if (!response.IsSuccessStatusCode)
            {
                throw new Exception($"PayMongo API error: {result}");
            }
            
            var json = JsonDocument.Parse(result);
            var status = json.RootElement.GetProperty("data").GetProperty("attributes").GetProperty("status").GetString();
            return status!;
        }

        public async Task<bool> CapturePaymentIntent(string paymentIntentId)
        {
            // Check current status first
            var statusResponse = await _httpClient.GetAsync($"https://api.paymongo.com/v1/payment_intents/{paymentIntentId}");
            var statusResult = await statusResponse.Content.ReadAsStringAsync();
            Console.WriteLine($"Status check: {statusResult}");
            
            if (statusResponse.IsSuccessStatusCode)
            {
                var json = JsonDocument.Parse(statusResult);
                var status = json.RootElement.GetProperty("data").GetProperty("attributes").GetProperty("status").GetString();
                Console.WriteLine($"Current status: {status}");
                
                // If already succeeded, no need to capture
                if (status == "succeeded")
                {
                    return true;
                }
                
                // Only capture if awaiting_capture
                if (status == "awaiting_capture")
                {
                    var content = new StringContent("{}", Encoding.UTF8, "application/json");
                    var response = await _httpClient.PostAsync($"https://api.paymongo.com/v1/payment_intents/{paymentIntentId}/capture", content);
                    var result = await response.Content.ReadAsStringAsync();
                    
                    Console.WriteLine($"Capture response: {result}");
                    
                    if (!response.IsSuccessStatusCode)
                    {
                        throw new Exception($"Capture error: {result}");
                    }
                    
                    return true;
                }
            }
            
            return true;
        }
    }

    public class PaymentDetails
    {
        public string CardNumber { get; set; } = string.Empty;
        public int ExpMonth { get; set; }
        public int ExpYear { get; set; }
        public string Cvc { get; set; } = string.Empty;
    }
}
