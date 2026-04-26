using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TayoKonnektado_project.Models;
using TayoKonnektado_project.Services;

namespace TayoKonnektado_project.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class PaymentController : ControllerBase
    {
        private readonly PayMongoService _payMongoService;

        public PaymentController(PayMongoService payMongoService)
        {
            _payMongoService = payMongoService;
        }

        [HttpPost("create")]
        public async Task<IActionResult> CreatePayment([FromBody] PaymentRequest request)
        {
            return Ok(new { message = "Payment endpoint deprecated" });
        }
    }
}
