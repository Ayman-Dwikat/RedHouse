using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RedHouse_Server.Migrations
{
    /// <inheritdoc />
    public partial class lastEditModel_4 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "MilestoneType",
                table: "Milestones",
                newName: "MilestoneStatus");

            migrationBuilder.RenameColumn(
                name: "MilestoneBudget",
                table: "Milestones",
                newName: "Amount");

            migrationBuilder.AddColumn<string>(
                name: "Description",
                table: "Milestones",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "MilestoneName",
                table: "Milestones",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Description",
                table: "Milestones");

            migrationBuilder.DropColumn(
                name: "MilestoneName",
                table: "Milestones");

            migrationBuilder.RenameColumn(
                name: "MilestoneStatus",
                table: "Milestones",
                newName: "MilestoneType");

            migrationBuilder.RenameColumn(
                name: "Amount",
                table: "Milestones",
                newName: "MilestoneBudget");
        }
    }
}
