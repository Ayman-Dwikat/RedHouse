import React, { useContext } from 'react'
import logo from '../../assets/tuulio_logo.png'
import '../../styles/Navbar.css'
import { Link, useNavigate } from 'react-router-dom'
import { AuthContext } from '../../context/authContext'
import { useRecoilState, useRecoilValue } from 'recoil'
import { currentUser, isCreatingPost, isLoading, logout } from '../../state'
import Swal from 'sweetalert2'

const Navbar = () => {
  const navigate = useNavigate();
  const { currentUser, logout } = useContext(AuthContext)
  const [isCreating, setIsCreating] = useRecoilState(isCreatingPost)
  const [isLoadingPage, setIsLoadingPage] = useRecoilState(isLoading);
  return (
    <nav class="navbar navbar-expand-lg navbar-light dc" >
      <div class="container-fluid" id='custom-container'>
        <Link className="logo" to='/'><div><span id='red'>Red</span><span id='house'>House</span></div></Link>

        <button className="navbar-toggler" type="button" id='navbar-toggler' data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
          <span className="navbar-toggler-icon"></span>
        </button>
        <div className="collapse navbar-collapse" id="navbarNavDropdown">
          <ul className="navbar-nav ms-auto" id="navbarNavDropdown1">

            <li className="nav-item" id='nav-item'>
              <Link className="nav-link" id='nav-link' aria-current="page" onClick={() => { setIsLoadingPage(true) }} to="/verification-requests">Personal verification requests
              </Link>
            </li>

            <li className="nav-item" id='nav-item'>
              <Link className="nav-link" id='nav-link' aria-current="page" onClick={() => { setIsLoadingPage(true) }} to="/user-complains">Complains</Link>
            </li>


            {!(currentUser && currentUser.userRole == 'admin') ?
              <li className="nav-item" id='nav-item'>

                <div className="create-account">
                  <Link id='navbar-btn' onClick={() => { }} to="/register-admin">Create new administration account </Link>
                </div>

              </li>
              :
              null
            }
            <li className="nav-item" id='nav-item'>
              {!currentUser ?
                (<span onClick={() => {
                  logout(false)

                  // navigate('/alert')
                }}>
                  <Link id='navbar-btn' to="login">Log Out</Link>
                </span>)
                :
                (<span>
                  <Link id='navbar-btn' to="login">Login</Link>
                </span>)
              }
            </li>
          </ul>
        </div>
      </div>
    </nav>
  )
}

export default Navbar;


