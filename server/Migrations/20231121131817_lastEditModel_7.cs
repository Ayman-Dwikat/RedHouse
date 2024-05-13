using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RedHouse_Server.Migrations
{
    /// <inheritdoc />
    public partial class lastEditModel_7 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_SavedProperties_Users_UserId",
                table: "SavedProperties");

            migrationBuilder.DropIndex(
                name: "IX_SavedProperties_UserId",
                table: "SavedProperties");

            migrationBuilder.AddColumn<int>(
                name: "LocationId",
                table: "Neighborhoods",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "PropertyId",
                table: "Neighborhoods",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Neighborhoods_LocationId",
                table: "Neighborhoods",
                column: "LocationId");

            migrationBuilder.CreateIndex(
                name: "IX_Neighborhoods_PropertyId",
                table: "Neighborhoods",
                column: "PropertyId");

            migrationBuilder.AddForeignKey(
                name: "FK_Neighborhoods_Locations_LocationId",
                table: "Neighborhoods",
                column: "LocationId",
                principalTable: "Locations",
                principalColumn: "Id",
                onDelete: ReferentialAction.NoAction);

            migrationBuilder.AddForeignKey(
                name: "FK_Neighborhoods_Properties_PropertyId",
                table: "Neighborhoods",
                column: "PropertyId",
                principalTable: "Properties",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Neighborhoods_Locations_LocationId",
                table: "Neighborhoods");

            migrationBuilder.DropForeignKey(
                name: "FK_Neighborhoods_Properties_PropertyId",
                table: "Neighborhoods");

            migrationBuilder.DropIndex(
                name: "IX_Neighborhoods_LocationId",
                table: "Neighborhoods");

            migrationBuilder.DropIndex(
                name: "IX_Neighborhoods_PropertyId",
                table: "Neighborhoods");

            migrationBuilder.DropColumn(
                name: "LocationId",
                table: "Neighborhoods");

            migrationBuilder.DropColumn(
                name: "PropertyId",
                table: "Neighborhoods");

            migrationBuilder.CreateIndex(
                name: "IX_SavedProperties_UserId",
                table: "SavedProperties",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_SavedProperties_Users_UserId",
                table: "SavedProperties",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
