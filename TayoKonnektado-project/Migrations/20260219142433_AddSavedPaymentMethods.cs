using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TayoKonnektado_project.Migrations
{
    /// <inheritdoc />
    public partial class AddSavedPaymentMethods : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "SavedPaymentMethods",
                columns: table => new
                {
                    PaymentMethodID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    PayMongoPaymentMethodId = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Type = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Last4 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Brand = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ExpMonth = table.Column<int>(type: "int", nullable: true),
                    ExpYear = table.Column<int>(type: "int", nullable: true),
                    IsDefault = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SavedPaymentMethods", x => x.PaymentMethodID);
                    table.ForeignKey(
                        name: "FK_SavedPaymentMethods_AspNetUsers_UserID",
                        column: x => x.UserID,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_SavedPaymentMethods_UserID",
                table: "SavedPaymentMethods",
                column: "UserID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "SavedPaymentMethods");
        }
    }
}
