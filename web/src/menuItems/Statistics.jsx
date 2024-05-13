import React, { useContext, useEffect, useState } from 'react'
import '../styles/Admin.css'
import { useRecoilState } from 'recoil'
import axios from 'axios'
import { ToastContainer, toast } from 'react-toastify'
import { Link, Route, Routes, useNavigate, useParams } from 'react-router-dom'
import Counter from '../components/Counter.jsx'
import { AuthContext } from '../context/authContext.js'
import { Line } from "react-chartjs-2";
import 'chart.js/auto';
import Chart from "chart.js/auto";
import { CategoryScale } from 'chart.js/auto';
import Cookies from 'js-cookie'
import Footer from '../components/Footer.jsx'

Chart.register(CategoryScale);





const Statistics = () => {
  const navigate = useNavigate()
  const { currentUser } = useContext(AuthContext)
  const [visits, setVisits] = useState(0)
  const [numberOfUsers, setNumberOfUsers] = useState(0)
  const [numberOfContracts, setNumberOfContracts] = useState(0)
  const [numberOfOffers, setNumberOfOffers] = useState(0)
  const [numberOfApplications, setNumberOfApplications] = useState(0)
  const [numberOfProperties, setNumberOfProperties] = useState(0)

  const [lastTenYears, setLastTenYears] = useState([])
  const [currentYear, setCurrentYear] = useState(new Date(Date.now()).getFullYear())
  const [numberOfPropertiesPerTime, setNumberOfPropertiesPerTime] = useState([])
  const [numberOfUsersPerTime, setNumberOfUsersPerTime] = useState([])



  const [properties_time, setProperties_time] = useState([])
  const [users_time, setUsers_time] = useState([])


  const getCookie = (cookieName) => {
    const cookieValue = Cookies.get(cookieName);
    return cookieValue;
  }

  const handleResetVisits = async () => {
    // Swal.fire({
    //   title: 'Are you sure you want to reset the number of visits?',
    //   showCancelButton: true,
    //   confirmButtonColor: '#00BF63',
    //   confirmButtonText: 'Reset',
    //   customClass: 'Custom_btn'
    // }).then(async (result) => {
    //   if (result.isConfirmed) {
    //     try {
    //       const res = await axios.delete("http://localhost:3007/api/auth/visits");
    //       if (res.status === 200) {
    //         Swal.fire('Success!', 'Number of visits has been reset.', 'success');
    //         // Optionally, you can update the UI to reflect the new state
    //         setVisits(0); // Assuming you have a state variable for visits
    //       } else {
    //         Swal.fire('Error', 'An error occurred while resetting visits.', 'error');
    //       }
    //     } catch (err) {
    //       if (err.message === 'Network Error' && !err.response) {
    //         toast.error('Network error - make sure the server is running!', {
    //           position: 'top-center',
    //           autoClose: 10000,
    //           hideProgressBar: false,
    //           closeOnClick: true,
    //           pauseOnHover: true,
    //           draggable: true,
    //           progress: undefined,
    //           theme: 'colored',
    //         });
    //       } else if (err.response && err.response.status === 401) {
    //         navigate('/login');
    //       } else {
    //         Swal.fire('Error', 'An error occurred while resetting visits.', 'error');
    //       }
    //       console.error(err);
    //     }
    //   } else if (result.isDenied) {
    //     Swal.fire('Cancelled', 'Changes are not saved', 'info');
    //   }
    // });
  };


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
    const getVisits = async () => {
      try {
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/visits-number`);
        setVisits(res.data)
        console.log(res.data);
      } catch (err) {
        if (err && err.message == 'Network Error' && !err.response)
          toast.error('Network error - make sure server is running!', {
            position: "top-center",
            autoClose: 10000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "colored",
          });
        if (err) {
          console.log(err)
        }
        console.log(err)
      }
    }

    const getNumberOfProperties = async () => {
      try {
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/properties/number`);
        setNumberOfProperties(res.data)
        console.log(res);
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
            theme: "colored",
          });
        if (err.response.status == 401) {
          navigate('/login')
        }
        console.log(err)
      }
    }


    const getNumberOfUsers = async () => {
      try {
        const result = await axios.get(`${process.env.REACT_APP_BASE_URL}/users/number`);
        setNumberOfUsers(result.data)
        console.log(result);
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
            theme: "colored",
          });
        if (err.response.status == 401) {
          navigate('/login')
        }
        console.log(err)
      }
    }


    const getNumberOfContracts = async () => {
      try {
        const result = await axios.get(`${process.env.REACT_APP_BASE_URL}/contracts/number`);
        setNumberOfContracts(result.data)
        console.log(result);
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
            theme: "colored",
          });
        if (err.response.status == 401) {
          navigate('/login')
        }
        console.log(err)
      }
    }

    const getNumberOfOffers = async () => {
      try {
        const result = await axios.get(`${process.env.REACT_APP_BASE_URL}/offers/number`);
        setNumberOfOffers(result.data)
        console.log(result);
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
            theme: "colored",
          });
        if (err.response.status == 401) {
          navigate('/login')
        }
        console.log(err)
      }
    }


    const getNumberOfApplications = async () => {
      try {
        const result = await axios.get(`${process.env.REACT_APP_BASE_URL}/applications/number`);
        setNumberOfApplications(result.data)
        console.log(result);
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
            theme: "colored",
          });
        if (err.response.status == 401) {
          navigate('/login')
        }
        console.log(err)
      }
    }

    const getLastTenYears = async () => {

      let list = Array(10);
      let j = 0;
      for (let i = 9; i >= 0; i--) {
        list[j] = (currentYear - i).toString();
        j++;
      }
      console.log(currentYear);

      console.log(list);

      setLastTenYears(list)
    }


    const getNumberOfPropertiesPerTime = async () => {
      try {
        const result = await axios.get(`${process.env.REACT_APP_BASE_URL}/properties/property-numbers-in-last-ten-year`);
        setNumberOfPropertiesPerTime(result.data)
        console.log(result);
        await getLastTenYears()
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
            theme: "colored",
          });
        if (err.response.status == 401) {
          navigate('/login')
        }
        console.log(err)
      }
    }


    const getNumberOfUsersPerTime = async () => {
      try {
        const result = await axios.get(`${process.env.REACT_APP_BASE_URL}/users/users-numbers-in-last-ten-year`);
        setNumberOfUsersPerTime(result.data)
        console.log(result);
        await getLastTenYears()
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
            theme: "colored",
          });
        if (err.response.status == 401) {
          navigate('/login')
        }
        console.log(err)
      }
    }

    //// fetchData()
    getNumberOfUsersPerTime()
    getVisits()
    getNumberOfProperties()
    getNumberOfUsers()
    getNumberOfContracts()
    getNumberOfOffers()
    getNumberOfApplications()
    getNumberOfPropertiesPerTime()
  }, []);
  // useEffect(() => {
  //   // Scroll to the top of the page when the component mounts

  //   setTimeout(function () {
  //     window.scrollTo(0, 0);
  // },2);
  // }, []);

  const propertiesData = {
    labels: lastTenYears,
    datasets: [
      {
        label: "First dataset",
        data: numberOfPropertiesPerTime,
        fill: true,
        backgroundColor: "rgba(75,192,192,0.2)",
        borderColor: "rgba(75,192,192,1)",
        borderWidth: 2, // Adjust this value to change the line width
      },
    ],
  };


  const usersData = {
    labels: lastTenYears,
    datasets: [
      {
        label: "First dataset",
        data: numberOfUsersPerTime,
        fill: true,
        backgroundColor: "rgba(75,192,192,0.2)",
        borderColor: "rgba(75,192,192,1)",
        borderWidth: 2, // Adjust this value to change the line width
      },
    ],
  };

  return (
    <>
      <div style={{ height: "50px" }}></div>
      {/* <div style={{ height: "10px" }}></div>
      <div style={{ height: "10px" }}></div>
      <div style={{ height: "10px" }}></div> */}

      <div className="row" id='statistics'>
        <div className="col-md-3">
          <div className="l-number">Number of users</div>
          <div className="number"><Counter target={numberOfUsers && numberOfUsers} /></div>
        </div>
        <div className="col-md-3" id='create-number'>
          <div className="l-number">Number of properties</div>
          <div className="number"><Counter target={numberOfProperties && numberOfProperties} /></div>
        </div>

        <div className="col-md-3" id='create-number'>
          <div className="l-number">Number of contracts</div>
          <div className="number"><Counter target={numberOfContracts && numberOfContracts} /></div>
        </div>
      </div>

      <div style={{ height: "10px" }}></div>


      <div className="row" id='statistics'>
        <div className="col-md-3">
          <div className="l-number">Number of offers</div>
          <div className="number"><Counter target={numberOfOffers && numberOfOffers} /></div>
        </div>

        <div className="col-md-3">
          <div className="l-number">Number of visits</div>
          <div className="number"><Counter target={visits && visits} /></div>
          <div className="reset">
            <button onClick={handleResetVisits} id='reset-visits' required autoComplete='off'>Reset number of visits</button>
          </div>
        </div>

        <div className="col-md-3">
          <div className="l-number">Number of applications</div>
          <div className="number"><Counter target={numberOfApplications && numberOfApplications} /></div>
        </div>

      </div>


      <hr style={{ width: "1500px", display: "flex", justifyContent: "center", alignItems: "center", marginLeft: "140px" }} />

      <div style={{ paddingRight: "0px" }}>
        <div className="l-search" style={{ margin: "40px" }}>Properties / Time</div>
        <div className="items" style={{ height: "400px" }}>
          <Line aria-setsize={{}} data={propertiesData} />
        </div>
        <div className="l-search" style={{ margin: "40px" }}>Users / Time</div>
        <div className="items" style={{ height: "400px" }}>
          <Line aria-setsize={{}} data={usersData}  />
        </div>
        <Footer/>
      </div>
    </>


  )
}

export default Statistics



{/* <div style={{ paddingRight: "120px" }}>
            <div className="row">
              <div className="l-search">Search about student</div>
            </div>
            <div className="items">

              <div className="container" id='row-items'>
                <div className="row" id='search-bar-up'>
                  <SearchBar admin={true} />
                </div>
                <div className="row" id='search-bar-below'>

                  <div className="col-md-6" id='filter-bar-container'>
                    <FilterBar placeholder='Select student language' options={languageOptions} filterType="language" />
                  </div>
                </div>
              </div>

            </div>
          </div> */}



{/* <UserList /> */ }
{/* <hr className='student-bar' /> */ }
{/* <Footer /> */ }