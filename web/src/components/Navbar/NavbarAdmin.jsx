import React from 'react'
import logo from '../../assets/tuulio_logo.png'
import '../../styles/Navbar.css'
import { Link } from 'react-router-dom'


const NavbarAdmin = () => {
  return (
    <nav class="navbar navbar-expand-lg navbar-light dc">
      <div class="container-fluid" id='custom-container'>
        <div className="logo">
          <Link to='/'><div><span className='red'>Red</span><span id=''> House</span></div></Link>
        </div>
        <button class="navbar-toggler" type="button" id='navbar-toggler' data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavDropdown">
          <ul class="navbar-nav ms-auto">
            <li class="nav-item" id='nav-item'>
              <Link class="nav-link" id='nav-link' aria-current="page" to="./">Home</Link>
            </li>
            <li class="nav-item" id='nav-item'>
              <Link class="btn" id='navbar-btn' to="../login">Log Out</Link>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  )
}

export default NavbarAdmin;


