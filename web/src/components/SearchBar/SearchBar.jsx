import React, {useState} from 'react'
import { FaSearch } from 'react-icons/fa'
import '../../styles/SearchBar.css'
import axios from 'axios'
import { useRecoilState } from 'recoil'
import { keywordQuery } from '../../state'

const SearchBar = ({searchHint}) => {
    const [input, setInput] = useState("")
    const [keyword, setKeyword] = useRecoilState(keywordQuery);
    

    const handleChange = (value) => {
        setKeyword(value);
    }
    
  return (
    <div className="searchBarCon">
      {
        <div className="note-search">To achieve the best results, search by keywords in the property location, property code, and property description ...</div>
      }
        <div className='input-wrapper '>
        <input placeholder= {searchHint}  className='palceholder' onChange={(e) => handleChange(e.target.value)}
        />
         <span className='search-icon-span'><FaSearch id='search-icon' /></span>
    </div> 
    </div>
    
  )
}

export default SearchBar