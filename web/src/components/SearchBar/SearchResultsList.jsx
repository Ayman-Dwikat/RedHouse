import React from 'react'
import '../../styles/SearchResultsList.css'


const SearchResultsList = ({results}) => {
  return (
    <div className='results-list'>
        {
            results.map((res, id) =>{
                return <div key={id}>res.name</div>
            })
        }
    </div>
  )
}

export default SearchResultsList