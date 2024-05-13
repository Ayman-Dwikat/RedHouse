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
import { faFileAlt, faSpinner, faTrash } from '@fortawesome/free-solid-svg-icons'
import { v4 } from "uuid";
import { ToastContainer, toast } from 'react-toastify'
import { Email } from '../../state'
import { useRecoilState } from 'recoil'
import Swal from 'sweetalert2'

const Register = () => {
// useEffect(() => {

// }, [verifiedEmail])

  // const [imageUpload, setImageUpload] = useState(null);
  const [confirmePassword, setConfirmePassword] = useState('')
  const [isUploading, setIsUploading] = useState(false)
  const [uploading, setUploading] = useState(false)
  const [uploadingFile, setUploadingFile] = useState("")
  const [verifiedEmail, setVerifiedEmail] = useRecoilState(Email)
  // const [password, setPassword] = useState('')
  const [input, setInputs] = useState({
    firstName: "",
    lastName:"",
    email: "",
    nativeLanguage: "",
    imagePath: "",
    password: "",
    userRole: "volunteer",
    isVerified: '0'
  })
  const [err, setError] = useState(null)
  const navigate = useNavigate();

  useEffect(() => {
    setUploadingFile(uploading)
  }, [uploading]);
  
  const handleChange = e =>{
    setInputs(prev=>({...prev, [e.target.name]: e.target.value}))
  }

  const uploadFile = (imageUpload) => {
    if (imageUpload == null) return;
    
    console.log(isUploading); // This will still log false immediately
    
    setIsUploading(true); // Set isUploading to true before starting the upload
  
    const preImagePath = ref(storage, imageUpload.name + v4());
    uploadBytes(preImagePath, imageUpload).then((snapshot) => {
      getDownloadURL(snapshot.ref).then((url) => {
        setInputs((prevInputs) => ({
          ...prevInputs,
          imagePath: url,
        }));
        console.log(input);
        setUploadingFile(imageUpload.name);
        setIsUploading(false); // Set isUploading to false after the upload is complete
      });
    });
  };
  

  const handleSubmit = async (e) =>{
    e.preventDefault();
    setVerifiedEmail(input.email)
    uploadFile()
    if(confirmePassword !== input.password)
    {
      setError('password and confirme password fields do not match')
      return
    }
    e.preventDefault();
    try{
      const res = await axios.post(`${process.env.REACT_APP_BASE_URL}/auth/register`, input)
      console.log(res,"response")
      Swal.fire({
        position: 'center',
        icon: 'success',
        confirmButtonColor: '#00BF63',
        title: 'Confirmation link has been sent to your email',
        showConfirmButton: false,
        timer: 1500
      });
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
                  <label htmlFor='email' className='input-lable'>Native language</label>
                  <select class="form-select" name='nativeLanguage' id="languages" onChange={handleChange}>
                    <option>language</option>
                    <option value="Afrikaans">Afrikaans</option>
                    <option value="Afrikaans">Afrikaans</option>
                    <option value="Albanian">Albanian - shqip</option>
                    <option value="Amharic">Amharic - አማርኛ</option>
                    <option value="Arabic">Arabic - العربية</option>
                    <option value="Aragonese">Aragonese - aragonés</option>
                    <option value="Armenian">Armenian - հայերեն</option>
                    <option value="Asturian">Asturian - asturianu</option>
                    <option value="Azerbaijani">Azerbaijani - azərbaycan dili</option>
                    <option value="Basque">Basque - euskara</option>
                    <option value="Belarusian">Belarusian - беларуская</option>
                    <option value="Bengali">Bengali - বাংলা</option>
                    <option value="Bosnian">Bosnian - bosanski</option>
                    <option value="Breton">Breton - brezhoneg</option>
                    <option value="Bulgarian">Bulgarian - български</option>
                    <option value="Catalan">Catalan - català</option>
                    <option value="Central Kurdish">Central Kurdish - کوردی (دەستنوسی عەرەبی)</option>
                    <option value="Chinese">Chinese - 中文</option>
                    <option value="Corsican">Corsican</option>
                    <option value="Croatian">Croatian - hrvatski</option>
                    <option value="Czech">Czech - čeština</option>
                    <option value="Danish">Danish - dansk</option>
                    <option value="Dutch">Dutch - Nederlands</option>
                    <option value="English">English</option>
                    <option value="English">English (United Kingdom)</option>
                    <option value="English">English (United States)</option>
                    <option value="Esperanto">Esperanto - esperanto</option>
                    <option value="Estonian">Estonian - eesti</option>
                    <option value="Faroese">Faroese - føroyskt</option>
                    <option value="Filipino">Filipino</option>
                    <option value="Finnish">Finnish - suomi</option>
                    <option value="French">French - français</option>
                    <option value="French">French - français (France)</option>
                    <option value="Galician">Galician - galego</option>
                    <option value="Georgian">Georgian - ქართული</option>
                    <option value="German">German - Deutsch (Deutschland)</option>
                    <option value="Greek">Greek - Ελληνικά</option>
                    <option value="Guarani">Guarani</option>
                    <option value="Gujarati">Gujarati - ગુજરાતી</option>
                    <option value="Hausa">Hausa</option>
                    <option value="Hawaiian">Hawaiian - ʻŌlelo Hawaiʻi</option>
                    <option value="Hebrew">Hebrew - עברית</option>
                    <option value="Hindi">Hindi - हिन्दी</option>
                    <option value="Hungarian">Hungarian - magyar</option>
                    <option value="Icelandic">Icelandic - íslenska</option>
                    <option value="Indonesian">Indonesian - Indonesia</option>
                    <option value="Interlingua">Interlingua</option>
                    <option value="Irish">Irish - Gaeilge</option>
                    <option value="Italian">Italian - italiano (Svizzera)</option>
                    <option value="Japanese">Japanese - 日本語</option>
                    <option value="Kannada">Kannada - ಕನ್ನಡ</option>
                    <option value="Kazakh">Kazakh - қазақ тілі</option>
                    <option value="Khmer">Khmer - ខ្មែរ</option>
                    <option value="Korean">Korean - 한국어</option>
                    <option value="Kurdish">Kurdish - Kurdî</option>
                    <option value="Kyrgyz">Kyrgyz - кыргызча</option>
                    <option value="Lao">Lao - ລາວ</option>
                    <option value="Latin">Latin</option>
                    <option value="Latvian">Latvian - latviešu</option>
                    <option value="Lingala">Lingala - lingála</option>
                    <option value="Lithuanian">Lithuanian - lietuvių</option>
                    <option value="Macedonian">Macedonian - македонски</option>
                    <option value="Malay">Malay - Bahasa Melayu</option>
                    <option value="Malayalam">Malayalam - മലയാളം</option>
                    <option value="Maltese">Maltese - Malti</option>
                    <option value="Marathi">Marathi - मराठी</option>
                    <option value="Mongolian">Mongolian - монгол</option>
                    <option value="Nepali">Nepali - नेपाली</option>
                    <option value="Norwegian">Norwegian Nynorsk - nynorsk</option>
                    <option value="Occitan">Occitan</option>
                    <option value="Oriya">Oriya - ଓଡ଼ିଆ</option>
                    <option value="Oromo">Oromo - Oromoo</option>
                    <option value="Pashto">Pashto - پښتو</option>
                    <option value="Persian">Persian - فارسی</option>
                    <option value="Polish">Polish - polski</option>
                    <option value="Portuguese">Portuguese - português</option>
                    <option value="Portuguese">Portuguese - português</option>
                    <option value="Punjabi">Punjabi - ਪੰਜਾਬੀ</option>
                    <option value="Quechua">Quechua</option>
                   <option value="Romansh">Romansh - rumantsch</option>
                    <option value="Russian">Russian - русский</option>
                    <option value="gScottishd">Scottish Gaelic</option>
                    <option value="Serbian">Serbian - српски</option>
                    <option value="Serbo">Serbo-Croatian - Srpskohrvatski</option>
                    <option value="Shona">Shona - chiShona</option>
                    <option value="Sindhi">Sindhi</option>
                    <option value="Sinhala">Sinhala - සිංහල</option>
                    <option value="Slovak">Slovak - slovenčina</option>
                    <option value="Slovenian">Slovenian - slovenščina</option>
                    <option value="Somali">Somali - Soomaali</option>
                    <option value="Southern">Southern Sotho</option>
                    <option value="Spanish">Spanish - español</option>
                    <option value="Spanish">Spanish - español</option>
                    <option value="Sundanese">Sundanese</option>
                    <option value="Swahili">Swahili - Kiswahili</option>
                    <option value="Swedish">Swedish - svenska</option>
                    <option value="Tajik">Tajik - тоҷикӣ</option>
                    <option value="Tamil">Tamil - தமிழ்</option>
                    <option value="Tatar">Tatar</option>
                    <option value="Telugu">Telugu - తెలుగు</option>
                    <option value="Thai">Thai - ไทย</option>
                    <option value="Tigrinya">Tigrinya - ትግርኛ</option>
                    <option value="Tongan">Tongan - lea fakatonga</option>
                    <option value="Turkish">Turkish - Türkçe</option>
                    <option value="Turkmen">Turkmen</option>
                    <option value="Twi">Twi</option>
                    <option value="Ukrainian">Ukrainian - українська</option>
                    <option value="Urdu">Urdu - اردو</option>
                    <option value="Uyghur">Uyghur</option>
                    <option value="Uzbek">Uzbek - o‘zbek</option>
                    <option value="Vietnamese">Vietnamese - Tiếng Việt</option>
                    <option value="Walloon">Walloon - wa</option>
                    <option value="Welsh">Welsh - Cymraeg</option>
                    <option value="Western">Western Frisian</option>
                    <option value="Xhosa">Xhosa</option>
                    <option value="Yiddish">Yiddish</option>
                    <option value="Yoruba">Yoruba - Èdè Yorùbá</option>
                    <option value="Zulu">Zulu - isiZulu</option>
                </select>
                </div>
                <div className= {isUploading ? 'label-uploading' : 'input-field'} id='select-file' >
                 {!isUploading ?
                 <>
                  <label htmlFor='file' className='select-profile'> {uploadingFile ? uploadingFile : "Selecte profile picture"}</label>
                  <label htmlFor='file' className='file-lable'> <FontAwesomeIcon icon={faFileArrowUp} id='file-icon'/> Choose file</label>
                  <input type="file" className='input' id='file' onChange={(event) => {
                      uploadFile(event.target.files[0]);
                    }} required autoComplete='off'/>
                </>  
                :
                <>
                  <span>Uploading...</span>
                  <FontAwesomeIcon icon={faSpinner} className='fa-spin-icon' /> 
                </>
            }
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

export default Register