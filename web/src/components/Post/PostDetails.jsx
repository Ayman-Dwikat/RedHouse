import React, { useEffect, useState } from 'react';
import { useRecoilState } from 'recoil';
import { useNavigate, useParams } from 'react-router-dom';
import axios from 'axios';
import { isCreatingPost, studentPosts, viewingPostDetails } from '../../state';
import FileItem from '../File/FileItem';
import '../../styles/PostDetails.css'
import '../../styles/FileList.css'
import UrlList from '../File/UrlItem';
import '../../styles/Post.css'
import Category from '../Category';
import { storage } from '../../firebase';
import { deleteObject, ref } from 'firebase/storage';
import { ToastContainer, toast } from 'react-toastify';
import UrlItem from '../File/UrlItem';
import Swal from 'sweetalert2';


import Backdrop from '@material-ui/core/Backdrop';
import CircularProgress from '@material-ui/core/CircularProgress';
import Button from '@material-ui/core/Button';
import { makeStyles } from '@material-ui/core/styles';
import ScrollToTop from '../ScrollToTop';

const useStyles = makeStyles((theme) => ({
  backdrop: {
    zIndex: theme.zIndex.drawer + 1,
    color: '#fff',
  },
}));

// Functional component
const PostDescription = () => {
  // Use the useStyles hook to get the styles
  const classes = useStyles();
  const [isCreating, setIsCreating] = useRecoilState(isCreatingPost);
  const [isViewingPostDetails, setIsViewingPostDetails] = useRecoilState(viewingPostDetails)
  const [posts, setPost] = useRecoilState(studentPosts);
  const [postDetail, setPostDetail] = useState(null);
  const [categoriesPost, setCategoriesPost] = useState(null);
  const [filesList, setFilesList] = useState(null);
  const navigate = useNavigate();
  const params = useParams();
  useEffect(() => {
    // Scroll to the top of the page when the component mounts
    window.scrollTo(0, 0);
  }, []);

  const deleteFile = (fileId, filename) => {
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
          const file = filesList.find(file => file.fileName === filename);
          console.log(file);
          const fileRef = ref(storage, file.fileRef);
          // Delete the file
          deleteObject(fileRef)
            .then().catch(error => {
              console.error('Error deleting file:', error.message);
            });
          try {
            const res = await axios.delete(`${process.env.REACT_APP_BASE_URL}/files/${fileId}`);
            console.log(res.data)
            // console.log(res.data[0].id);
            // Use the functional form of setState to update the fileList
            setFilesList(prevFilesList => prevFilesList.filter(file => file.fileName !== filename));
            console.log('File deleted successfully');
          } catch (err) {

            if (err.response && err.response.status == 401) {
              navigate('/login')
            }
            console.log(err)
          }
        }
        catch (err) {
          console.log(err)
        }
      } else if (result.isDenied) {
        Swal.fire('Changes are not saved', '', 'info')
      }
    })
  }

 
  

  useEffect(() => {
    //  console.log(params.id);
    // setPostDetail(posts.filter(post => post.id == params.id ))

    const fetchPostDetails = async () => {
      try {
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/posts/${atob(params.id)}`);
        //console.log(res.data);
        setPostDetail(res && res.data[0]);
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

    const fetchCategories = async () => {
      try {
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/posts/${atob(params.id)}/categories`);
        console.log(res.data)
        setCategoriesPost(res.data);
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

    const fetchFiles = async () => {
      try {
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/posts/${atob(params.id)}/files`);
        console.log(res.data);
        setFilesList(res.data);
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
      fetchPostDetails();
      fetchCategories();
      fetchFiles();


      setIsCreating((prev) => true);
    // setIsViewingPostDetails(true)
  }, [atob(params.id), setIsCreating, navigate]);


  useEffect(() => {
    setIsViewingPostDetails((prev) => true);
  
    // The return function here is the cleanup function that will be called
    // when the component is unmounted.
    return () => {
      setIsViewingPostDetails((prev) => false);
      setIsCreating((prev) => false);
    };
  }, [/* no dependencies here */]);

  return (
    <><ScrollToTop /><div className='container' id='post-details'>
      <ToastContainer />
      {(postDetail == null || categoriesPost == null || filesList == null) ? (
        <>
        <Backdrop className={classes.backdrop} open>
          <CircularProgress color="inherit" />
        </Backdrop>
        <div style={{ height: '1000px' }}></div>
      </>
      
      ) : (
        <div>
          <div className="row" id='filesList'>
            <div className="title">Title</div>
            <h2 className="post-title">{postDetail && postDetail.title}</h2>
          </div>
          <hr />
          <div className="row">
            <div className="title">Description</div>
            <div className="post-description">{postDetail && postDetail.description}</div>
          </div>
          <hr />
          <div className="row">
            <div className="title">Categories</div>
            <div className="comment-category">
              {postDetail &&
                (
                  categoriesPost.length !== 0 ? (
                    categoriesPost.map((categoryPost) => {
                      return <Category key={categoryPost.id} categoryContent={categoryPost.categoryName} />;
                    })
                  ) : (
                    <p>No categories available</p>
                  )
                )}
            </div>
          </div>
          <hr />
          <div className="row" id="files-list">
            <div>Files</div>
            {filesList && filesList.length !== 0 ? (
              <ul className='file-list'>
                {filesList.map((f) => (
                  <UrlItem className='filesPost' key={f.id} file={f} deleteFile={deleteFile} userId={postDetail.userId} />
                ))}
              </ul>
            ) : (
              <p className='filesPost'>No files available</p>
            )}

          </div>
          <hr className='file-line' />
        </div>
      )}


    </div></>
  );
};

export default PostDescription;
