import React, { useContext, useEffect, useState } from 'react'
import { MDBFooter, MDBContainer, MDBRow, MDBCol, MDBIcon } from 'mdb-react-ui-kit';
import '../../styles/FileItem.css'
import { faFileAlt, faSpinner, faTrash, faX } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { Link, Outlet, useNavigate } from 'react-router-dom'
import '@fortawesome/fontawesome-free/css/all.min.css';
import 'bootstrap-css-only/css/bootstrap.min.css';
import 'mdbreact/dist/css/mdb.css';
import '../../styles/Post.css'
import { AuthContext } from '../../context/authContext';
import Category from '../Category';
import axios from 'axios';
import { useRecoilState } from 'recoil';
import { PostDetails, isCreatingPost, studentPosts } from '../../state';
import { ToastContainer, toast } from 'react-toastify';
import profile_pic from '../../assets/user-pic.png';
import DatePicker from 'react-date-picker';
import 'react-date-picker/dist/DatePicker.css';
import 'react-calendar/dist/Calendar.css';
import Swal from 'sweetalert2'

// type ValuePiece = Date | null;

// type Value = ValuePiece | [ValuePiece, ValuePiece];

const Post = ({ postData }) => {
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
    setPostDetails_(postData && postData);

    if (currentUser) {
      setIsHaveAccount(true);
      navigate(`posts/${postData && btoa(postData.id)}`);
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


  const deletePost = async () => {
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
          const res = await axios.delete(`${process.env.REACT_APP_BASE_URL}/posts/${postDeta_.id}`);
          console.log(res.data)
          // console.log(res.data[0].id);
          const updatedPosts = posts.filter(post => post.id !== postDeta_.id)
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

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/posts/${postData.id}/categories`);
        setCategoriesPost(res.data);
        console.log(res.data)
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
    };

    setPostDeta_(postData);
    console.log(postData)
    fetchData();
  }, []);


  return (
    <div className="container" id='post'>
      <ToastContainer />
      <div className="row" id='post-up'>
        <div className="col-md-8">
          <div className="comment-image-container">
            {<img
              src={postData && postData.imagePath !== "" ? postData.imagePath : profile_pic}
              alt=""
              className="profile-pic"
            ></img>}
            <Link to={`students/${postData && btoa(postData.userId)}`} id='username-link'>
              <span className="comment-author date-name-group">{postData && postData.name}</span>
            </Link>
            <span className="created date-name-group">{postDeta_ && postDeta_.date ? postDeta_.date.substring(0, 10) : null}</span>
          </div>
        </div>
        <div className="col-md-4" id='delete-lang-post'>
          <span id='lang-post'>
            <i class="fa fa-language" aria-hidden="true"> {postData && postData.userLanguage} </i>
          </span>
          {
            currentUser && currentUser.userRole == 'volunteer' && postData.userId == currentUser.id ?
              <span id='delete-post'>
                <FontAwesomeIcon icon={faTrash}
                  onClick={() => deletePost()} />
              </span>
              :
              <span id='delete-post'>
                <FontAwesomeIcon icon={faX}
                  onClick={() => skipPost(postData)} />
              </span>
          }
        </div>
      </div>


      <div className="post-down">
        <div onClick={handleLinkClick}>
          <Link
            // to={isHaveAccount ? `posts/${postData && btoa(postData.id)}` : ''}
            style={{ textDecoration: 'none' }}
            id='postDetails-link'
          >
            <div className="comment-title">
              {postData && postData.title}
            </div>
            <div className="comment-text">
              {postData && postData.description ? postData.description.substring(0, 120) : null}
              {postData && postData.description.length > 200 ? <span id='readMore'> Read more...</span> : null}
            </div>
            <hr />
          </Link>
        </div>
        <div className="comment-category">
          {postData &&
            categoriesPost.map((categoryPost) => {
              return <Category key={categoryPost.id} categoryContent={categoryPost.categoryName} />
            })
          }
        </div>
        {currentUser && (currentUser.userRole === 'admin') &&
          <div className="change-date">
            <span><DatePicker onChange={onChange} value={value} /></span>
            <span><button id='update-btn' onClick={() => updateDate(postData.id)}>Update</button></span>
          </div>
        }
      </div>
    </div >
  )
}

export default Post