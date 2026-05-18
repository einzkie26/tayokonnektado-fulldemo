namespace TayoKonnektado_project.Models
{
    public class SecuritySettings
    {
        public List<string> BlockedIPs { get; set; } = new();
        public List<string> BlockedUserAgents { get; set; } = new();
        public int MaxFailedAttemptsPerIp { get; set; } = 10;
        public int MaxFailedAttemptsPerDevice { get; set; } = 10;
        public int BlockMinutes { get; set; } = 15;
    }
}
