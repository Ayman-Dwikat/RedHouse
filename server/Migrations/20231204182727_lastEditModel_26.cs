using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RedHouse_Server.Migrations
{
    /// <inheritdoc />
    public partial class lastEditModel_26 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "User",
                table: "UserIdentities");

            migrationBuilder.CreateIndex(
                name: "IX_UserIdentities_UserId",
                table: "UserIdentities",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_UserIdentities_Users_UserId",
                table: "UserIdentities",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
                
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserIdentities_Users_UserId",
                table: "UserIdentities");

            migrationBuilder.DropIndex(
                name: "IX_UserIdentities_UserId",
                table: "UserIdentities");

            migrationBuilder.AddColumn<int>(
                name: "User",
                table: "UserIdentities",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }
    }
}
