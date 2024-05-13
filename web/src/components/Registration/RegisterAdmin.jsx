import React, { useEffect, useState } from 'react'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faFileArrowUp } from '@fortawesome/free-solid-svg-icons'
import '../../styles/register.css'
import { Link, useNavigate } from 'react-router-dom'
import axios from 'axios'
import {
  ref,
  uploadBytes,
  getDownloadURL,
  listAll,
  list,
} from "firebase/storage";
import { storage } from "../../firebase";
import { v4 } from "uuid";
import { ToastContainer, toast } from 'react-toastify'
import { useRecoilState } from 'recoil'
import { Email } from '../../state'

const RegisterAdmin = () => {
  // const [imageUpload, setImageUpload] = useState(null);
  const [verifiedEmail, setVerifiedEmail] = useRecoilState(Email)
  const [confirmePassword, setConfirmePassword] = useState('')
  // const [password, setPassword] = useState('')
  const [input, setInputs] = useState({
    firstName: "",
    lastName:"",
    email: "",
    nativeLanguage: "",
    imagePath: "",
    password: "",
    userRole: "admin"
  })
  const [err, setError] = useState(null)
  const navigate = useNavigate();

  const handleChange = e =>{
    setInputs(prev=>({...prev, [e.target.name]: e.target.value}))
  }

  const uploadFile = (imageUpload) => {
    if (imageUpload == null) return;
    const preImagePath = ref(storage, imageUpload.name + v4());
    uploadBytes(preImagePath, imageUpload).then((snapshot) => {
      getDownloadURL(snapshot.ref).then((url) => {
        setInputs(prevInputs => ({
          ...prevInputs,
          imagePath: url // Update the imagePath property
        }));
        console.log(input);
      });
    });


  };

  const handleSubmit = async (e) =>{
    setVerifiedEmail(input.email)
    e.preventDefault();
    uploadFile()
    if(confirmePassword !== input.password)
    {
      setError('password and confirme password fields do not match')
      return
    }
    e.preventDefault();
    try{
      const res = await axios.post(`${process.env.REACT_APP_BASE_URL}/auth/register`, input)
      setVerifiedEmail(input.email)
      navigate("/account-confirmation")
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
  console.log(input)
  return (
    <div className='wrapper' >
      <div className="container main">
        <div className="row login-row" id='row-signup'>
          <div className='col-md-6 left-side'>
            <div className='header-left'>tuulio</div>
          </div>
          <div className='col-md-6 right-side'>
            <div className='input-box-signup'> 
              <header >Sign Up</header>
              <form>
                <div className='input-field-name'>
                    <div className='input-field'>
                      <label htmlFor='email' className='input-lable'>First name</label>
                      <input type="text" className='input-name' name='firstName' id='email' onChange={handleChange} required autoComplete='off'/>
                    </div>
                    <div className='input-field'>
                      <label htmlFor='email' className='input-lable'>Last name</label>
                      <input type="text" className='input-name' name='lastName' onChange={handleChange} required autoComplete='off'/>
                    </div>
                </div>
                <div className='input-field'>
                  <label htmlFor='email' className='input-lable'>Email</label>
                  <input type="text" className='input' name='email' id='email' onChange={handleChange} required autoComplete='off'/>
                </div>

                
                <div className='input-field'>
                  <label htmlFor='password' className='input-lable'>Password</label>
                  <input type="password" className='input' name='password' onChange={handleChange} id='password' required/>
                </div>
                <div className='input-field'>
                  <label htmlFor='password' className='input-lable'>Confirme password</label>
                  <input type="password" className='input' onChange={(e) => {setConfirmePassword(e.target.value)}} id='password' required/>
                </div>
                <div className='input-field'>
                  <button id='cd' onClick={handleSubmit}>Sign Up</button>
                </div>
                <div className='invalid'>
                  { err && <p className='login-error-message'>{err}</p> }
                </div>                <div className='signup'>
                  <span> <Link to='/login'>Do you have account?</Link></span> 
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default RegisterAdmin