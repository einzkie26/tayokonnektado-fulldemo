using System.Collections.Concurrent;
using Microsoft.Extensions.Options;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services.Security
{
    public class IpDeviceReputationService
    {
        private readonly SecuritySettings _settings;
        private readonly ConcurrentDictionary<string, FailureWindow> _ipFailures = new();
        private readonly ConcurrentDictionary<string, FailureWindow> _deviceFailures = new();

        public IpDeviceReputationService(IOptions<SecuritySettings> options)
        {
            _settings = options.Value;
        }

        public bool IsBlocked(string? ip, string? userAgent, out string reason)
        {
            reason = string.Empty;

            if (!string.IsNullOrWhiteSpace(ip) && _settings.BlockedIPs.Any(b => string.Equals(b, ip, StringComparison.OrdinalIgnoreCase)))
            {
                reason = "IP blocked";
                return true;
            }

            if (!string.IsNullOrWhiteSpace(userAgent) && _settings.BlockedUserAgents.Any(b => userAgent.Contains(b, StringComparison.OrdinalIgnoreCase)))
            {
                reason = "Device blocked";
                return true;
            }

            if (!string.IsNullOrWhiteSpace(ip) && _ipFailures.TryGetValue(ip, out var ipWindow) && ipWindow.BlockedUntilUtc > DateTime.UtcNow)
            {
                reason = "Too many failed attempts";
                return true;
            }

            var deviceKey = BuildDeviceKey(ip, userAgent);
            if (!string.IsNullOrWhiteSpace(deviceKey) && _deviceFailures.TryGetValue(deviceKey, out var deviceWindow) && deviceWindow.BlockedUntilUtc > DateTime.UtcNow)
            {
                reason = "Too many failed attempts";
                return true;
            }

            return false;
        }

        public void RegisterFailure(string? ip, string? userAgent)
        {
            if (!string.IsNullOrWhiteSpace(ip))
            {
                var window = _ipFailures.GetOrAdd(ip, _ => new FailureWindow());
                window.RegisterFailure(_settings.MaxFailedAttemptsPerIp, TimeSpan.FromMinutes(_settings.BlockMinutes));
            }

            var deviceKey = BuildDeviceKey(ip, userAgent);
            if (!string.IsNullOrWhiteSpace(deviceKey))
            {
                var window = _deviceFailures.GetOrAdd(deviceKey, _ => new FailureWindow());
                window.RegisterFailure(_settings.MaxFailedAttemptsPerDevice, TimeSpan.FromMinutes(_settings.BlockMinutes));
            }
        }

        public void RegisterSuccess(string? ip, string? userAgent)
        {
            if (!string.IsNullOrWhiteSpace(ip))
                _ipFailures.TryRemove(ip, out _);

            var deviceKey = BuildDeviceKey(ip, userAgent);
            if (!string.IsNullOrWhiteSpace(deviceKey))
                _deviceFailures.TryRemove(deviceKey, out _);
        }

        private static string BuildDeviceKey(string? ip, string? userAgent)
        {
            if (string.IsNullOrWhiteSpace(ip) || string.IsNullOrWhiteSpace(userAgent))
                return string.Empty;

            return $"{ip}:{userAgent}".ToLowerInvariant();
        }

        private sealed class FailureWindow
        {
            private int _count;
            private DateTime _windowStartUtc = DateTime.UtcNow;
            public DateTime BlockedUntilUtc { get; private set; } = DateTime.MinValue;

            public void RegisterFailure(int maxAttempts, TimeSpan blockDuration)
            {
                var now = DateTime.UtcNow;

                if (now - _windowStartUtc > TimeSpan.FromMinutes(10))
                {
                    _windowStartUtc = now;
                    _count = 0;
                }

                _count++;

                if (_count >= maxAttempts)
                {
                    BlockedUntilUtc = now.Add(blockDuration);
                }
            }
        }
    }
}
