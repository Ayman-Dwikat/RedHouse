import React, { useContext, useEffect, useState } from 'react'
import NavbarAdmin from '../components/Navbar/NavbarAdmin.jsx'
import Footer from '../components/Footer'
import '../styles/Admin.css'
import Posts from '../components/Post/Posts.jsx'
import SearchResultsList from '../components/SearchBar/SearchResultsList.jsx'
import FilterBar from '../components/SearchBar/FilterBar.jsx'
import UserList from '../components/Users/UserList.jsx'
import Navbar from '../components/Navbar/Navbar.jsx'
import { useRecoilState } from 'recoil'
import { categoryFilterQuery, languageFilterQuery } from '../state.js'
import SearchBar from '../components/SearchBar/SearchBar.jsx'
import axios from 'axios'
import { ToastContainer, toast } from 'react-toastify'
import { Link, Outlet, Route, Routes, useNavigate } from 'react-router-dom'
import Counter from '../components/Counter.jsx'
import Cookies from 'js-cookie'
import { AuthContext } from '../context/authContext.js'
import Swal from 'sweetalert2'
import { Sidebar, Menu, MenuItem, SubMenu, sidebarClasses, menuClasses } from 'react-pro-sidebar';
import { Line } from "react-chartjs-2";
import { Chart, CategoryScale } from 'chart.js';
import 'chart.js/auto';
import Statistics from '../menuItems/Statistics.jsx'
import Properties from '../menuItems/Properities.jsx'
import Contracts from '../menuItems/Contracts.jsx'
import Offers from '../menuItems/Offers.jsx'
import Users from '../menuItems/Users.jsx'
import Applications from '../menuItems/Applications.jsx'
import Agents from '../menuItems/Agents.jsx'
import UserComplaints from '../menuItems/UserComplaints.jsx'
import ComplaintsList from '../menuItems/ComplaintsList.jsx'
import PersonalVerificationRequests from '../menuItems/PersonalVerificationRequests.jsx'
import ContractDetails from '../menuItems/ContractDetails.jsx'



