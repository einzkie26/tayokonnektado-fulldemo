using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TayoKonnektado_project.Migrations
{
    /// <inheritdoc />
    public partial class AddIsArchivedToPayment : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsArchived",
                table: "Payments",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsArchived",
                table: "Payments");
        }
    }
}
