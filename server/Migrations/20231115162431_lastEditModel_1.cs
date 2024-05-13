using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RedHouse_Server.Migrations
{
    /// <inheritdoc />
    public partial class lastEditModel_1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            
            migrationBuilder.CreateTable(
                name: "Offers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    LandlordId = table.Column<int>(type: "int", nullable: false),
                    CustomerId = table.Column<int>(type: "int", nullable: false),
                    OfferDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    OfferExpires = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Price = table.Column<double>(type: "float", nullable: false),
                    OfferStatus = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Offers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Offers_Users_CustomerId",
                        column: x => x.CustomerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction);
                    table.ForeignKey(
                        name: "FK_Offers_Users_LandlordId",
                        column: x => x.LandlordId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction);
                });

           

            migrationBuilder.CreateTable(
                name: "Contracts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OfferId = table.Column<int>(type: "int", nullable: false),
                    PropertyId = table.Column<int>(type: "int", nullable: false),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ContractType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ContractStatus = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Earnings = table.Column<double>(type: "float", nullable: false),
                    IsShouldPay = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Contracts", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Contracts_Offers_OfferId",
                        column: x => x.OfferId,
                        principalTable: "Offers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Contracts_Properties_PropertyId",
                        column: x => x.PropertyId,
                        principalTable: "Properties",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            
            migrationBuilder.CreateTable(
                name: "UserHistoryRecords",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ContractId = table.Column<int>(type: "int", nullable: false),
                    FeedbackToLandlord = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    FeedbackToCustomer = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CustomerRating = table.Column<int>(type: "int", nullable: false),
                    LandlordRating = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserHistoryRecords", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserHistoryRecords_Contracts_ContractId",
                        column: x => x.ContractId,
                        principalTable: "Contracts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

           
            migrationBuilder.CreateIndex(
                name: "IX_Contracts_OfferId",
                table: "Contracts",
                column: "OfferId");

            migrationBuilder.CreateIndex(
                name: "IX_Contracts_PropertyId",
                table: "Contracts",
                column: "PropertyId");

            migrationBuilder.CreateIndex(
                name: "IX_Offers_CustomerId",
                table: "Offers",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_Offers_LandlordId",
                table: "Offers",
                column: "LandlordId");

          

            migrationBuilder.CreateIndex(
                name: "IX_UserHistoryRecords_ContractId",
                table: "UserHistoryRecords",
                column: "ContractId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            
            migrationBuilder.DropTable(
                name: "UserHistoryRecords");

            migrationBuilder.DropTable(
                name: "Contracts");

            migrationBuilder.DropTable(
                name: "Offers");


        }
    }
}
