
import React from 'react'
import '../../styles/FileItem.css'
import { faFileAlt, faSpinner, faTrash } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { isUploading } from '../../state'
import { useRecoilState } from 'recoil'


const FileItem = ({file, deleteFile}) => {
    const [isUploading_, setIsUploading_] = useRecoilState(isUploading)

  return (
    <li className='list-item'
    key={file.name}>
        <span className='file-item-left'>
            <FontAwesomeIcon icon={faFileAlt} />
            <p className='file-name'>{file.name}</p>
        </span>
        <div className='action'>
            {
                isUploading_ && 
                <FontAwesomeIcon icon={faSpinner} className='fa-spin' /> 
            }
            {
                !isUploading_ && 
                <FontAwesomeIcon id='trash-file-icon' icon={faTrash} 
                onClick={() => deleteFile(file.name)} />
            }
        </div>
    </li>
  )
}

export default FileItem