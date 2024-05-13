import React from 'react'
import FileItem from './FileItem'
import axios from 'axios'
import { filesData, filesList } from '../../state'
import { useRecoilState } from 'recoil'
import '../../styles/FileList.css'

const FileList = ({ removeFile}) => {
  const [files, setFiles] = useRecoilState(filesData)
    const deleteFileHandler = (_name) => {
      removeFile(_name)
    }
    
  return (
    <ul className='file-list'>
        {
            files &&
            files.map(f => <FileItem
                key={f.name}
                file={f}
                deleteFile={deleteFileHandler}
                />)
        }
    </ul>
  )
}

export default FileList