import React from 'react'
import { useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import axios from 'axios'
import '../../styles/ForgetPassword.css'
import { ToastContainer, toast } from 'react-toastify'
import Swal from 'sweetalert2';


function ResetPassword() {
    const [password, setPassword] = useState()
    const [confirmPassword, setConfirmPassword] = useState()
    const [err, setError] = useState()
    const navigate = useNavigate()
    const {id, token} = useParams()

    axios.defaults.withCredentials = true;
    const handleSubmit = (e) => {
        e.preventDefault()
          if(confirmPassword !== password)
        {
          setError('password and confirme password fields do not match')
          return
        }
        axios.post(`${process.env.REACT_APP_BASE_URL}/auth/reset-password/${id}/${token}`, {password})
        .then(res => {
          Swal.fire({
            position: 'center',
            icon: 'success',
            confirmButtonColor: '#00BF63',
            title: 'Password changed successfully',
            showConfirmButton: false,
            timer: 1500
          });
          navigate('/login')
            
        }).catch(err =>
          { 
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
       })
    }

    return(
          <div className="d-flex justify-content-center align-items-center bg-secondary vh-100">
            <div className="bg-white p-3 rounded w-50 w-md-50 w-lg-25">
              <h4>Reset Password</h4>
              <form onSubmit={handleSubmit}>
                <div className="mb-3">
                  <label htmlFor="password">
                    <strong>New Password</strong>
                  </label>
                  <input
                    type="password"
                    placeholder="Enter Password"
                    autoComplete="off"
                    name="password"
                    className="form-control rounded-0"
                    onChange={(e) => setPassword(e.target.value)}
                  />
                </div>
                <div className="mb-3">
                  <label htmlFor="confirmPassword">
                    <strong>Confirm Password</strong>
                  </label>
                  <input
                    type="password"
                    placeholder="Confirm Password"
                    autoComplete="off"
                    name="confirmPassword"
                    className="form-control rounded-0"
                    onChange={(e) => setConfirmPassword(e.target.value)}
                  />
                </div>
                <div className='invalid'>
                  { err && <p className='login-error-message'>{err}</p> }
                </div>
                <button type="submit" id='email-btn'>
                  Update
                </button>
              </form>
            </div>
          </div>

    )
}

export default ResetPassword;




// import React, { useContext, useEffect, useState } from 'react'
// import "../styles/login.css"
// import logo_side_img from '../assets/logo_side.png'
// import { Link, Navigate, useNavigate } from 'react-router-dom'
// import axios from 'axios'
// import { AuthContext } from '../../context/authContext'
// import Swal from 'sweetalert2'
// import { ToastContainer, toast } from 'react-toastify'
// import "react-toastify/dist/ReactToastify.css";

// const ResetPassword = () => {
//   const [confirmePassword, setConfirmePassword] = useState('')
//   const [values, setValues] = useState({
//     email: '',
//     password: ''
//   })

//   const [err, setError] = useState(null)
//   const navigate = useNavigate();

//   const {login, currentUser} = useContext(AuthContext) 

//   const handleChange = e =>{
//     setValues(prev=>({...prev, [e.target.name]: e.target.value}))
//   }

//   axios.defaults.withCredentials = true;
//   const handleSubmit = async (e) => {
//     e.preventDefault();
//     if(confirmePassword !== values.password)
//     {
//       setError('password and confirme password fields do not match')
//       return
//     }
//     try{
//       await login(values)
//       console.log(currentUser);
//       navigate('/login')
//     } catch(err){
      
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
//           });
//       else{
//       console.log(err)
//       setError(err.response.data)
//       }
//     }

//   }
//   return (
//     <>
//     <ToastContainer />
//     <div className='wrapper' >
      
//       <div className="container main">
//         <div className="row login-row">
//           <div className='col-md-6 left-side'>
//             <div className='header-left'>tuulio</div>
//           </div>
//           <div className='col-md-6 right-side'>
//             <div className='input-box'> 
//               <h1 >Reset Password</h1>
//               <form>
//                 <div className='input-field'>
//                   <label htmlFor='email' className='input-lable'>New Paaword</label>
//                   <input type="text" className='input' id='email' name='email' onChange={handleChange} required autoComplete='off'/>
//                 </div>
//                 <div className='input-field'>
//                   <label htmlFor='password' className='input-lable'>Confirm password</label>
//                   <input type="password" className='input' name='password' onChange={handleChange} id='password' required/>
//                 </div>
//                 <div className='input-field'>
//                   <button onClick={handleSubmit} id='cd'>Done</button>
//                 </div>
//                 <div className='invalid'>
//                   { err && <p className='login-error-message'>{err}</p> }
//                 </div>
//               </form>
//             </div>
//           </div>
//         </div>
//       </div>
//     </div>
//     </>
//   )
// }

// export default ResetPassword