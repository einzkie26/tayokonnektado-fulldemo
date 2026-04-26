using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TayoKonnektado_project.Migrations
{
    /// <inheritdoc />
    public partial class RemoveSubscriptionPlanUserRelationship : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
                IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_SubscriptionPlans_AspNetUsers_UserID')
                    ALTER TABLE [SubscriptionPlans] DROP CONSTRAINT [FK_SubscriptionPlans_AspNetUsers_UserID];
            ");

            migrationBuilder.Sql(@"
                IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SubscriptionPlans_UserID' AND object_id = OBJECT_ID('SubscriptionPlans'))
                    DROP INDEX [IX_SubscriptionPlans_UserID] ON [SubscriptionPlans];
            ");

            migrationBuilder.Sql(@"
                IF EXISTS (SELECT * FROM sys.columns WHERE name = 'UserID' AND object_id = OBJECT_ID('SubscriptionPlans'))
                    ALTER TABLE [SubscriptionPlans] DROP COLUMN [UserID];
            ");

            migrationBuilder.Sql(@"
                IF NOT EXISTS (SELECT * FROM sys.columns WHERE name = 'DeviceName' AND object_id = OBJECT_ID('Subscriptions'))
                    ALTER TABLE [Subscriptions] ADD [DeviceName] nvarchar(max) NULL;
            ");

            migrationBuilder.Sql(@"
                IF NOT EXISTS (SELECT * FROM sys.columns WHERE name = 'Price' AND object_id = OBJECT_ID('SubscriptionPlans'))
                    ALTER TABLE [SubscriptionPlans] ADD [Price] decimal(18,2) NULL;
            ");

            migrationBuilder.Sql(@"
                IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Addons')
                BEGIN
                    CREATE TABLE [Addons] (
                        [AddonID] int NOT NULL IDENTITY,
                        [Name] nvarchar(max) NOT NULL,
                        [Description] nvarchar(max) NULL,
                        [Price] decimal(18,2) NOT NULL,
                        [BillingType] nvarchar(max) NOT NULL,
                        [Icon] nvarchar(max) NULL,
                        [Features] nvarchar(max) NULL,
                        CONSTRAINT [PK_Addons] PRIMARY KEY ([AddonID])
                    );
                END
            ");

            migrationBuilder.Sql(@"
                IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'UserAddons')
                BEGIN
                    CREATE TABLE [UserAddons] (
                        [UserAddonID] int NOT NULL IDENTITY,
                        [UserID] nvarchar(450) NOT NULL,
                        [AddonID] int NOT NULL,
                        [ActivatedAt] datetime2 NOT NULL,
                        [NextBillingDate] datetime2 NULL,
                        [Status] nvarchar(max) NOT NULL,
                        CONSTRAINT [PK_UserAddons] PRIMARY KEY ([UserAddonID]),
                        CONSTRAINT [FK_UserAddons_Addons_AddonID] FOREIGN KEY ([AddonID]) REFERENCES [Addons] ([AddonID]) ON DELETE CASCADE,
                        CONSTRAINT [FK_UserAddons_AspNetUsers_UserID] FOREIGN KEY ([UserID]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
                    );
                    CREATE INDEX [IX_UserAddons_AddonID] ON [UserAddons] ([AddonID]);
                    CREATE INDEX [IX_UserAddons_UserID] ON [UserAddons] ([UserID]);
                END
            ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UserAddons");

            migrationBuilder.DropTable(
                name: "Addons");

            migrationBuilder.DropColumn(
                name: "DeviceName",
                table: "Subscriptions");

            migrationBuilder.DropColumn(
                name: "Price",
                table: "SubscriptionPlans");

            migrationBuilder.AddColumn<string>(
                name: "UserID",
                table: "SubscriptionPlans",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_SubscriptionPlans_UserID",
                table: "SubscriptionPlans",
                column: "UserID");

            migrationBuilder.AddForeignKey(
                name: "FK_SubscriptionPlans_AspNetUsers_UserID",
                table: "SubscriptionPlans",
                column: "UserID",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
