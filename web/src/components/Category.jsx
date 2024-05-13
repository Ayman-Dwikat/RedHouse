import React from 'react'
import '../styles/Category.css'


const Category = ({categoryContent}) => {
  return (
    <span className="category">
        { categoryContent }
    </span>
  )
}

export default Category