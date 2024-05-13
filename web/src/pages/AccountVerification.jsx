import React, { useEffect, useState } from 'react'
import '../styles/AccountVerification.css'
import axios from 'axios'
import { useNavigate, useParams } from 'react-router-dom'
import { ToastContainer, toast } from 'react-toastify'
import Swal from 'sweetalert2'

const AccountVerification = () => {

  const [password, setPassword] = useState()
  const [confirmPassword, setConfirmPassword] = useState()
  const [err, setError] = useState()
  const navigate = useNavigate()
  const {id, token} = useParams()

    useEffect(() => {
        const verify = async () => {
            try{
                const res = await axios.post(`${process.env.REACT_APP_BASE_URL}/auth/account-verification/${id}/${token}`)
                Swal.fire({
                  position: 'center',
                  icon: 'success',
                  confirmButtonColor: '#00BF63',
                  title: 'Your account verified',
                  showConfirmButton: false,
                  timer: 1500
                });
                navigate("/login")
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
        <div className="d-flex justify-content-center align-items-center vh-100">
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

export default AccountVerification