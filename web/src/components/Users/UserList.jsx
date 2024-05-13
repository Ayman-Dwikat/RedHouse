import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import ReactPaginate from "react-paginate";
import '../../styles/UserList.css'
import { categoryFilterQuery, keywordQuery, languageFilterQuery, usersRows } from "../../state";
import { useRecoilState } from "recoil";
import { ToastContainer, toast } from 'react-toastify'
import { useNavigate } from "react-router-dom";
import UsersTable from "./UsersTable";
import ClipLoader from "react-spinners/ClipLoader";

const PostList = () => {
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
      setUsers(response.data.data);
      console.log(response);
      // setPage(response.data.pagination.page);
      // setPages(response.data.pagination.totalPage);
      // setRows(response.data.pagination.totalRows);
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
    }finally {
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

  return (
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
  );
};

export default PostList;
