using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TayoKonnektado_project.Migrations
{
    /// <inheritdoc />
    public partial class AddPrepaidPromos : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Subscriptions_ServiceAccounts_ServiceAccountID",
                table: "Subscriptions");

            migrationBuilder.CreateTable(
                name: "PrepaidPromos",
                columns: table => new
                {
                    PrepaidPromoID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PrepaidLoadID = table.Column<int>(type: "int", nullable: false),
                    UserID = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    PromoTitle = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    TotalDataMB = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    RemainingDataMB = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    ValidityDays = table.Column<int>(type: "int", nullable: false),
                    ActivatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ExpiresAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PrepaidPromos", x => x.PrepaidPromoID);
                    table.ForeignKey(
                        name: "FK_PrepaidPromos_AspNetUsers_UserID",
                        column: x => x.UserID,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_PrepaidPromos_PrepaidLoads_PrepaidLoadID",
                        column: x => x.PrepaidLoadID,
                        principalTable: "PrepaidLoads",
                        principalColumn: "PrepaidLoadID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_PrepaidPromos_PrepaidLoadID",
                table: "PrepaidPromos",
                column: "PrepaidLoadID");

            migrationBuilder.CreateIndex(
                name: "IX_PrepaidPromos_UserID",
                table: "PrepaidPromos",
                column: "UserID");

            migrationBuilder.AddForeignKey(
                name: "FK_Subscriptions_ServiceAccounts_ServiceAccountID",
                table: "Subscriptions",
                column: "ServiceAccountID",
                principalTable: "ServiceAccounts",
                principalColumn: "ServiceAccountID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Subscriptions_ServiceAccounts_ServiceAccountID",
                table: "Subscriptions");

            migrationBuilder.DropTable(
                name: "PrepaidPromos");

            migrationBuilder.AddForeignKey(
                name: "FK_Subscriptions_ServiceAccounts_ServiceAccountID",
                table: "Subscriptions",
                column: "ServiceAccountID",
                principalTable: "ServiceAccounts",
                principalColumn: "ServiceAccountID",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
