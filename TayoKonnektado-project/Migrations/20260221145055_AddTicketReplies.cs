using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TayoKonnektado_project.Migrations
{
    /// <inheritdoc />
    public partial class AddTicketReplies : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "TicketReplies",
                columns: table => new
                {
                    ReplyID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TicketID = table.Column<int>(type: "int", nullable: false),
                    UserID = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsAdminReply = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TicketReplies", x => x.ReplyID);
                    table.ForeignKey(
                        name: "FK_TicketReplies_AspNetUsers_UserID",
                        column: x => x.UserID,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_TicketReplies_SupportTickets_TicketID",
                        column: x => x.TicketID,
                        principalTable: "SupportTickets",
                        principalColumn: "TicketID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_TicketReplies_TicketID",
                table: "TicketReplies",
                column: "TicketID");

            migrationBuilder.CreateIndex(
                name: "IX_TicketReplies_UserID",
                table: "TicketReplies",
                column: "UserID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "TicketReplies");
        }
    }
}
