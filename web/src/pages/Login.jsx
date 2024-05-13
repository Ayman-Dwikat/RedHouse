import React, { useContext, useEffect, useState } from 'react'
import "../styles/login.css"
import logo_side_img from '../assets/logo_side.png'
import { Link, Navigate, useNavigate } from 'react-router-dom'
import axios from 'axios'
import { AuthContext } from '../context/authContext'
import Swal from 'sweetalert2'
import { ToastContainer, toast } from 'react-toastify'
import "react-toastify/dist/ReactToastify.css";

const Login = () => {
  const [values, setValues] = useState({
    email: '',
    password: ''
  })


  const [err, setError] = useState(null)
  const navigate = useNavigate();
  const [isAdmin, setIsAdmin] = useState(false)
  const { currentUser, setCurrentUser } = useContext(AuthContext) 

  const handleChange = e =>{
    setValues(prev=>({...prev, [e.target.name]: e.target.value}))
  }

  const login = async (values) => {
    try {
      const res = await axios.post(`${process.env.REACT_APP_BASE_URL}/auth/login`, values);
      Swal.fire({
        position: 'center',
        icon: 'success',
        confirmButtonColor: '#00BF63',
        title: 'Logged in successfully',
        showConfirmButton: false,
        timer: 1500
      });
      
      setCurrentUser(res.data);
    // login/admin/6
      if (res && res.data.userRole === "admin") {
        console.log("User is an admin");
        navigate(`/admins/${btoa(res.data.id)}`); // Use res.data.id directly
      } else {
        console.log("User is not an admin");
        navigate('/');
      }
    } catch (err) {
      if (err.message === 'Network Error' && !err.response)
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
      else {
        console.log(err);
        setError(err.response.data);
      }
    }
  };
  
  axios.defaults.withCredentials = true;
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await login(values);
      // console.log(isAdmin);
      // isAdmin ? navigate(`/admins/${currentUser.id}`) : navigate('/');
    } catch (err) {
      if (err.message === 'Network Error' && !err.response)
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
      else {
        console.log(err);
        setError(err.response.data);
      }
    }
  }
  
  return (
    <>
    <ToastContainer />
    <div className='wrapper' >
      
      <div className="container main">
        <div className="row login-row">
          <div className='col-md-6 left-side'>
            <div className='header-left'>tuulio</div>
          </div>
          <div className='col-md-6 right-side'>
            <div className='input-box'> 
              <header >LOGIN</header>
              <form>
                <div className='input-field'>
                  <label htmlFor='email' className='input-lable'>Email</label>
                  <input type="text" className='input' id='email' name='email' onChange={handleChange} required autoComplete='off'/>
                </div>
                <div className='input-field'>
                  <label htmlFor='password' className='input-lable'>Password</label>
                  <input type="password" className='input' name='password' onChange={handleChange} id='password' required/>
                </div>
                <div className='input-field'>
                  <button onClick={handleSubmit} id='cd'>Login</button>
                </div>
                <div className='or'> or </div>
                <div className='input-field'>
                  <button onClick={() => { navigate('../') }} id='cd-visitor'>Login as visitor</button>
                </div>
                <div className='invalid'>
                  { err && <p className='login-error-message'>{err}</p> }
                </div>
                <div className='signup'>
                  <span> <Link to='/register'>Don't have account?</Link></span> 
                  <span> <Link to='/forgot-password'>Forget password?</Link></span>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
    </>
  )
}

export default Login