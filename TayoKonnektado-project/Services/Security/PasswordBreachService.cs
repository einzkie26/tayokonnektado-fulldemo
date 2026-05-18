using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text;

namespace TayoKonnektado_project.Services.Security
{
    public class PasswordBreachService
    {
        private readonly HttpClient _httpClient;

        public PasswordBreachService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<bool> IsBreachedAsync(string password, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(password))
                return false;

            var hash = ComputeSha1(password);
            var prefix = hash[..5];
            var suffix = hash[5..];

            var request = new HttpRequestMessage(HttpMethod.Get, $"https://api.pwnedpasswords.com/range/{prefix}");
            request.Headers.UserAgent.Add(new ProductInfoHeaderValue("TayoKonnektado", "1.0"));

            var response = await _httpClient.SendAsync(request, cancellationToken);
            if (!response.IsSuccessStatusCode)
                return false;

            var body = await response.Content.ReadAsStringAsync(cancellationToken);
            var lines = body.Split('\n', StringSplitOptions.RemoveEmptyEntries);

            foreach (var line in lines)
            {
                var parts = line.Trim().Split(':');
                if (parts.Length < 2) continue;
                if (string.Equals(parts[0], suffix, StringComparison.OrdinalIgnoreCase))
                    return true;
            }

            return false;
        }

        private static string ComputeSha1(string input)
        {
            using var sha1 = SHA1.Create();
            var bytes = sha1.ComputeHash(Encoding.UTF8.GetBytes(input));
            var sb = new StringBuilder(bytes.Length * 2);
            foreach (var b in bytes)
                sb.Append(b.ToString("X2"));
            return sb.ToString();
        }
    }
}
