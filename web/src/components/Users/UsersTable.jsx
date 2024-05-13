import * as React from 'react';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import '../../styles/UserList.css';
import '../../styles/UserTable.css';
import profile_pic from '../../assets/user-pic.png';
import axios from 'axios';
import { ToastContainer, toast } from 'react-toastify';
import { useNavigate } from 'react-router-dom';
import Swal from 'sweetalert2';
import { selectedUser, usersRows } from '../../state';
import { useRecoilState } from 'recoil';
import { Link } from 'react-router-dom'
import ClipLoader from "react-spinners/ClipLoader";

function UsersTable() {
  // const [rows, setUsers] = React.useState(rows);
  const [users, setUsers] = useRecoilState(usersRows);
  const [clickedRows, setClickedRows] = React.useState([]);

  const navigate = useNavigate();

  const [_selectedUser, setSelectedUser] = useRecoilState(selectedUser)


  React.useEffect(() => {
    const usersWhoPassed = users.filter((user) => user.isPass === '1');
    const userIDsWhoPassed = usersWhoPassed.map((user) => user.id);
    setClickedRows(userIDsWhoPassed);
  }, []);


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
          const updatedUsers = users.filter(post => post.id !== userId)
          setUsers(updatedUsers)
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
    const updatedUsers = users.map((user) =>
      user.id === row.id ? { ...user, isPass: newIsPass } : user
    );

    // Update the state with the modified users array
    setUsers(updatedUsers);

    // Call passUser function to update the backend if needed
    passUser(newIsPass, row.id);
  }


  return (
    <>
      {users == null ? (
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
          <Table sx={{ minWidth: 650 }} aria-label="simple table">
            <TableHead>
              <TableRow>
                <TableCell>Picture</TableCell>
                <TableCell align="left">Name</TableCell>
                <TableCell align="left">Email</TableCell>
                <TableCell align="left">UserRole</TableCell>
                <TableCell align="left">Postal code</TableCell>
                <TableCell align="left">Delete</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {users ?
                users.map((user) => (
                  <TableRow 
                    key={user && user.id}
                    sx={{
                      '&:last-child td, &:last-child th': { border: 0 },
                    }}
                  >

                    <TableCell component="th" scope="row">
                      <img
                        src={profile_pic}
                        alt="Profile pic"
                        className="profile-pic"
                      ></img>
                    </TableCell>

                    <Link to={`/users/${user && btoa(user.id)}`}  >
                      <TableCell id='username-link' align="left">{user && user.name}</TableCell>
                    </Link>
                    <TableCell align="left">{user && user.email}</TableCell>
                    <TableCell align="left">
                      {
                          user && user.userRole
                          
                      }
                    </TableCell>
                    <TableCell align="left">
                      {
                          user && user.location.postalCode
                          
                      }
                    </TableCell>

                    <TableCell onClick={() => deleteUser(user.id)} align="left">
                      <button className="delete-btn">Delete</button>
                    </TableCell>
                  </TableRow>
                ))
                :
                <h3 style={{ textAlign: "center" }}>No data found!</h3>
              }
            </TableBody>
          </Table>
        </TableContainer>)}</>
  );
}

export default UsersTable;
