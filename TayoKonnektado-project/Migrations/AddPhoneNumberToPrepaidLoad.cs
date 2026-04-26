using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TayoKonnektado_project.Migrations
{
    public partial class AddPhoneNumberToPrepaidLoad : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "PhoneNumber",
                table: "PrepaidLoads",
                type: "nvarchar(max)",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PhoneNumber",
                table: "PrepaidLoads");
        }
    }
}
