using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RedHouse_Server.Migrations
{
    /// <inheritdoc />
    public partial class addemodelsm1_70 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Contracts_Users_LawerId",
                table: "Contracts");

            migrationBuilder.RenameColumn(
                name: "LawerId",
                table: "Contracts",
                newName: "LawyerId");

            migrationBuilder.RenameIndex(
                name: "IX_Contracts_LawerId",
                table: "Contracts",
                newName: "IX_Contracts_LawyerId");

            migrationBuilder.AddForeignKey(
                name: "FK_Contracts_Users_LawyerId",
                table: "Contracts",
                column: "LawyerId",
                principalTable: "Users",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Contracts_Users_LawyerId",
                table: "Contracts");

            migrationBuilder.RenameColumn(
                name: "LawyerId",
                table: "Contracts",
                newName: "LawerId");

            migrationBuilder.RenameIndex(
                name: "IX_Contracts_LawyerId",
                table: "Contracts",
                newName: "IX_Contracts_LawerId");

            migrationBuilder.AddForeignKey(
                name: "FK_Contracts_Users_LawerId",
                table: "Contracts",
                column: "LawerId",
                principalTable: "Users",
                principalColumn: "Id");
        }
    }
}
