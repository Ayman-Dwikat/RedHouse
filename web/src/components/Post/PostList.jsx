import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import ReactPaginate from "react-paginate";
import Post from "./Post";
import '../../styles/PostList.css'
import { categoryFilterQuery, isLoading, keywordQuery, languageFilterQuery, studentPosts } from "../../state";
import { useRecoilState } from "recoil";
import { ToastContainer, toast } from 'react-toastify'
import { useNavigate } from "react-router-dom";
import ClipLoader from "react-spinners/ClipLoader";
import Backdrop from '@material-ui/core/Backdrop';
import CircularProgress from '@material-ui/core/CircularProgress';

import { makeStyles } from '@material-ui/core/styles';
const useStyles = makeStyles((theme) => ({
  backdrop: {
    zIndex: theme.zIndex.drawer + 1,
    color: '#fff',
  },
}));

const PostList = () => {
  const classes = useStyles();
  const [posts, setPosts] = useRecoilState(studentPosts);
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

  useEffect(() => {
    setIsLoadingHome(false)
    getPosts();
  }, [page, keyword, languageFilter, categoryFilter, isLoadingHome]);

  useEffect(() => {
    setCategoryFilter("");
    setLanguageFilter("");
    setKeyword("");
  }, []);

  const getPosts = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${process.env.REACT_APP_BASE_URL}/posts?searchQuery=${keyword}&languageFilter=${languageFilter}&categoryFilter=${categoryFilter}&page=${page}&limit=${limit}`);
      setPosts([...response.data.data]);
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
        <div className="post-list">
          {posts.length !== 0 ? (
            posts.map((post) => <Post key={post.id} postData={post} />)
          ) : (
            <h1 className="posts-found">No Posts Found</h1>
          )}
          Total Posts: {rows} Page: {page} of {pages}
        </div>
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

export default PostList;
