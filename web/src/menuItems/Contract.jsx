import React, { useContext, useEffect, useState } from 'react'
import { MDBFooter, MDBContainer, MDBRow, MDBCol, MDBIcon } from 'mdb-react-ui-kit';
import '../styles/FileItem.css'
import { faFileAlt, faSpinner, faCalendarDays, faBuilding, faHandshake, faCity, faTrash, faX } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { Link, Outlet, useNavigate } from 'react-router-dom'
import '@fortawesome/fontawesome-free/css/all.min.css';
import 'bootstrap-css-only/css/bootstrap.min.css';
import 'mdbreact/dist/css/mdb.css';
import '../styles/Post.css'
import { AuthContext } from '../context/authContext';
import axios from 'axios';
import { useRecoilState } from 'recoil';
import { PostDetails, contractDetails, isCreatingPost, studentPosts } from '../state';
import { ToastContainer, toast } from 'react-toastify';
import profile_pic from '../assets/user-pic.png';
import DatePicker from 'react-date-picker';
import 'react-date-picker/dist/DatePicker.css';
import 'react-calendar/dist/Calendar.css';
import Swal from 'sweetalert2'

import { faFire } from '@fortawesome/free-solid-svg-icons'

// type ValuePiece = Date | null;

// type Value = ValuePiece | [ValuePiece, ValuePiece];

const Contract = ({ contractData: contractData }) => {

  const [value, onChange] = useState(new Date());

  const navigate = useNavigate()
  const [categoriesPost, setCategoriesPost] = useState([])
  const [posts, setPosts] = useRecoilState(studentPosts)
  const [_contractDetails, setContractDetails] = useRecoilState(contractDetails)

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

  useEffect(() => {
    setContractDetails(contractData)
  }, [])




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
          const res = await axios.delete(`${process.env.REACT_APP_BASE_URL}/properties/${contractData.id}`);
          console.log(res.data)
          // console.log(res.data[0].id);
          const updatedPosts = posts.filter(property => property.id !== contractData.id)
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
  const dataToPass = { name: 'John Doe', age: 25 };

  return (
    <div className="container" id='post'>
      <Link to={`${contractData.id}`} style={{ textDecoration: "none", color: "black" }}>

        <ToastContainer />
        <div className="row" id='post-up'>
          <div className="col-md-8" style={{ justifyItems: "baseline" }}>
            <FontAwesomeIcon icon={faHandshake}
              style={{ fontSize: "28px", marginRight: "5px" }} />
            <span style={{ fontWeight: "700", fontSize: "15px" }}>  {contractData && contractData.offer.landlord.name} -  {contractData && contractData.offer.customer.name}</span>
            <span className="created date-name-group">{contractData && contractData.offer.offerDate ? contractData.offer.offerDate.substring(0, 10) : null} </span>
          </div>
          <div className="col-md-4" id='delete-lang-post'>

            <span id='delete-post'>
              <FontAwesomeIcon icon={faTrash}
                onClick={() => deleteProperty()} />
            </span>


          </div>
        </div>


        <div className="post-down">
          <div>
            <div className="row">
              {/* <span style={{ fontWeight: "600" }}>Description: </span> */}
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{contractData && contractData.offer.description}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <hr style={{ marginTop: "20px" }} />
            <div style={{ display: "flex", justifyContent: "space-between" }} className="row">
              <div className="col-2">
                <span style={{ fontWeight: "600" }}>Status: </span>
                <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{contractData && contractData.contractStatus}</span>
              </div>
              <div className="col-2">
                <span style={{ fontWeight: "600" }}>Price: </span>
                <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{contractData && contractData.offer.price}</span>
              </div>
            </div>

          </div>
        </div>
      </Link>
    </div>
  )
}

export default Contract