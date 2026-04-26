using Microsoft.EntityFrameworkCore;
using TayoKonnektado_project.Data;
using TayoKonnektado_project.Models;

namespace TayoKonnektado_project.Services.Admin
{
    public class FAQManagementService
    {
        private readonly ApplicationDbContext _context;

        public FAQManagementService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<FAQ>> GetAllFAQsAsync()
        {
            return await _context.FAQs.OrderByDescending(f => f.CreatedAt).ToListAsync();
        }

        public async Task<bool> CreateFAQAsync(string question, string answer, string category, string status)
        {
            var faq = new FAQ
            {
                Question = question,
                Answer = answer,
                Category = category,
                Status = status
            };
            _context.FAQs.Add(faq);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdateFAQAsync(int id, string question, string answer, string category, string status)
        {
            var faq = await _context.FAQs.FindAsync(id);
            if (faq == null) return false;

            faq.Question = question;
            faq.Answer = answer;
            faq.Category = category;
            faq.Status = status;
            faq.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteFAQAsync(int id)
        {
            var faq = await _context.FAQs.FindAsync(id);
            if (faq == null) return false;

            _context.FAQs.Remove(faq);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
