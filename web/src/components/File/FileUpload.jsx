import React, { useEffect, useState } from 'react'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { Link } from 'react-router-dom'
import '../../styles/register.css'
import { faFileArrowUp } from '@fortawesome/free-solid-svg-icons'
import { faFloppyDisk } from '@fortawesome/free-solid-svg-icons'
import '../../styles/CreatePost.css'
import axios from 'axios'
import { createPost, createdPost, filesData, filesList, filesPaths, filesPathsDic, isCreatingPost, isUploading } from '../../state'
import { useRecoilState } from 'recoil'
import {
  ref,
  uploadBytes,
  getDownloadURL,
  listAll,
  list,
} from "firebase/storage";
import { storage } from "../../firebase";
import { v4 } from "uuid";

const FileUpload = ({ removeFile }) => {
  const [err, setError] = useState('');
  const [files, setFiles] = useRecoilState(filesData);
  const [post, setPost] = useRecoilState(createdPost);
  const [filesList_, setFilesList_] = useRecoilState(filesList);
  const [isUploading_, setIsUploading_] = useRecoilState(isUploading);
  const [filesPathsDic_, setFilesPathsDic_] = useRecoilState(filesPathsDic);

  const uploadHandler = async (event) => {
    const newFiles = Array.from(event.target.files);

    // Check if all selected files are PDFs
    const allFilesArePDF = newFiles.every(file => file.type === 'application/pdf');
    
    if (!allFilesArePDF) {
      setError('Please upload only PDF files.');
      return;
    }

    setError(''); // Clear any previous error

    setFiles([...files, ...newFiles]);

    if (newFiles.length === 0) return;

    setIsUploading_(true);

    await Promise.all(
      newFiles.map(async (file) => {
        const preImagePath = ref(storage, v4() + file.name);

        await uploadBytes(preImagePath, file).then(async (snapshot) => {
          const url = await getDownloadURL(snapshot.ref);

          // Update the filesPathsDic_ dictionary
          setFilesPathsDic_((prevDictionary) => ({
            ...prevDictionary,
            [file.name]: [url, preImagePath],
          }));

          const newFile = {
            filePath: url,
            fileName: file.name,
            fileRef: preImagePath._location.path_,
          };

          // Update the filesPaths_ array
          setFilesList_((prev) => [...prev, newFile]);
        });
      })
    );

    setIsUploading_(false);

    // Update the filesPaths in the setPost function
    console.log(post);
  };

  useEffect(() => {
    // Whenever filesPaths_ changes, update the post state
    setPost((prevInputs) => ({
      ...prevInputs,
      filesList: filesList_,
    }));
    console.log(filesList_);
  }, [filesList_]);

  return (
    <>
      <label
        htmlFor='file'
        className={isUploading_ ? 'label-uploading' : 'upload-file'}
        id='upload-file'
      >
        <FontAwesomeIcon className='file-icon' icon={faFileArrowUp} />{' '}
        {isUploading_ ? 'Uploading...' : 'Upload PDF file/files'}
      </label>
      <input
        type='file'
        multiple
        accept='.pdf' // Specify the accepted file types
        className='input'
        onChange={uploadHandler}
        disabled={isUploading_}
        id='file'
        required
        autoComplete='off'
      />
      <div className='invalid'>{err && <p className='login-error-message'>{err}</p>}</div>
    </>
  );
};

  
  

export default FileUpload