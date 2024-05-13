
import React, { useContext } from 'react'
import '../../styles/FileItem.css'
import { faFileAlt, faSpinner, faTrash, faDownload } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { isUploading } from '../../state'
import { useRecoilState } from 'recoil'
import { Link } from 'react-router-dom'
import '../../styles/UrlItem.css'
import '../../styles/FileItem.css'
import { AuthContext } from '../../context/authContext'

const UrlItem = ({ file, deleteFile, userId }) => {
    const [isUploading_, setIsUploading_] = useRecoilState(isUploading);
    const { currentUser } = useContext(AuthContext)
  
    // Function to handle file download
    // const handleDownload = (file) => {
    //   try{
    //     console.log(file.fileName);
    //    const a = document.createElement('a');
    //    a.href = file.filePath;
    //    a.download = file.fileName; // Specify the desired filename
    //    a.target = '_blank'; // Open in a new tab (optional)
    //   //  a.rel = 'noopener noreferrer'; // Security best practice
   
    //    // Trigger the click event to start the download
    //    a.click();
    //  } catch (error) {
    //    console.error('Error downloading file:', error);
    //  }
    //    };
    const handleDownload = (file) => {
      try {
        const a = document.createElement('a');
        
        // Remove the appended random string from the file name
        const fileNameWithoutRandom = file.fileName.replace(/-\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/, '');
        
        // Build the new download URL without the random string
        const downloadUrl = file.filePath.replace(file.fileName, fileNameWithoutRandom);
        
        a.href = downloadUrl;
        a.download = fileNameWithoutRandom; // Specify the desired filename
        a.target = '_blank'; // Open in a new tab (optional)
            a.setAttribute('download', ''); // Force download

        // Trigger the click event to start the download
        a.click();
      } catch (error) {
        console.error('Error downloading file:', error);
      }
    };
    
    
  
    return (
      <li className="list-item" key={file.name}>
        <span className="file-item-left">
          <FontAwesomeIcon icon={faFileAlt} />
          <Link className="file-name" to="#"
          onClick={() => handleDownload(file)}>
          <p >{file && file.fileName.substring(0, 12)}</p>
          </Link>
        </span>
        <div className="action">
          {  (
            <>
              <Link to='#'>
                <FontAwesomeIcon
                    id="download-file-icon"
                    icon={faDownload}
                    onClick={() => handleDownload(file)}
                />
              
              </Link>
              {
               currentUser && currentUser.id == userId ?
              <FontAwesomeIcon
                id="trash-file-icon"
                icon={faTrash}
                onClick={() => deleteFile(file.id, file && file.fileName)}
              />
              :
              null
              }
            </>
          )}
        </div>
      </li>
    );
  };
 
  
  
  
  
export default UrlItem