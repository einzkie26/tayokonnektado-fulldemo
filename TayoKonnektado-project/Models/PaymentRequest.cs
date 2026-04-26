namespace TayoKonnektado_project.Models
{
    public class PaymentRequest
    {
        public decimal Amount { get; set; }
        public string Description { get; set; } = string.Empty;
        public string CustomerEmail { get; set; } = string.Empty;
        public string CustomerName { get; set; } = string.Empty;
        public string PaymentMethod { get; set; } = "card,gcash,paymaya"; // Support multiple methods
    }

    public class PaymentResponse
    {
        public string PaymentId { get; set; } = string.Empty;
        public string CheckoutUrl { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
    }
}
