import React, { useEffect, useState } from 'react'
import '../styles/AccountVerification.css'
import { useRecoilState } from 'recoil'
import { Email } from '../state'
import axios from 'axios'
import { ToastContainer, toast } from 'react-toastify'
import { useNavigate, useParams } from 'react-router-dom'
const AccountConfirmation = () => {
    const [verifiedEmail, setVerifiedEmail] = useRecoilState(Email)
    const [err, setError] = useState()

    useEffect(() => {
        const verify = async () => {
          console.log(verifiedEmail);
          const email = verifiedEmail
            try{
                const res = await axios.post(`${process.env.REACT_APP_BASE_URL}/auth/account-confirmation`, {email})
                console.log(res);
              }catch(err){
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
        verify()
    }, [])
    return (
        
        <div id='box-conf' className="d-flex justify-content-center align-items-center vh-100">
        <div className='invalid'>
        { err && <p className='login-error-message'>{err}</p> }
        </div>
          <div id='cont-account' >
          <div class="container mt-5">
        <div class="row">
            <div class="col-lg-6 offset-lg-3">
                <div class="text-center">
                    <h1>Account Confirmation</h1>
                </div>
                <div id='alert'>
                    <p>An email with your account confirmation link has been sent to your email.</p>
                </div>
            </div>
        </div>
    </div>
          </div>
        </div>
  )
}

export default AccountConfirmation