import React, { useContext, useEffect, useState } from 'react'
import '../styles/Student.css'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faPlay } from '@fortawesome/free-solid-svg-icons'
import { Link, Outlet, useNavigate, useParams } from 'react-router-dom'
import { useRecoilState } from 'recoil'
import { isCreatingPost, selectedUser, usersRows, viewingPostDetails } from '../state'
import axios from 'axios'
import { AuthContext } from '../context/authContext'
import { ToastContainer, toast } from 'react-toastify'
import Cookie from 'js-cookie'

import Popup from 'reactjs-popup';
import 'reactjs-popup/dist/index.css';

import "bootstrap/dist/css/bootstrap.min.css";
// Bootstrap Bundle JS
import "bootstrap/dist/js/bootstrap.bundle.min";

const User = () => {
  const { currentUser, logout } = useContext(AuthContext)
  const [isCreating, setIsCreating] = useRecoilState(isCreatingPost)
  const [isCreatingLocal, setIsCreatingLocal] = useState(false);

  const [isViewingPostDetails, setIsViewingPostDetails] = useRecoilState(viewingPostDetails)
  const [isViewingPostDetailsLocal, setIsViewingPostDetailsLocal] = useState(false)
  const [isMounted, setIsMounted] = useState(true);
  const navigate = useNavigate()
  const params = useParams();
  const [users, setUsers] = useRecoilState(usersRows);
  const [userData, setUserData] = useRecoilState(selectedUser)
  const [updatedUserData, setupdatedUserData] = useRecoilState(selectedUser);
  const [userId, setUserId] = useState({});



  const getCookie = (cookieName) => {
    const cookieValue = Cookie.get(cookieName);
    return cookieValue;
  }

  useEffect(() => {
    // Scroll to the top of the page when the component mounts

    console.log(userData)
  }, []);

  // useEffect(() => {
  //   console.log(users);
  //   console.log(params.id);
  //   setUserId(atob(params.id))
  //   setUserData(prevContractData => {
  //     const selectedUser = users.find(user => user.id == atob(params.id));
  //     console.log(selectedUser);
  //     return selectedUser;
  //   });
  // }, [params]);
  useEffect(() => {

    const fetchUserData = async () => {
      try {
        console.log(atob(params.id));
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/users/${atob(params.id)}`);
        setUserData(res.data.dto)
        console.log(userData);
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

    fetchUserData();
  }, [params]);




  const updateUser = async () => {
    try {
      console.log(atob(params.id));
      const res = await axios.put(`${process.env.REACT_APP_BASE_URL}/users/${atob(params.id)}`, updatedUserData);
      setUserData(updatedUserData)
      console.log(userData);
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

  const handleChange = (e, field) => {
    // Update the corresponding field in the state
    setupdatedUserData({
      ...updatedUserData,
      [field]: e.target.value,
    });
  };


  return (
    <>
      <div style={{
        display: "flex",
        justifyContent: "center"
      }}>
        <div style={{ borderRadius: "60px", padding: "20px", margin: "80px", width: "40%", boxShadow: "0.2px 0.5px 20px 0.1px", justifyContent: "center", justifyItems: "center" }}>
          <ToastContainer />
          <div className='row' >
            <div className='pic'>
              {<img src={require('../assets/user-pic.png')} alt="" id="profile-pic" />}

              <Link to="./"
                onClick={() => {
                  console.log(isCreating)
                  setIsCreatingLocal(false);
                }} id='username-link'>
                <h5 className="user-name" id='user-name'>
                  {userData && userData.name}
                </h5>
              </Link>
            </div>

            {/* <div className="col-md-1 zero-width vertical-line"></div> */}


          </div>
          <div className='row' style={{ textAlign: "center", marginTop: "10px" }}>
            <div className="language" style={{ marginBottom: "10px" }}>
              <span style={{ fontSize: "20px", fontWeight: "700" }}>User Role (level): </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "20px" }}>{userData && userData.userRole}</span>
            </div>

            <div className="language" style={{ marginBottom: "10px" }}>
              <span style={{ fontSize: "20px", fontWeight: "700" }}>Customer Score : </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "20px" }}>{userData && userData.customerScore}</span>
            </div>

            <div className="language" style={{ marginBottom: "10px" }}>
              <span style={{ fontSize: "20px", fontWeight: "700" }}>Landlord Score : </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "20px" }}>{userData && userData.customerScore}</span>
            </div>

            <div className="language" style={{ marginBottom: "10px" }}>
              <span style={{ fontSize: "20px", fontWeight: "700" }}>Email: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "20px" }}>{userData && userData.email}</span>
            </div>

            <div className="language" style={{ marginBottom: "10px" }}>
              <span style={{ fontSize: "20px", fontWeight: "700" }}>Phone Number: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "20px" }}>{userData && userData.phoneNumber}</span>
            </div>


            <div className="language" style={{ marginBottom: "10px" }}>
              <span style={{ fontSize: "20px", fontWeight: "700" }}>IsVerifed: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "20px" }}>{userData && userData.isVerified ? "Yes" : "No"}</span>
            </div>

            <div className="language" style={{ marginBottom: "10px" }}>
              <span style={{ fontSize: "20px", fontWeight: "700" }}>Created Date: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "20px" }}>{userData && userData.created}</span>
            </div>

            <div className="language" style={{ marginBottom: "10px" }}>
              <span style={{ fontSize: "20px", fontWeight: "700" }}>User Location (Postal Code): </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "20px" }}>{userData.location && userData.location.postalCode}</span>
            </div>
          </div>

          <div style={{ display: "flex", justifyContent: "center", justifyItems: "center", marginTop: "40px" }}>


            <Popup trigger={<span
              id='delete-post'
              style={{ borderStyle: "solid", backgroundColor: "black", borderColor: "black", color: "white", cursor: "pointer", width: "160px", textAlign: "center", fontWeight: "700", borderRadius: "20px" }}
            >Update
            </span>} modal contentStyle={{ display: "flex", justifyContent: "center", borderRadius: "20px", width: "30%" }} position="top center">
              <form style={{ width: "90%", margin: "25px" }} onSubmit={updateUser}>
                <div className="form-group">
                  <label htmlFor="exampleInputEmail1">Name</label>
                  <input
                    type="text"
                    className="form-control"
                    id="exampleInputEmail1"
                    value={updatedUserData && updatedUserData.name}
                    onChange={(e) => handleChange(e, 'name')}
                    aria-describedby="emailHelp"
                  />
                </div>
                <div className="form-group">
                  <label htmlFor="exampleInputEmail2">Email</label>
                  <input
                    type="email"
                    className="form-control"
                    id="exampleInputEmail2"
                    value={updatedUserData && updatedUserData.email}
                    onChange={(e) => handleChange(e, 'email')}

                  />
                </div>
                <div className="form-group">
                  <label htmlFor="exampleInputEmail3">User Role (level)</label>
                  <input
                    type="text"
                    className="form-control"
                    id="exampleInputEmail3"
                    onChange={(e) => handleChange(e, 'userRole')}

                    value={updatedUserData.userRole}
                  />
                </div>
                <div className="form-group">
                  <label htmlFor="exampleInputEmail4">Customer Score</label>
                  <input
                    type="number"
                    className="form-control"
                    id="exampleInputEmail4"
                    onChange={(e) => handleChange(e, 'customerScore')}

                    value={updatedUserData && updatedUserData.customerScore}
                  />
                </div>
                <div className="form-group">
                  <label htmlFor="exampleInputEmail5">Landlord Score</label>
                  <input
                    type="number"
                    className="form-control"
                    id="exampleInputEmail5"
                    onChange={(e) => handleChange(e, 'landlordScore')}

                    value={updatedUserData && updatedUserData.landlordScore}
                  />
                </div>
                <div className="form-group">
                  <label htmlFor="exampleInputEmail6">Phone Number</label>
                  <input
                    type="tel"
                    className="form-control"
                    id="exampleInputEmail6"
                    onChange={(e) => handleChange(e, 'phoneNumber')}

                    value={updatedUserData && updatedUserData.phoneNumber}
                  />
                </div>
                <div className="form-group">
                  <label htmlFor="exampleInputEmail7">IsVerified</label>
                  <input
                    type="text"
                    className="form-control"
                    id="exampleInputEmail7"
                    onChange={(e) => handleChange(e, 'isVerified')}

                    value={updatedUserData && updatedUserData.isVerified ? "Yes" : "No"}
                  />
                </div>
                <div className="form-group">
                  <label htmlFor="exampleInputEmail8">User Location (Postal Code)</label>
                  <input
                    type="text"
                    className="form-control"
                    id="exampleInputEmail8"
                    onChange={(e) => handleChange(e, 'postalCode')}

                    value={updatedUserData && updatedUserData.location && updatedUserData.location.postalCode}
                  />
                </div>

                <div style={{ display: "flex", justifyContent: "center", marginTop: "20px" }}>
                  <button
                    type="submit"
                    className="btn"
                    style={{ backgroundColor: "black", color: "white", width: "160px", textAlign: "center", fontWeight: "700", borderRadius: "20px" }}
                  >
                    Save
                  </button>
                </div>
              </form>;

            </Popup>


            <Popup trigger={<span
              id='delete-post'
              style={{ borderStyle: "solid", backgroundColor: "white", borderColor: "black", color: "black", height: "35px", cursor: "pointer", width: "160px", textAlign: "center", fontWeight: "700", borderRadius: "20px" }}
            >Delete
            </span>} position="top center">
              <div>Popup content here !!</div>
            </Popup>

          </div>


        </div>
      </div>
    </>



  )
}

export default User