import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import ReactPaginate from "react-paginate";
// import Post from "./Post";
import '../styles/PostList.css'
import { categoryFilterQuery, isLoading, keywordQuery, languageFilterQuery, studentPosts } from "../state";
import { useRecoilState } from "recoil";
import { ToastContainer, toast } from 'react-toastify'
import { useNavigate, useParams } from "react-router-dom";
import ClipLoader from "react-spinners/ClipLoader";
import Backdrop from '@material-ui/core/Backdrop';
import CircularProgress from '@material-ui/core/CircularProgress';

import { makeStyles } from '@material-ui/core/styles';
import Complaint from "./Complaint";
const useStyles = makeStyles((theme) => ({
  backdrop: {
    zIndex: theme.zIndex.drawer + 1,
    color: '#fff',
  },
}));

const ComplaintsList = () => {
  const classes = useStyles();
  const [complaints, setComplaints] = useState([]);
  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(6);
  const [pages, setPages] = useState(0);
  const [rows, setRows] = useState(0);
  const [keyword, setKeyword] = useRecoilState(keywordQuery);
  const [languageFilter, setLanguageFilter] = useRecoilState(languageFilterQuery);
  const [categoryFilter, setCategoryFilter] = useRecoilState(categoryFilterQuery);
  const [isLoadingHome, setIsLoadingHome] = useRecoilState(isLoading);
  const [loading, setLoading] = useState(false);
  const [msg, setMsg] = useState("");
  const navigate = useNavigate();

  const  params  = useParams();
  useEffect(() => {
    setIsLoadingHome(false)
    getPosts();
  }, [page]);

  useEffect(() => {
    setCategoryFilter("");
    setLanguageFilter("");
    setKeyword("");
}, [params])

  const getPosts = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${process.env.REACT_APP_BASE_URL}/complaints/for-day?day=${atob(params.id)}`);
      setComplaints(response.data.value.listDto);
      setPage(response.data.pagination.page);
      setPages(response.data.pagination.totalPage);
      setRows(response.data.pagination.totalRows);
    } catch (err) {
      handleApiError(err);
    } finally {
      setLoading(false); // Set loading to false when the request is completed (success or error)
    }
  };

  const handleApiError = (err) => {
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
  };

  const changePage = ({ selected }) => {
    setPage(selected + 1);
    if (selected === 9) {
      setMsg(".........");
    } else {
      setMsg("");
    }
  };

  return (
    <>
        <div style={{fontSize: "22px", marginLeft: "370px", marginTop: "30px", fontWeight: "700"}}>Complaints for {atob(params.id).substring(0, 10)}</div>
      <ToastContainer />
      {loading ? ( // Display the spinner conditionally based on the loading state
        <div style={{ marginBottom: '20px', display: 'flex', justifyContent: 'center' }}>
          <ClipLoader
            color={"#00BF63"}
            loading={true}
            size={40}
            aria-label="Loading Spinner"
            data-testid="loader"
          />
        </div>


      ) : (
        <div className="post-list" style={{marginTop: "50px"}}>
          {complaints.length !== 0 ? (
            complaints.map((post) => <Complaint key={post.id} complaintData={post} />)
          ) : (
            <h1 className="posts-found">No Posts Found</h1>
          )}        </div>
      )}
      <p className="text-danger">{msg}</p>
      <nav className="d-flex justify-content-center">
        <ReactPaginate
          breakLabel="..."
          previousLabel={"Prev"}
          nextLabel={"Next"}
          pageRangeDisplayed={3}
          pageCount={pages}
          onPageChange={changePage}
          containerClassName={"pagination"}
          pageLinkClassName={"page-num"}
          previousLinkClassName={"page-num"}
          nextLinkClassName={"page-num"}
          activeLinkClassName={"active"}
          disabledLinkClassName={"pagination-link is-disabled"}
        />
      </nav>
    </>
  );
};

export default ComplaintsList;
