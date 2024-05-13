import React, { useContext, useEffect, useState } from 'react'
import { MDBFooter, MDBContainer, MDBRow, MDBCol, MDBIcon } from 'mdb-react-ui-kit';
import '../styles/FileItem.css'
import { faFileAlt, faSpinner, faCalendarDays, faBuilding, faHouseCircleExclamation, faCity, faTrash, faX } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { Link, Outlet, useNavigate } from 'react-router-dom'
import '@fortawesome/fontawesome-free/css/all.min.css';
import 'bootstrap-css-only/css/bootstrap.min.css';
import 'mdbreact/dist/css/mdb.css';
import '../styles/Post.css'
import { AuthContext } from '../context/authContext';
import axios from 'axios';
import { useRecoilState } from 'recoil';
import { PostDetails, isCreatingPost, studentPosts } from '../state';
import { ToastContainer, toast } from 'react-toastify';
import profile_pic from '../assets/user-pic.png';
import DatePicker from 'react-date-picker';
import 'react-date-picker/dist/DatePicker.css';
import 'react-calendar/dist/Calendar.css';
import Swal from 'sweetalert2'

import { faFire } from '@fortawesome/free-solid-svg-icons'

// type ValuePiece = Date | null;

// type Value = ValuePiece | [ValuePiece, ValuePiece];

const Property = ({ propertyData: propertyData }) => {

  const [value, onChange] = useState(new Date());

  const navigate = useNavigate()
  const [categoriesPost, setCategoriesPost] = useState([])
  const [posts, setPosts] = useRecoilState(studentPosts)
  const [postDetails_, setPostDetails_] = useState(PostDetails)
  const [postDeta_, setPostDeta_] = useState()

  const Swal = require('sweetalert2')
  const { currentUser } = useContext(AuthContext)
  const [currentUrl, setCurrentUrl] = useState()


  const [displayCount, setDisplayCount] = useState(1);

  const showMoreImages = () => {
    setDisplayCount(displayCount + 1);
  };

  const showLessImages = () => {
    setDisplayCount(displayCount - 1);
  };




  const deleteProperty = async () => {
    Swal.fire({
      title: 'Are you sure you want to delete this post?',
      showCancelButton: true,
      confirmButtonColor: '#00BF63',
      confirmButtonText: 'Delete',
      customClass: "Custom_btn"

    }).then(async (result) => {
      /* Read more about isConfirmed, isDenied below */
      if (result.isConfirmed) {
        Swal.fire('Done!', '', 'success')
        try {
          const res = await axios.delete(`${process.env.REACT_APP_BASE_URL}/properties/${propertyData.id}`);
          console.log(res.data)
          // console.log(res.data[0].id);
          const updatedPosts = posts.filter(property => property.id !== propertyData.id)
          setPosts(updatedPosts)
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
          else if (err.response && err.response.status === 401) {
            navigate('/login');
          } else {
            console.log(err);
          }
        }
      } else if (result.isDenied) {
        Swal.fire('Changes are not saved', '', 'info')
      }
    })

  }

  const skipPost = async (postToSkip) => {
    console.log(posts);
    const updatedPosts = await posts.filter(post => post.id !== postToSkip.id);
    console.log(updatedPosts);
    setPosts(updatedPosts);
  };






  const updateDate = async (id) => {
    console.log(value);

    if (!value) {
      console.error("Date data is not available.");
      return;
    }

    try {
      const isoDateString = value.toLocaleString('en-US', { timeZone: 'UTC' });
      console.log(isoDateString);

      const res = await axios.put(`${process.env.REACT_APP_BASE_URL}/posts/${id}`, { value: isoDateString });

      // Assuming the response contains the updated post
      console.log(res.data.updatedPost);

      // Update the state with the updated post
      setPostDeta_(res.data.updatedPost);
    } catch (err) {
      if (err.message === 'Network Error' && !err.response) {
        toast.error('Network error - make sure the server is running!', {
          position: "top-center",
          autoClose: 10000,
          hideProgressBar: false,
          closeOnClick: true,
          pauseOnHover: true,
          draggable: true,
          progress: undefined,
          theme: "colored",
        });
      } else if (err.response && err.response.status === 401) {
        navigate('/login');
      } else {
        console.log(err);
      }
    }
  };


  return (
    <Link style={{textDecoration: "none", color: "black"}} to={`${propertyData && propertyData.propertyCode}`}>

      <div className="container" id='post'>
        <ToastContainer />
        <div className="row" id='post-up'>
          <div className="col-md-8">
            <FontAwesomeIcon icon={faBuilding} style={{ fontSize: "28px" }} />
            <span style={{ fontWeight: "700", fontSize: "15px" }}> {propertyData && propertyData.user.name}</span>
            <span className="created date-name-group">{propertyData && propertyData.listingDate ? propertyData.listingDate.substring(0, 10) : null} </span>
          </div>
          <div className="col-md-4" id='delete-lang-post'>

            <span id='delete-post'>
              <FontAwesomeIcon icon={faTrash}
                onClick={() => deleteProperty()} />
            </span>


          </div>
        </div>


        <div className="post-down">
          <div className="row">
            <div className="col-4" >
              <span><FontAwesomeIcon icon={faCity} /></span>
              <span style={{ fontWeight: "600" }}> City: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.location.city}</span>
            </div>
            <div className="col-4" >
              <span><FontAwesomeIcon icon={faHouseCircleExclamation} /> </span>
              <span style={{ fontWeight: "600" }}>Property type: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.propertyType}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span><FontAwesomeIcon icon={faCalendarDays} /> </span>
              <span style={{ fontWeight: "600" }}>Building date: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.builtYear.substring(0, 10)}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
          </div>          <hr style={{ marginTop: "20px" }} />

          <div className="row">
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Listing type: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.listingType}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>{propertyData && propertyData.listingType == "For rent" ? "Monthly rent: " : "Price: "} </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.price}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Property code: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.propertyCode}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
          </div>
          <hr style={{ marginTop: "20px" }} />
          <div className="row">
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Number of bedrooms: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.numberOfBedRooms}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Number of bathrooms: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.numberOfBathRooms}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Square meters area: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.squareMetersArea} m2</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
          </div>
          <hr style={{ marginTop: "20px" }} />
          <div className="row">
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Address: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.location.streetAddress}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Property view: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.view}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Parking spots: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.parkingSpots} </span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
          </div>
          <hr style={{ marginTop: "20px" }} />
          <div className="row">
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Listing By: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.listingBy}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Property status: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.propertyStatus}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Available on: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.availableOn} </span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
          </div>
          <hr style={{ marginTop: "20px" }} />
          <div className="row">
            <span style={{ fontWeight: "600" }}>Description: </span>
            <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.propertyDescription}</span>
            {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
          </div>
          <hr style={{ marginTop: "20px" }} />
          <div>

            <img
              style={{ width: '950px', marginTop: '20px' }}
              src={propertyData && propertyData.propertyFiles.length > 0 &&
                propertyData.propertyFiles[0].downloadUrls}
              alt=""
            />

          </div>
        </div>
      </div >
    </Link>
  )
}

export default Property