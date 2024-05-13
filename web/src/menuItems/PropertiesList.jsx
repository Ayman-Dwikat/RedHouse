"use client"
import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import ReactPaginate from "react-paginate";
// import Post from "./Post";
import '../styles/PostList.css'
import { categoryFilterQuery, isLoading, keywordQuery, languageFilterQuery, searchedProperties, studentPosts } from "../state";
import { useRecoilState } from "recoil";
import { ToastContainer, toast } from 'react-toastify'
import { useNavigate, useParams } from "react-router-dom";
import ClipLoader from "react-spinners/ClipLoader";
import Backdrop from '@material-ui/core/Backdrop';
import CircularProgress from '@material-ui/core/CircularProgress';

import { makeStyles } from '@material-ui/core/styles';
import Complaint from "./Complaint";
import Property from "./Property";
import SearchBar from "../components/SearchBar/SearchBar";

import Map, { NavigationControl, Marker } from 'react-map-gl';
import maplibregl from 'maplibre-gl';
import 'maplibre-gl/dist/maplibre-gl.css';

const useStyles = makeStyles((theme) => ({
  backdrop: {
    zIndex: theme.zIndex.drawer + 1,
    color: '#fff',
  },
}));


const PropertiesList = () => {

  const containerStyle = {
    width: '600px',
    height: '800px'
  };

  const center = {
    lat: -3.745,
    lng: -38.523
  };
  // const { isLoaded } = useState(true)
  // const onLoad = React.useCallback(function callback(map) {
  //   // This is just an example of getting and using the map instance!!! don't just blindly copy!
  //   const bounds = new window.google.maps.LatLngBounds(center);
  //   map.fitBounds(bounds);

  //   setMap(map)
  // }, [])

  // const onUnmount = React.useCallback(function callback(map) {
  //   setMap(null)
  // }, [])
  // const [map, setMap] = React.useState(null)


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
  const position = { lat: 53, lang: 10 }
  const [properties, setProperties] = useRecoilState(searchedProperties);


  // const params = useParams();
  // useEffect(() => {
  //   setIsLoadingHome(false)
  // }, [page]);

  useEffect(() => {
    setCategoryFilter("");
    setLanguageFilter("");
    setKeyword("");
    getProperties();
  }, [])



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


  useEffect(() => {
    getProperties();
  }, [keyword, page])



  const getProperties = async () => {
    try {
      setProperties([]);

      const response = await axios.get(`${process.env.REACT_APP_BASE_URL}/properties/filter?searchQuery=${keyword}&page=${page}&limit=${limit}`);
      setProperties(response.data.listDto);
      console.log(response.data.listDto);
      console.log(response.data.pagination.pageNumber);
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

  return (
    <>
      <div style={{ paddingRight: "0px" }}>
        <div className="row">
          <div className="l-search">Search about properties</div>
        </div>
        <div className="items">

          <div className="container" id='row-items'>
            <div className="row" id='search-bar-up'>
              <SearchBar searchHint="Search about properties by location" />
            </div>

          </div>

        </div>
        <div className="container" style={{ width: "90%", height: "calc(100vh - 250px)", zIndex: "100", display: "flex" }}>
          <Map
            mapLib={maplibregl}
            initialViewState={{
              longitude: 35.2137,
              latitude: 31.7683,
              zoom: 8
            }}
            mapStyle="https://api.maptiler.com/maps/streets/style.json?key=edydkbpOGIMm1fvtdvS4"
          >
            <NavigationControl position="top-left" />
            {properties.map((property) => (
              <Marker
                key={property.id}  // Don't forget to add a unique key for each Marker
                latitude={property.location.latitude}
                longitude={property.location.longitude}
                color="red"
              />
            ))}
          </Map>
        </div>

      </div>



      <div style={{ paddingRight: "0px" }}>

        <div className="items">

          <div className="container" id='row-items'>
            <div className="row" id='search-bar-up'>
              <SearchBar searchHint="Search about properties by Id" />
            </div>

          </div>

        </div>
      </div>
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
        <div  style={{ marginTop: "50px", marginLeft: "20px" }}>
          {properties.length !== 0 ? (
            properties.map((property) => <Property key={property.id} propertyData={property} />)
          ) : (
            <h1 className="posts-found">      No Properties Found</h1>
          )}
          {/* Total Posts: {rows} Page: {page} of {pages} */}
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

export default (PropertiesList);
