using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RedHouse_Server.Migrations
{
    /// <inheritdoc />
    public partial class lastEditModel_61 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "LawerId",
                table: "Contracts",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Offers_UserCreatedId",
                table: "Offers",
                column: "UserCreatedId");

            migrationBuilder.CreateIndex(
                name: "IX_Contracts_LawerId",
                table: "Contracts",
                column: "LawerId");

            migrationBuilder.AddForeignKey(
                name: "FK_Contracts_Users_LawerId",
                table: "Contracts",
                column: "LawerId",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Offers_Users_UserCreatedId",
                table: "Offers",
                column: "UserCreatedId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.NoAction);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Contracts_Users_LawerId",
                table: "Contracts");

            migrationBuilder.DropForeignKey(
                name: "FK_Offers_Users_UserCreatedId",
                table: "Offers");

            migrationBuilder.DropIndex(
                name: "IX_Offers_UserCreatedId",
                table: "Offers");

            migrationBuilder.DropIndex(
                name: "IX_Contracts_LawerId",
                table: "Contracts");

            migrationBuilder.DropColumn(
                name: "LawerId",
                table: "Contracts");
        }
    }
}
