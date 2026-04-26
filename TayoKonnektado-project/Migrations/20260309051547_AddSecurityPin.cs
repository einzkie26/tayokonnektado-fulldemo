using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TayoKonnektado_project.Migrations
{
    /// <inheritdoc />
    public partial class AddSecurityPin : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "PinProtectionEnabled",
                table: "AspNetUsers",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "SecurityPin",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PinProtectionEnabled",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "SecurityPin",
                table: "AspNetUsers");
        }
    }
}
