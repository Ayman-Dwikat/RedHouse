import React, { useContext, useEffect, useState } from 'react'
import '../styles/Student.css'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { Link, Outlet, useNavigate, useParams } from 'react-router-dom'
import { useRecoilState } from 'recoil'
import { isCreatingPost, viewingPostDetails } from '../state'
import axios from 'axios'
import { AuthContext } from '../context/authContext'
import { ToastContainer, toast } from 'react-toastify'
import Cookie from 'js-cookie'
import FilterBar from '../components/SearchBar/FilterBar'
import SearchBar from '../components/SearchBar/SearchBar'

import { faFire } from '@fortawesome/free-solid-svg-icons'


import "bootstrap/dist/css/bootstrap.min.css";
import ReactPaginate from "react-paginate";
import '../styles/UserList.css'
import { categoryFilterQuery, keywordQuery, languageFilterQuery, usersRows } from "../state";
import UsersTable from "../components/Users/UsersTable";
import ClipLoader from "react-spinners/ClipLoader";
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import '../styles/UserList.css';
import '../styles/UserTable.css';
import profile_pic from '../assets/user-pic.png';
import Swal from 'sweetalert2';




const UserComplaints = () => {
  const [page, setPage] = useState(1); // Start page from 1
  const [limit, setLimit] = useState(10);
  const [pages, setPages] = useState(0);
  const [rows, setRows] = useState(0);
  // const [keyword, setKeyword] = useRecoilState(keywordQuery);
  // const [languageFilter, setLanguageFilter] = useRecoilState(languageFilterQuery);
  const [complaintsPerDay, setComplaintsPerDay] = useState(null);
  const [msg, setMsg] = useState("");
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const { currentUser, logout } = useContext(AuthContext)
  const [isCreating, setIsCreating] = useRecoilState(isCreatingPost)
  const [isCreatingLocal, setIsCreatingLocal] = useState(false);

  const [isViewingPostDetails, setIsViewingPostDetails] = useRecoilState(viewingPostDetails)
  const [isViewingPostDetailsLocal, setIsViewingPostDetailsLocal] = useState(false)
  const [isMounted, setIsMounted] = useState(true);
  const [studentData, setStudentData] = useState({})
  const params = useParams();



  const getComplaints = async () => {
    try {
      setComplaintsPerDay([]);
      setLoading(true);

      const response = await axios.get(`${process.env.REACT_APP_BASE_URL}/complaints/number-of-complaints-per-day?page=${page}&limit=${limit}`);
      setComplaintsPerDay(response.data.value.listDto);
      console.log(response.data.value);
      setPage(response.data.value.pagination.pageNumber);
      setPages(response.data.value.pagination.totalPages);
      setRows(response.data.value.pagination.totalRows);
    } catch (err) {
      if (err.message === 'Network Error' && !err.response) {
        toast.error('Network error - make sure the server is running!', {
          position: "top-center",
          autoClose: 10000,
          hideProgressBar: false,
          closeOnClick: true,
          pauseOnHover: true,
          draggable: true,
          progress: undefined,
          theme: "colored",
        });
      } else if (err.response && err.response.status === 401) {
        navigate('/login');
      }
      console.error(err);
    } finally {
      setLoading(false); // Set loading to false when the request is completed (success or error)
    }
  };

  const changePage = ({ selected }) => {
    console.log(selected);
    setPage(selected + 1);
    console.log(complaintsPerDay);
    // Add 1 to start from page 1
    if (selected === 9) {
      setMsg(".........");
    } else {
      setMsg("");
    }
  };



  const getCookie = (cookieName) => {
    const cookieValue = Cookie.get(cookieName);
    return cookieValue;
  }


  useEffect(() => {
    const fetchData = async () => {
      try {
        // Get the access token from a cookie named "access_token_tuulio"
        const currentCookie = getCookie("access_token_tuulio");

        // Check if the access token is available
        if (!currentCookie) {
          // Handle the case where the access token is missing or undefined
          console.log("Access token is missing.");
        }

        // Make an authenticated request using the access token
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/verifyUser/${currentCookie}`);

        // Process the response data if needed

        // Example: Log the response data
        console.log("Response data:", res.data);
      } catch (err) {
        if (err.message === 'Network Error' && !err.response) {
          // Handle network error
          toast.error('Network error - make sure the server is running!', {
            position: "top-center",
            autoClose: 10000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "dark",
          });
        } else if (err.response && err.response.status === 401) {
          // Handle unauthorized access (status code 401)
          if (currentUser) {
            console.log("Unauthorized access - redirecting to login.");
            navigate('/login');
          }
        } else {
          // Handle other errors
          console.error("An error occurred:", err);
        }
      }
    };


    const fetchStudent = async () => {
      try {
        console.log(atob(params.id));
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/users/${atob(params.id)}`);
        setStudentData(res.data)
        console.log(studentData);
        return
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
            theme: "dark",
          });
        else if (err.response && err.response.status === 401) {
          if (currentUser) {
            console.log(err + '---------------------------------------------------------------');
            navigate('/login');
          }

        }
        console.log(err);
      }
    };

    // fetchData();
    // fetchStudent()
    getComplaints()
  }, []);



  const languageOptions = [
    { value: '', label: '' },
    { value: 'Newest', label: 'Newest' },
    { value: 'Oldest', label: 'Oldest' },
  ];


  // const [rows, setUsers] = React.useState(rows);
  const [clickedRows, setClickedRows] = React.useState([]);







  const passUser = async (isPass, userId) => {
    try {
      const response = await axios.put(`${process.env.REACT_APP_BASE_URL}/users/${userId}/update-isPass`, { isPass: isPass });
    } catch (err) {
      if (err.message === 'Network Error' && !err.response) {
        toast.error('Network error - make sure the server is running!', {
          position: 'top-center',
          autoClose: 10000,
          hideProgressBar: false,
          closeOnClick: true,
          pauseOnHover: true,
          draggable: true,
          progress: undefined,
          theme: 'colored',
        });
      } else if (err.response && err.response.status === 401) {
        navigate('/login');
      }
      console.error(err);
    }
  }


  const deleteUser = async (userId) => {
    Swal.fire({
      title: 'Are you sure you want to delete this user?',
      showCancelButton: true,
      confirmButtonColor: '#00BF63',
      confirmButtonText: 'Delete',
      customClass: "Custom_btn"

    }).then(async (result) => {
      /* Read more about isConfirmed, isDenied below */
      if (result.isConfirmed) {
        Swal.fire('Done!', '', 'success')
        try {
          const res = await axios.delete(`${process.env.REACT_APP_BASE_URL}/users/${userId}`);
          console.log(res.data)
          // console.log(res.data[0].id);
          const updatedUsers = complaintsPerDay.filter(post => post.id !== userId)
          setComplaintsPerDay(updatedUsers)
        } catch (err) {

          if (err.message === 'Network Error' && !err.response) {
            toast.error('Network error - make sure the server is running!', {
              position: 'top-center',
              autoClose: 10000,
              hideProgressBar: false,
              closeOnClick: true,
              pauseOnHover: true,
              draggable: true,
              progress: undefined,
              theme: 'colored',
            });
          } else if (err.response && err.response.status === 401) {
            navigate('/login');
          }
          console.error(err);
        }
      } else if (result.isDenied) {
        Swal.fire('Changes are not saved', '', 'info')
      }
    })

  }


  function handleButtonClick(row) {
    const newIsPass = row.isPass === '1' ? '0' : '1';

    // Create a new array of users with the updated isPass value
    const updatedUsers = complaintsPerDay.map((user) =>
      user.id === row.id ? { ...user, isPass: newIsPass } : user
    );

    // Update the state with the modified users array
    setComplaintsPerDay(updatedUsers);

    // Call passUser function to update the backend if needed
    passUser(newIsPass, row.id);
  }

  return (
    <div className='container' id='student-container' style={{ marginTop: "50px" }}>
      <div style={{ paddingRight: "120px" }}>
        <div className="row">
          <div className="l-search">Users Complaints</div>
        </div>
        <div style={{ height: "40px" }}></div>
      </div>
      <div className="container mt-4">
        <div className="row">
          <div className="col-12">
            {loading ? ( // Display the spinner conditionally based on the loading state
              <div style={{ marginBottom: '400px', marginTop: '380px', display: 'flex', justifyContent: 'center' }}>
                <ClipLoader
                  color={"#00BF63"}
                  loading={true}
                  size={40}
                  aria-label="Loading Spinner"
                  data-testid="loader"
                />
              </div>


            ) :
              (<>
                {complaintsPerDay == null ? (
                  <div style={{ marginBottom: '20px', display: 'flex', justifyContent: 'center' }}>
                    <ClipLoader
                      color={"#00BF63"}
                      loading={true}
                      // cssOverride={override}
                      size={40}
                      aria-label="Loading Spinner"
                      data-testid="loader"
                    />
                  </div>


                ) : (
                  <TableContainer component={Paper}>
                    <Table sx={{ minWidth: 550 }} aria-label="simple table">
                      <TableHead>
                        <TableRow>
                          <TableCell>Picture</TableCell>
                          <TableCell align="left">Date</TableCell>
                          <TableCell align="left">Number of complaints</TableCell>
                        </TableRow>
                      </TableHead>
                      <TableBody>
                        {complaintsPerDay ?
                          complaintsPerDay.map((inDay) => (
                            <TableRow
                            style={{justifyContent: "center", width: "450px"}}
                              key={inDay && inDay.id}
                              sx={{
                                '&:last-child td, &:last-child th': { border: 0 },
                              }}
                            >

                              <TableCell component="th" scope="row">
                                
                                <FontAwesomeIcon icon={faFire} style={{fontSize: "28px"}}/>
                                  
                              </TableCell>

                              <Link to={`/complaints-list/${inDay && btoa(inDay.complainDate)}`} >
                                <TableCell id='username-link' align="left">{inDay && inDay.complainDate.substring(0, 10)}</TableCell>
                              </Link>
                              <TableCell style={{justifyContent: "center", paddingLeft: "80px"}} >{inDay && inDay.complaints}</TableCell>
                            </TableRow>
                          ))
                          :
                          <h3 style={{ textAlign: "center" }}>No data found!</h3>
                        }
                      </TableBody>
                    </Table>
                  </TableContainer>)}</>)}
            <p className="text-muted">
              Total Users: {rows} Page: {page} of {pages}
            </p>
            <p className="text-danger">{msg}</p>
            <nav className="d-flex justify-content-center">
              <ReactPaginate
                breakLabel="..."
                previousLabel={"Prev"}
                nextLabel={"Next"}
                pageRangeDisplayed={3}
                pageCount={pages} // Use pages as pageCount
                onPageChange={changePage}
                containerClassName={"pagination"}
                pageLinkClassName={"page-num"}
                previousLinkClassName={"page-num"}
                nextLinkClassName={"page-num"}
                activeLinkClassName={"active"}
                disabledLinkClassName={"pagination-link is-disabled"}
              />
            </nav>
          </div>
        </div>
      </div>
      <hr className='student-bar' />
    </div>


  )
}

export default UserComplaints




