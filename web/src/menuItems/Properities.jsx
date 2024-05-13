import React, { useContext, useEffect, useState } from 'react'
import people from '../assets/Group.png'
import '../styles/Home.css'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faPlay } from '@fortawesome/free-solid-svg-icons'
import { faHandshakeAngle } from '@fortawesome/free-solid-svg-icons'
// import Post from '../Post/Post.jsx'
import { Link, Outlet, useNavigate } from 'react-router-dom'
// import SearchBar from '../SearchBar/SearchBar.jsx'
// import FilterBar from '../SearchBar/FilterBar.jsx'
// import SearchResultsListPost from './SearchBar/SearchResultsListPost'
// import SearchResultsList from './SearchBar/SearchResultsList'
import axios from 'axios'
import { AuthContext } from '../context/authContext'
// import {PostList} from '../Post/PostList'
import { useRecoilState } from 'recoil'
import countapi from 'countapi-js';
import { ToastContainer, toast } from 'react-toastify'
import { isLoading, keywordQuery, searchedProperties } from '../state'
import Cookies from 'js-cookie'

import SearchBar from '../components/SearchBar/SearchBar'
import PropertiesList from './PropertiesList'
import ClipLoader from 'react-spinners/ClipLoader'

const Properties = () => {

  const { isLoaded } = useState(true)

  const center = (() => ({ lat: 18.52043, lng: 73.856743 }), []);

  const [page, setPage] = useState(1); // Start page from 1
  const [limit, setLimit] = useState(5);
  const [pages, setPages] = useState(0);
  const [rows, setRows] = useState(0);
  const [keyword, setKeyword] = useRecoilState(keywordQuery);

  const [loading, setLoading] = useState(false);


  const [count, setCount] = useState(0);
  const navigate = useNavigate()
  const [properties, setProperties] = useRecoilState(searchedProperties);
  const { currentUser, logout } = useContext(AuthContext)
  const [isLoadingHome, setIsLoadingHome] = useRecoilState(isLoading);
  const getCookie = (cookieName) => {
    const cookieValue = Cookies.get(cookieName);
    return cookieValue;
  }

  
  // useEffect(() => {
  //   const fetchData = async () => {
  //     try {
  //       // Get the access token from a cookie named "access_token_tuulio"
  //       const currentCookie = getCookie("access_token_tuulio");

  //       // Check if the access token is available
  //       if (!currentCookie && !currentUser) {
  //         // Handle the case where the access token is missing or undefined
  //         console.log("Access token is missing.");
  //         return;
  //       }

  //       // Make an authenticated request using the access token
  //       const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/verifyUser/${currentCookie}`);

  //       // Process the response data if needed

  //       // Example: Log the response data
  //       console.log("Response data:", res.data);
  //     } catch (err) {
  //       if (err.message === 'Network Error' && !err.response) {
  //         // Handle network error
  //         toast.error('Network error - make sure the server is running!', {
  //           position: "top-center",
  //           autoClose: 10000,
  //           hideProgressBar: false,
  //           closeOnClick: true,
  //           pauseOnHover: true,
  //           draggable: true,
  //           progress: undefined,
  //           theme: "dark",
  //         });
  //       } else if (err.response && err.response.status === 401) {
  //         // Handle unauthorized access (status code 401)
  //         if (currentUser) {
  //           console.log("Unauthorized access - redirecting to login.");
  //           logout(true)
  //           navigate('/login');
  //         }
  //       } else {
  //         // Handle other errors
  //         console.error("An error occurred:", err);
  //       }
  //     }
  //   };

  //   const incrementVisits = async () => {
  //     try {
  //       const res = await axios.post(`${process.env.REACT_APP_BASE_URL}/auth/visits`);
  //       console.log("authentication procces")
  //     } catch (err) {
  //       if (err.message == 'Network Error' && !err.response)
  //         toast.error('Network error - make sure server is running!', {
  //           position: "top-center",
  //           autoClose: 10000,
  //           hideProgressBar: false,
  //           closeOnClick: true,
  //           pauseOnHover: true,
  //           draggable: true,
  //           progress: undefined,
  //           theme: "colored",
  //         });
  //       if (err.response && err.response.status == 401) {
  //         navigate('/login')
  //       }
  //       else {
  //         console.log(err);
  //       }
  //     }
  //   }
  //   // fetchData()
  //   setIsLoadingHome(true)
  //   incrementVisits()
  // }, []);



  return (
    <>
      <section className="hero">

        <hr></hr>

      </section>

      <section className="setup" id='start'>
        <div className="container" id='left-right-setup'>
          <div className="row">

            <div className="col-12">

              



              <div className="col-12">
                {loading ? ( // Display the spinner conditionally based on the loading state
                  <div style={{ marginBottom: '400px', marginTop: '380px', display: 'flex', justifyContent: 'center' }}>
                    <ClipLoader
                      color={"#00BF63"}
                      loading={true}
                      size={40}
                      aria-label="Loading Spinner"
                      data-testid="loader"
                    />
                  </div>


                ) :
                  <Outlet />
                }
              </div>

            </div>
            <div className="row" id='left-setup'>
              {/* <PostList /> */}
            </div>

          </div>

        </div>

      </section>
    </>

  )
}

export default (Properties)

