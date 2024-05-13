import React, { useContext, useEffect, useState } from 'react'
import Post from './Post'
import axios from 'axios'
import { AuthContext } from '../../context/authContext'
import { useNavigate, useParams } from 'react-router-dom'
import { useRecoilState } from 'recoil'
import { studentPosts } from '../../state'
import '../../styles/posts.css'
import { ToastContainer, toast } from 'react-toastify'

const Posts = () => {
  const navigate = useNavigate()
  const { currentUser } = useContext(AuthContext)
  const [posts, setPosts] = useRecoilState(studentPosts)
  const  params  = useParams();
  useEffect(() => {
    const fetchData = async () => {
      try {
        console.log(params.id);
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/users/${atob(params.id)}/posts`);
        if (res && res.data) {
          setPosts(res.data);
        } else {
          // Handle the case where the response is invalid or empty
        }
      } catch (err) {
        // Handle errors here
        if (err.message === 'Network Error' && !err.response) {
          // Handle network error
          toast.error('Network error - make sure the server is running!', {
            // ...
          });
        } else if (err.response && err.response.status === 401) {
          // Handle unauthorized error
          navigate('/login');
        } else {
          // Handle other errors
          console.log(err);
        }
      }
    };
    
    fetchData();
    
  }, [params])
  return (
    <>
    <ToastContainer />
    <div id='posts'>
    {
          posts.length !== 0 ?
          posts.map((post) => (
            <Post key={post.id} postData={post} />
          ))
          :
          <h1 className="posts-found">No Posts Found</h1>
        }


    </div>
    </>
  )
}

export default Posts