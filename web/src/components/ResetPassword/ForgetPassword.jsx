import React from 'react'
import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import axios from 'axios'
import '../../styles/ForgetPassword.css'
import { ToastContainer, toast } from 'react-toastify'

function ForgotPassword() {
    const [email, setEmail] = useState()
    const [sended, setSended] = useState(false)
    const [err, setError] = useState(null)
    const navigate = useNavigate();
    axios.defaults.withCredentials = true;
    const handleSubmit = (e) => {
        e.preventDefault()
        axios.post(`${process.env.REACT_APP_BASE_URL}/auth/forget-password`, {email})
        .then(res => {
          toast.success('Check your email', {
            position: "top-center",
            autoClose: 10000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "colored",
          });
          setSended(true)
        }).catch(err => {
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
        <ToastContainer />
        <div className="bg-white p-3 rounded w-50 w-md-50 w-lg-25">
          <h4>Forgot Password</h4>
          <form onSubmit={handleSubmit}>
            <div className="mb-3">
              <label htmlFor="email">
                <strong>Email</strong>
              </label>
              <input
                type="email"
                placeholder="Enter Email"
                autoComplete="off"
                name="email"
                className="form-control rounded-0"
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
            <div className='invalid'>
              { err && <p className='login-error-message'>{err}</p> }
            </div>
            {
              !sended ?
              <button type="submit" id="email-btn">
                Send
              </button>
              :
              null
            }
          </form>
        </div>
      </div>

    )
}

export default ForgotPassword;