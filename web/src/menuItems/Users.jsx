import React, { useContext, useEffect, useState } from 'react'
import '../styles/Student.css'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faPlay } from '@fortawesome/free-solid-svg-icons'
import { Link, Outlet, useNavigate, useParams } from 'react-router-dom'
import { useRecoilState } from 'recoil'
import { isCreatingPost, viewingPostDetails } from '../state'
import axios from 'axios'
import { AuthContext } from '../context/authContext'
import { ToastContainer, toast } from 'react-toastify'
import Cookie from 'js-cookie'
import FilterBar from '../components/SearchBar/FilterBar'
import SearchBar from '../components/SearchBar/SearchBar'

import "bootstrap/dist/css/bootstrap.min.css";
import ReactPaginate from "react-paginate";
import '../styles/UserList.css'
import { categoryFilterQuery, keywordQuery, languageFilterQuery, usersRows } from "../state";
import UsersTable from "../components/Users/UsersTable";
import ClipLoader from "react-spinners/ClipLoader";

const Users = () => {
  const [page, setPage] = useState(1); // Start page from 1
  const [limit, setLimit] = useState(10);
  const [pages, setPages] = useState(0);
  const [rows, setRows] = useState(0);
  const [keyword, setKeyword] = useRecoilState(keywordQuery);
  const [languageFilter, setLanguageFilter] = useRecoilState(languageFilterQuery);
  const [users, setUsers] = useRecoilState(usersRows);
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

  useEffect(() => {
    getUsers();
  }, [page, keyword, languageFilter]);
  useEffect(() => {
    setLanguageFilter("")
    setKeyword("")
  }, []);
  const getUsers = async () => {
    try {
      setUsers([]);
      setLoading(true);

      const response = await axios.get(`${process.env.REACT_APP_BASE_URL}/users?searchQuery=${keyword}&page=${page}&limit=${limit}`);
      setUsers(response.data.listDto);
      console.log(response.data);
      setPage(response.data.pagination.pageNumber);
      setPages(response.data.pagination.totalPages);
      setRows(response.data.pagination.totalRows);
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
    console.log(users);
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

  // useEffect(() => {
  //   // Scroll to the top of the page when the component mounts

  //   setTimeout(function () {
  //     window.scrollTo(0, 0);
  // },2);
  // }, []);

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
    fetchStudent()
    setIsCreatingLocal(false)
    setIsViewingPostDetailsLocal(false)
  }, [params]);


  useEffect(() => {
    setIsViewingPostDetails(isViewingPostDetailsLocal)
  }, [isViewingPostDetailsLocal])

  useEffect(() => {
    setIsCreating(isCreatingLocal)
  }, [isCreatingLocal])

  const languageOptions = [
    { value: '', label: '' },
    { value: 'Newest', label: 'Newest' },
    { value: 'Oldest', label: 'Oldest' },
  ];

  return (
    <div className='container' id='student-container' style={{ marginTop: "50px" }}>
      <div style={{ paddingRight: "120px" }}>
        <div className="row">
          <div className="l-search">Search about users</div>
        </div>
        <div className="items">

          <div className="container" id='row-items'>
            <div className="row" id='search-bar-up'>
              <SearchBar searchHint="Search about users" />
            </div>
            {/* <div className="row" id='search-bar-below'>

              <div className="col-md-6" id='filter-bar-container'>
                <FilterBar placeholder='Filter result sort' options={languageOptions} filterType="language" />
              </div>
            </div> */}
          </div>

        </div>
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
              (<UsersTable />)}
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

export default Users




