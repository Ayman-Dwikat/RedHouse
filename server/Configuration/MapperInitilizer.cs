using AutoMapper;

using Cooking_School.Core.ModelUsed;
using RedHouse_Server.Models;
using static System.Runtime.InteropServices.JavaScript.JSType;
using RedHouse_Server.Dtos.AuthDtos;

namespace Cooking_School_ASP.NET.Configurations
{
    public class MapperInitilizer : Profile
    {
        public MapperInitilizer()
        {
            CreateMap<RegisterDto, User>();

            //CreateMap<Chef, ChefDTO>();
            //CreateMap<Chef, UpdateChefDto>()
            //    .ForMember(c => c.Cv, option => option.Ignore())
            //    .ForMember(c => c.Password, option => option.Ignore());
            //CreateMap<CreateChefDto, Chef>()
            //    .ForMember(c => c.PasswordHashed, option => option.Ignore())
            //    .ForMember(c => c.PasswordSlot, option => option.Ignore())
            //    .ForMember(c => c.Created, option => option.Ignore())
            //    .ForMember(c => c.CvPath, option => option.Ignore());

            //CreateMap<TraineeDTO, Trainee>().ReverseMap();
            //CreateMap<Trainee, UpdateTraineeDto>()
            //    .ForMember(c => c.image, option => option.Ignore())
            //    .ForMember(c => c.Password, option => option.Ignore());
            //CreateMap<CreateTraineeDto, Trainee>()
            //    .ForMember(t => t.Created, option => option.Ignore())
            //    .ForMember(t => t.ImagePath, option => option.Ignore())
            //    .ForMember(t => t.PasswordHashed, option => option.Ignore())
            //    .ForMember(t => t.PasswordSlot, option => option.Ignore());

            //CreateMap<CourseDTO, Course>().ReverseMap();
            //CreateMap<CreateCourseDto, Course>()
            //    .ForMember(t => t.Created, option => option.Ignore());
            //CreateMap<UpdateCourseDto, CourseDTO>().ReverseMap();
            //CreateMap<UpdateCourseDto, Course>().ReverseMap();

            //CreateMap<CookClassDTO, CookClass>();
            //CreateMap<CookClass, CookClassDTO>()
            //    .ForMember(t => t.ClassDays, option => option.Ignore());
            //CreateMap<CreateCookClassDto, CookClass>()
            //    .ForMember(t => t.Created, option => option.Ignore())
            //    .ForMember(t => t.ClassDays, option => option.Ignore());



            //CreateMap<ApplicationDTO, ApplicationT>().ReverseMap();
            //CreateMap<CreateApplicationDto, ApplicationT>()
            //    .ForMember(t => t.Created, option => option.Ignore())
            //    .ForMember(a => a.DateOfApplay, option => option.Ignore());

            //CreateMap<ProjectDTO, Project>().ReverseMap();
            //CreateMap<CreateProjectDto, Project>()
            //    .ForMember(t => t.Created, option => option.Ignore());

            //CreateMap<SubmitedFileDTO, ProjectFile>().ReverseMap();

            //CreateMap<SubmitedFileDTO, ProjectTraineeFile>().ReverseMap();
            //CreateMap<CreateSubmitedFileDto, ProjectTraineeFile>()
            //    .ForMember(t => t.Created, option => option.Ignore());

            //CreateMap<User, UserDTO>().ReverseMap();
            //CreateMap<CreateUserDto, User>()
            //    .ForMember(t => t.Created, option => option.Ignore());
            //CreateMap<FavoriteChefDto, User>().ReverseMap();


            //CreateMap<ClassDays, ClassDaysDTO>()
            //    .ForMember(t => t.Days, option => option.Ignore());
            //CreateMap<CreateClassDaysDto, ClassDays>()
            //    .ForMember(t => t.Created, option => option.Ignore());

            //CreateMap<CreateAdminDto, Admin>()
            //.ForMember(t => t.Created, option => option.Ignore());
            //CreateMap<Admin, AdminDTO>().ReverseMap();
            //CreateMap<Admin, UpdateAdminDto>();

        }
    }
}