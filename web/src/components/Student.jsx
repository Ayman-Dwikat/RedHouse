import React, { useContext, useEffect, useState } from 'react'
import Post from './Post/Post'
import '../styles/Student.css'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faPlay } from '@fortawesome/free-solid-svg-icons'
import { Link, Outlet, useNavigate, useParams } from 'react-router-dom'
import { useRecoilState } from 'recoil'
import { isCreatingPost, viewingPostDetails } from '../state'
import axios from 'axios'
import { AuthContext } from '../context/authContext'
import { ToastContainer, toast } from 'react-toastify'
import Cookie from 'js-cookie'
const Student = () => {
  const { currentUser, logout } = useContext(AuthContext)
  const [isCreating, setIsCreating] = useRecoilState(isCreatingPost)
  const [isCreatingLocal, setIsCreatingLocal] = useState(false);

  const [isViewingPostDetails, setIsViewingPostDetails] = useRecoilState(viewingPostDetails)
  const [isViewingPostDetailsLocal, setIsViewingPostDetailsLocal] = useState(false)
  const [isMounted, setIsMounted] = useState(true);
  const [studentData, setStudentData] = useState({})
  const navigate = useNavigate()
  const params = useParams();


  const getCookie = (cookieName) => {
    const cookieValue = Cookie.get(cookieName);
    return cookieValue;
  }

  // useEffect(() => {
  //   // Scroll to the top of the page when the component mounts

  //   setTimeout(function () {
  //     window.scrollTo(0, 0);
  // },2);
  // }, []);

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


    const fetchStudent = async () => {
      try {
        console.log(atob(params.id));
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/users/${atob(params.id)}`);
        setStudentData(res.data)
        console.log(studentData);
        return
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
            theme: "dark",
          });
        else if (err.response && err.response.status === 401) {
          if (currentUser) {
            console.log(err + '---------------------------------------------------------------');
            navigate('/login');
          }

        }
        console.log(err);
      }
    };

    fetchData();
    fetchStudent()
    setIsCreatingLocal(false)
    setIsViewingPostDetailsLocal(false)
  }, [params]);


  useEffect(() =>{
    setIsViewingPostDetails(isViewingPostDetailsLocal)
  }, [isViewingPostDetailsLocal])

  useEffect(() =>{
    setIsCreating(isCreatingLocal)
  }, [isCreatingLocal])

  return (
    <div className='container' id='student-container'>
      <ToastContainer />
      <div className='row' id={isViewingPostDetails ? 'disableRow' : 'profile-info'}>
        <div className='col-md-3' id='left-profile'>
          <div className='pic'>
            {<img src={studentData && studentData.imagePath !== "" ? studentData && studentData.imagePath : require('../assets/user-pic.png')} alt="" id="profile-pic" />}

            <Link to="./"
              onClick={() => {
                console.log(isCreating)
                setIsCreatingLocal(false);
              }} id='username-link'>
              <h5 className="user-name" id='user-name'>
                {studentData && studentData.name}
              </h5>
            </Link>
            {currentUser && currentUser.userRole == 'volunteer' && studentData.id == currentUser.id && !isCreating && <div className="create-post">
              <Link to="create-post" onClick={() => {
                setIsCreatingLocal(true);
                setIsViewingPostDetailsLocal(true)
              }} className="btn-started">
                <FontAwesomeIcon icon={faPlay} className='play' />
                Create Post
              </Link>
            </div>}
          </div>
        </div>

        {/* <div className="col-md-1 zero-width vertical-line"></div> */}

        <div className='col-md-8' id='right-profile'>
          <div className="language">
            <span className='for-font'>Native Language: </span>{studentData && studentData.nativeLanguage}
          </div>


          <div className="status">
            <span className='for-font'>Volunteer Status: </span>{studentData && studentData.isPass == 1 ? 'Pass' : 'InProgress'}
          </div>
        </div>
        <hr className='student-line'></hr>
      </div>

      <div className="row" id='student-posts'>
        <Outlet />
      </div>
      <hr className='student-bar' />
    </div>


  )
}

export default Student