const Admin = () => {
  const navigate = useNavigate()
  const { currentUser } = useContext(AuthContext)
  const [visits, setVisits] = useState(0)
  const [numberOfVolunteers, setNumberOfVolunteers] = useState(0)
  const [numberOfPosts, setNumberOfPosts] = useState(0)
  const getCookie = (cookieName) => {
    const cookieValue = Cookies.get(cookieName);
    return cookieValue;
  }

  useEffect(() => {
    const fetchData = async () => {
      try {
        // Get the access token from a cookie named "access_token_tuulio"
        const currentCookie = getCookie("access_token_tuulio");

        // Check if the access token is available
        if (!currentCookie) {
          // Handle the case where the access token is missing or undefined
          console.log("Access token is missing.");
        }

        // Make an authenticated request using the access token
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/verifyUser/${currentCookie}`);

        // Process the response data if needed

        // Example: Log the response data
        console.log("Response data:", res.data);
      } catch (err) {
        if (err.message === 'Network Error' && !err.response) {
          // Handle network error
          toast.error('Network error - make sure the server is running!', {
            position: "top-center",
            autoClose: 10000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "dark",
          });
        } else if (err.response && err.response.status === 401) {
          // Handle unauthorized access (status code 401)
          if (currentUser) {
            console.log("Unauthorized access - redirecting to login.");
            navigate('/login');
          }
        } else {
          // Handle other errors
          console.error("An error occurred:", err);
        }
      }
    };
    const getVisits = async () => {
      try {
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/auth/visits`);
        setVisits(res.data)
        console.log(res);
      } catch (err) {
        if (err && err.message == 'Network Error' && !err.response)
          toast.error('Network error - make sure server is running!', {
            position: "top-center",
            autoClose: 10000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "colored",
          });
        if (err && err.response.status == 401) {
          navigate('/login')
        }
        console.log(err)
      }
    }

    const getNumberOfPosts = async () => {
      try {
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/posts/numberOfPosts`);
        setNumberOfPosts(res.data)
        console.log(res);
      } catch (err) {
        if (err.message == 'Network Error' && !err.response)
          toast.error('Network error - make sure server is running!', {
            position: "top-center",
            autoClose: 10000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "colored",
          });
        if (err.response.status == 401) {
          navigate('/login')
        }
        console.log(err)
      }
    }


    const getNumberOfVolunteers = async () => {
      try {
        const result = await axios.get(`${process.env.REACT_APP_BASE_URL}/users/usersNumber`);
        setNumberOfVolunteers(result.data.total)
        console.log(result);
      } catch (err) {
        if (err.message == 'Network Error' && !err.response)
          toast.error('Network error - make sure server is running!', {
            position: "top-center",
            autoClose: 10000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "colored",
          });
        if (err.response.status == 401) {
          navigate('/login')
        }
        console.log(err)
      }
    }
    // fetchData()
    // getVisits()
    // getNumberOfVolunteers()
    // getNumberOfPosts()
  }, []);
  const [results, setResult] = useState([])
  const [languageFilter, setLanguageFilter] = useRecoilState(languageFilterQuery);


  const handleResetVisits = async () => {
    // Swal.fire({
    //   title: 'Are you sure you want to reset the number of visits?',
    //   showCancelButton: true,
    //   confirmButtonColor: '#00BF63',
    //   confirmButtonText: 'Reset',
    //   customClass: 'Custom_btn'
    // }).then(async (result) => {
    //   if (result.isConfirmed) {
    //     try {
    //       const res = await axios.delete("http://localhost:3007/api/auth/visits");
    //       if (res.status === 200) {
    //         Swal.fire('Success!', 'Number of visits has been reset.', 'success');
    //         // Optionally, you can update the UI to reflect the new state
    //         setVisits(0); // Assuming you have a state variable for visits
    //       } else {
    //         Swal.fire('Error', 'An error occurred while resetting visits.', 'error');
    //       }
    //     } catch (err) {
    //       if (err.message === 'Network Error' && !err.response) {
    //         toast.error('Network error - make sure the server is running!', {
    //           position: 'top-center',
    //           autoClose: 10000,
    //           hideProgressBar: false,
    //           closeOnClick: true,
    //           pauseOnHover: true,
    //           draggable: true,
    //           progress: undefined,
    //           theme: 'colored',
    //         });
    //       } else if (err.response && err.response.status === 401) {
    //         navigate('/login');
    //       } else {
    //         Swal.fire('Error', 'An error occurred while resetting visits.', 'error');
    //       }
    //       console.error(err);
    //     }
    //   } else if (result.isDenied) {
    //     Swal.fire('Cancelled', 'Changes are not saved', 'info');
    //   }
    // });
  };






  return (

    <div id='big-wrapper-admin'>
      <div className="row">
        <div className="col-md-1">
          <Sidebar
            rootStyles={{
              [`.${sidebarClasses.container}`]: {
                height: '165vh',

                backgroundColor: 'black',
                color: 'white',
                paddingTop: "12px"
              },
              [`.${sidebarClasses.menuItem}`]: {
                '&:hover': {
                  color: 'black',
                },
              },

            }}
          >
            <Menu
              menuItemStyles={{
                button: {
                  [`&.active`]: {
                    backgroundColor: '#13395e',
                    color: '#b6c8d9',
                  },
                  [`&:hover`]: {
                    color: 'black',
                  },

                },
              }}
            >
              <MenuItem style={{ fontSize: '20px' }} component={<Link to="/" />}>
                Statistics
              </MenuItem>
              <MenuItem style={{ fontSize: '20px' }} component={<Link to="/users" />}>
                Users
              </MenuItem>
              <MenuItem style={{ fontSize: '20px' }} component={<Link to="/properties" />}>
                Properties
              </MenuItem>
              <MenuItem style={{ fontSize: '20px' }} component={<Link to="/contracts" />}>
                Contracts
              </MenuItem>
              <MenuItem style={{ fontSize: '20px' }} component={<Link to="/offers" />}>
                Offers
              </MenuItem>
              <MenuItem style={{ fontSize: '20px' }} component={<Link to="/applications" />}>
                Applications
              </MenuItem>
              <MenuItem style={{ fontSize: '20px' }} component={<Link to="/agents" />}>
                Agents
              </MenuItem>

              <SubMenu title="E-commerce">{/* Add your E-commerce sub-menu items here */}</SubMenu>
            </Menu>
          </Sidebar>
        </div>
        <div className="col-md-11" id="right-side">
          <Outlet />
        </div>
      </div>
    </div>
  );
}

export default Admin