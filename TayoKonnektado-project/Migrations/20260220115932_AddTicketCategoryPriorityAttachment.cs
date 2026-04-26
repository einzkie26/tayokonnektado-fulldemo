using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TayoKonnektado_project.Migrations
{
    /// <inheritdoc />
    public partial class AddTicketCategoryPriorityAttachment : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "AttachmentUrl",
                table: "SupportTickets",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Category",
                table: "SupportTickets",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Priority",
                table: "SupportTickets",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AttachmentUrl",
                table: "SupportTickets");

            migrationBuilder.DropColumn(
                name: "Category",
                table: "SupportTickets");

            migrationBuilder.DropColumn(
                name: "Priority",
                table: "SupportTickets");
        }
    }
}
