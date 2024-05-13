
namespace RedHouse_Server.Dtos.UserHistoryDtos{
   public class UserHistoryDto
    {

      public int Id { get; set; }

        public int ContractId { get; set; }
        public string FeedbackToLandlord { get; set; }
        public string FeedbackToCustomer { get; set; }

        public int CustomerRating { get; set; }
        public int LandlordRating { get; set; }
    }
}
