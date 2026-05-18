using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ActivityController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public ActivityController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpPost("log")]
        public async Task<IActionResult> Log([FromBody] ActivityLogRequest request)
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrWhiteSpace(userId))
                return Unauthorized();

            if (string.IsNullOrWhiteSpace(request.Action))
                return BadRequest(new { message = "Action is required" });

            var finalAction = string.IsNullOrWhiteSpace(request.Details)
                ? request.Action.Trim()
                : $"{request.Action.Trim()} | {request.Details.Trim()}";

            _context.ActivityLogs.Add(new ActivityLog
            {
                UserID = userId,
                Action = finalAction,
                Type = string.IsNullOrWhiteSpace(request.Type) ? "Interaction" : request.Type.Trim(),
                IPAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
                Timestamp = DateTime.UtcNow
            });

            await _context.SaveChangesAsync();
            return Ok(new { message = "Activity logged" });
        }
    }

    public class ActivityLogRequest
    {
        public string Action { get; set; } = string.Empty;
        public string Type { get; set; } = "Interaction";
        public string? Details { get; set; }
    }
}
