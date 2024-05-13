using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RedHouse_Server.Migrations
{
    /// <inheritdoc />
    public partial class lastEditModel_2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Contracts_Properties_PropertyId",
                table: "Contracts");

            migrationBuilder.DropIndex(
                name: "IX_Contracts_PropertyId",
                table: "Contracts");

            migrationBuilder.DropColumn(
                name: "PropertyId",
                table: "Contracts");

            migrationBuilder.AddColumn<int>(
                name: "PropertyId",
                table: "Offers",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_SavedProperties_UserId",
                table: "SavedProperties",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Offers_PropertyId",
                table: "Offers",
                column: "PropertyId");

            migrationBuilder.CreateIndex(
                name: "IX_Milestones_ContractId",
                table: "Milestones",
                column: "ContractId");

            migrationBuilder.CreateIndex(
                name: "IX_ContractActivities_ContractId",
                table: "ContractActivities",
                column: "ContractId");

            migrationBuilder.AddForeignKey(
                name: "FK_ContractActivities_Contracts_ContractId",
                table: "ContractActivities",
                column: "ContractId",
                principalTable: "Contracts",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Milestones_Contracts_ContractId",
                table: "Milestones",
                column: "ContractId",
                principalTable: "Contracts",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Offers_Properties_PropertyId",
                table: "Offers",
                column: "PropertyId",
                principalTable: "Properties",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_SavedProperties_Users_UserId",
                table: "SavedProperties",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ContractActivities_Contracts_ContractId",
                table: "ContractActivities");

            migrationBuilder.DropForeignKey(
                name: "FK_Milestones_Contracts_ContractId",
                table: "Milestones");

            migrationBuilder.DropForeignKey(
                name: "FK_Offers_Properties_PropertyId",
                table: "Offers");

            migrationBuilder.DropForeignKey(
                name: "FK_SavedProperties_Users_UserId",
                table: "SavedProperties");

            migrationBuilder.DropIndex(
                name: "IX_SavedProperties_UserId",
                table: "SavedProperties");

            migrationBuilder.DropIndex(
                name: "IX_Offers_PropertyId",
                table: "Offers");

            migrationBuilder.DropIndex(
                name: "IX_Milestones_ContractId",
                table: "Milestones");

            migrationBuilder.DropIndex(
                name: "IX_ContractActivities_ContractId",
                table: "ContractActivities");

            migrationBuilder.DropColumn(
                name: "PropertyId",
                table: "Offers");

            migrationBuilder.AddColumn<int>(
                name: "PropertyId",
                table: "Contracts",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Contracts_PropertyId",
                table: "Contracts",
                column: "PropertyId");

            migrationBuilder.AddForeignKey(
                name: "FK_Contracts_Properties_PropertyId",
                table: "Contracts",
                column: "PropertyId",
                principalTable: "Properties",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
