import React, {useContext, useEffect, useState} from 'react'
import '../../styles/CreatePost.css'
import { faPlay } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { Link, useNavigate } from 'react-router-dom'
import '../../styles/register.css'
import { faFileArrowUp } from '@fortawesome/free-solid-svg-icons'
import { faFloppyDisk } from '@fortawesome/free-solid-svg-icons'
import '../File/FileUpload.jsx'
import submit from '../../assets/submit.png'
import FileUpload from '../File/FileUpload.jsx'
import FileList from '../File/FileList'
import MultiSelect from './MultiSelect'
import Multiselect from 'multiselect-react-dropdown';
import { createdPost, filesData, filesList, filesPaths, filesPathsDic, isCreatingPost, isUploading, viewingPostDetails } from '../../state'
import { useRecoilState } from 'recoil'
import {
  ref,
  uploadBytes,
  getDownloadURL,
  listAll,
  list,
  deleteObject,
} from "firebase/storage";
import { storage } from "../../firebase";
import { v4 } from "uuid";
import axios from 'axios'
import { AuthContext } from '../../context/authContext'
import Swal from 'sweetalert2'
import { ToastContainer, toast } from 'react-toastify'


const CreatePost = () => {
  const [post, setPost] = useRecoilState(createdPost)
  const [isCreating, setIsCreating] = useRecoilState(isCreatingPost)
  const navigate = useNavigate()
  const [files, setFiles] = useRecoilState(filesData)
  const [filesList_, setFilesList_] = useRecoilState(filesList)
  const [filesListCurr, setFilesListCurr] = useState([]);
  const [isUploading_, setIsUploading_] = useRecoilState(isUploading);
  const [selectedCategories_, setSelectedCategories_] = useState([]);
  const [filesPathsDic_, SetFilesPathsDic_] = useRecoilState(filesPathsDic);
  const [err, setError] = useState(null);
  const { currentUser } = useContext(AuthContext);
  const [isViewingPostDetails, setIsViewingPostDetails] = useRecoilState(viewingPostDetails)
  
  const handleChange = (e) => {
    setPost((prev) => ({ ...prev, [e.target.name]: e.target.value }));
    console.log(post);
  };
  
  const removeFile = (filename) => {
    try {
      const fileRef = filesPathsDic_[filename][1];
      deleteObject(fileRef);
      console.log('File deleted successfully');
  
      // Filter the filesList and update the state
      setFiles(files.filter((file) => file.name !== filename));
      setFilesListCurr(filesList_.filter((file) => file.fileName !== filename));
  
      // Use the updated fileList within a useEffect
  
      delete filesPathsDic_.filename;
    } catch (error) {
      console.error('Error deleting file:', error.message);
    }
  };
  
  useEffect(() => {
    setFilesList_(filesListCurr);
  }, [filesListCurr]);
  
  


  const [categories, setCategories] = useState(["Vocabulary", "Practice Sheets", "Written Texts", "Grammar Practice", "Visuals/Images", "Parts of Speech",
  "Presentations", "Infographics", "Verbs", "Adjectives", "Nouns"])

  const handleSubmitPost = async (event) => {
    event.preventDefault();
    const updatedPost = {
      ...post,
      filesList: [...filesList_],
      categories: [...selectedCategories_],
      userId: currentUser.id,
      userLanguage: currentUser.nativeLanguage,
    };
    // Use the updatedPost in further operations
    try {
      const res = await axios.post(`${process.env.REACT_APP_BASE_URL}/posts`, updatedPost);
      setIsCreating(false);
      setIsViewingPostDetails(false)
      console.log(res)
      navigate('../');
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
      if (err.response && err.response.status == 401){
        navigate('/login')
      }
      console.log(err)
      setError('There is a wrong happened during creating the post. Please check your inputs and try again!');
      return
    }
    Swal.fire({
      position: 'center',
      icon: 'success',
      confirmButtonColor: '#00BF63',
      title: 'Your work has been saved',
      showConfirmButton: false,
      timer: 1500
    })
  };
  

  const habdleDiscardPost = () =>{
    files.map((file) => {
      removeFile(file.name)
    })
    filesList_.map((file) => {
      removeFile(file.name)
    })
    setIsCreating(false);
    setIsViewingPostDetails(false)
    navigate('../')
    console.log(filesList_)
  }

  useEffect(() => {
    setFilesList_(filesList)
  }, [filesList])

  useEffect(()=>{
    setIsCreating(true)
    setIsViewingPostDetails(true)
    setFilesList_([])
    setFiles([])  
    setPost({})
  }, [])
  

  
  // console.log(files)
  return (
    <div className='container' id='create-post-container'>
        <form>
        <ToastContainer />
            <div className="row" id='title-lable'>
                Post title
            </div>
            <div className="row">
                <input className='post-title-create' name='title' placeholder='Max size: 100 character' required type="text" onChange={handleChange} />
            </div>
            <div className="row" id='title-lable'>
                Post description
            </div>
            <div className="row">
                <div className="form-outline mb-4 post-description-create">
                    <textarea className="form-control" placeholder='Max size: 1500 character' name='description' onChange={handleChange} id="textAreaExample6" rows="3"></textarea>
                </div> 
            </div>
            <div className="row" id='select-category'>
              <Multiselect
                name='selectedCategories_'
                onChange={handleChange}
                id='multiselect'
                isObject={false}
                placeholder={"Select post categories ..."}
                onSelect={(selectedCategories) => { setSelectedCategories_(selectedCategories) ;
                console.log(selectedCategories_)
                }}
                onRemove={(selectedCategories) => { setSelectedCategories_(selectedCategories) ;
                  console.log(selectedCategories_)
                  }}
                options={categories}
              />
            </div>
            <div className="row" id='post-error'>
            { err && <p className='post-error-message'>{err}</p> }
            </div>

           <div className="row">
            <FileUpload removeFile={removeFile}/>
           </div>
           <div className="row">
             <FileList  removeFile={removeFile} />
           </div>
           <div className="note-pdf">Note: You can upload only PDF file types.</div>

            <div className="row dot">...</div>

           
            <div className="row" id='save-dicard' >
              <div className="col-md-6">
                <button onClick={handleSubmitPost} disabled={isUploading_} id='save' required autoComplete='off'>Save post</button>
              </div>
              <div className="col-md-6">
                <button onClick={habdleDiscardPost} disabled={isUploading_} id='discard' required autoComplete='off'>Discard</button>
              </div>
            </div>
        </form>
    </div>
  )
}

export default CreatePost