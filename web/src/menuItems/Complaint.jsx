import React, { useContext, useEffect, useState } from 'react'
import { MDBFooter, MDBContainer, MDBRow, MDBCol, MDBIcon } from 'mdb-react-ui-kit';
import '../styles/FileItem.css'
import { faFileAlt, faSpinner, faTrash, faX } from '@fortawesome/free-solid-svg-icons'
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

const Complaint = ({ complaintData }) => {

  const [value, onChange] = useState(new Date());

  const navigate = useNavigate()
  const [categoriesPost, setCategoriesPost] = useState([])
  const [posts, setPosts] = useRecoilState(studentPosts)
  const [postDetails_, setPostDetails_] = useState(PostDetails)
  const [postDeta_, setPostDeta_] = useState()

  const Swal = require('sweetalert2')
  const [isCreating, setIsCreating] = useRecoilState(isCreatingPost)
  const { currentUser } = useContext(AuthContext)
  const [currentUrl, setCurrentUrl] = useState()
  const [isHaveAccount, setIsHaveAccount] = useState(true)



  const handleLinkClick = () => {
    setIsCreating((prev) => false);
    setPostDetails_(complaintData && complaintData);

    if (currentUser) {
      setIsHaveAccount(true);
      navigate(`posts/${complaintData && btoa(complaintData.id)}`);
    } else {
      setIsHaveAccount(false);
      Swal.fire({
        position: 'center',
        icon: 'info',
        confirmButtonColor: '#00BF63',
        title: 'To access study materials, you must log in to an account.',
        showConfirmButton: false,
        timer: 1500
      });
    }
  };


  const deleteComplaint = async () => {
    Swal.fire({
      title: 'Are you sure the complaint is solved ?',
      showCancelButton: true,
      confirmButtonColor: '#00BF63',
      confirmButtonText: 'Yes',
      customClass: "Custom_btn"

    }).then(async (result) => {
      /* Read more about isConfirmed, isDenied below */
      if (result.isConfirmed) {
        Swal.fire('Done!', '', 'success')
        try {
          const res = await axios.delete(`${process.env.REACT_APP_BASE_URL}/complaints/${complaintData.id}`);
          console.log(res.data)
          // console.log(res.data[0].id);
          const updatedPosts = posts.filter(complaint => complaint.id !== complaintData.id)
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
    <div className="container" id='post'>
      <ToastContainer />
      <div className="row" id='post-up'>
        <div className="col-md-8">
          <div className="comment-image-container">

            <FontAwesomeIcon icon={faFire} style={{ fontSize: "28px" }} />

            <Link to={`students/${complaintData && btoa(complaintData.user.id)}`} id='username-link'>
              <span className="comment-author date-name-group">{complaintData && complaintData.user.name}</span>
            </Link>
            <span className="created date-name-group">{complaintData && complaintData.complainDate ? complaintData.complainDate.substring(0, 10) : null}</span>
          </div>
        </div>
        <div className="col-md-4" id='delete-lang-post'>

          <span
            id='delete-post'
            style={{ borderStyle: "solid", borderColor: "green", color: "green", cursor: "pointer", paddingLeft: "5px", paddingRight: "5px", borderRadius: "8px" }}
            onClick={() => deleteComplaint()}
          >
            Solved
          </span>



        </div>
      </div>


      <div className="post-down">
        <div onClick={handleLinkClick}>
          <Link
            // to={isHaveAccount ? `posts/${postData && btoa(postData.id)}` : ''}
            style={{ textDecoration: 'none' }}
            id='postDetails-link'
          >

            <div className="comment-text">
              {complaintData && complaintData.description ? complaintData.description.substring(0, 120) : null}
              {complaintData && complaintData.description.length > 200 ? <span id='readMore'> Read more...</span> : null}
            </div>
            <hr />
          </Link>
        </div>
      </div>
    </div >
  )
}

export default Complaint