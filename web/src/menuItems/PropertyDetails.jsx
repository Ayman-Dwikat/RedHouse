import React, { useContext, useEffect, useState } from 'react'
import { MDBFooter, MDBContainer, MDBRow, MDBCol, MDBIcon } from 'mdb-react-ui-kit';
import '../styles/FileItem.css'
import { faFileAlt, faSpinner, faHouseCircleExclamation, faCalendarDays, faBuilding, faHandshake, faCity, faTrash, faX } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { Link, Outlet, useLocation, useNavigate, useParams } from 'react-router-dom'
import '@fortawesome/fontawesome-free/css/all.min.css';
import 'bootstrap-css-only/css/bootstrap.min.css';
import 'mdbreact/dist/css/mdb.css';
import '../styles/Post.css'
import { AuthContext } from '../context/authContext';
import axios from 'axios';
import { useRecoilState } from 'recoil';
import { PostDetails, isCreatingPost, searchedDContracts, searchedProperties, studentPosts } from '../state';
import { ToastContainer, toast } from 'react-toastify';
import profile_pic from '../assets/user-pic.png';
import DatePicker from 'react-date-picker';
import 'react-date-picker/dist/DatePicker.css';
import 'react-calendar/dist/Calendar.css';
import Swal from 'sweetalert2'



import Map, { NavigationControl, Marker } from 'react-map-gl';
import maplibregl from 'maplibre-gl';
import 'maplibre-gl/dist/maplibre-gl.css';

import { faFire } from '@fortawesome/free-solid-svg-icons'

// type ValuePiece = Date | null;

// type Value = ValuePiece | [ValuePiece, ValuePiece];
const PropertyDetails = () => {
  const params = useParams();

  const [properties, setProperties] = useRecoilState(searchedProperties);
  const [propertyData, setPropertyData] = useState()

  useEffect(() => {
    console.log(properties);
    console.log(params.id);
    setPropertyData(prevContractData => {
      const updatedContractData = properties.find(property => property.propertyCode == (params.propertyCode));
      console.log(updatedContractData);
      return updatedContractData;
    });
  }, [params.id]);




  return (
    <div className="container" id='post' style={{marginTop: "80px"}}>
      <ToastContainer />
      <div className="row" id='post-up'>
        <div className="col-md-8">
          <FontAwesomeIcon icon={faBuilding} style={{ fontSize: "28px" }} />
          <span style={{ fontWeight: "700", fontSize: "15px" }}> {propertyData && propertyData.user.name}</span>
          <span className="created date-name-group">{propertyData && propertyData.listingDate ? propertyData.listingDate.substring(0, 10) : null} </span>
        </div>
        <div className="col-md-4" id='delete-lang-post'>

          <span id='delete-post'>
            <FontAwesomeIcon icon={faTrash}
            />
          </span>


        </div>
      </div>


      <div className="post-down">
        <div>
          <div className="row">
            <div className="col-4" >
              <span><FontAwesomeIcon icon={faCity} /></span>
              <span style={{ fontWeight: "600" }}> City: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.location.city}</span>
            </div>
            <div className="col-4" >
              <span><FontAwesomeIcon icon={faHouseCircleExclamation} /> </span>
              <span style={{ fontWeight: "600" }}>Property type: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.propertyType}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span><FontAwesomeIcon icon={faCalendarDays} /> </span>
              <span style={{ fontWeight: "600" }}>Building date: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.builtYear.substring(0, 10)}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
          </div>          <hr style={{ marginTop: "20px" }} />

          <div className="row">
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Listing type: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.listingType}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>{propertyData && propertyData.listingType == "For rent" ? "Monthly rent: " : "Price: "} </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.price}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Property code: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.propertyCode}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
          </div>
          <hr style={{ marginTop: "20px" }} />
          <div className="row">
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Number of bedrooms: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.numberOfBedRooms}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Number of bathrooms: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.numberOfBathRooms}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Square meters area: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.squareMetersArea} m2</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
          </div>
          <hr style={{ marginTop: "20px" }} />
          <div className="row">
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Address: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.location.streetAddress}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Property view: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.view}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Parking spots: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.parkingSpots} </span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
          </div>
          <hr style={{ marginTop: "20px" }} />
          <div className="row">
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Listing By: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.listingBy}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Property status: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.propertyStatus}</span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
            <div className="col-4" >
              <span style={{ fontWeight: "600" }}>Available on: </span>
              <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.availableOn} </span>
              {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
            </div>
          </div>
          <hr style={{ marginTop: "20px" }} />
          <div className="row">
            <span style={{ fontWeight: "600" }}>Description: </span>
            <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{propertyData && propertyData.propertyDescription}</span>
            {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
          </div>
          <hr style={{ marginTop: "20px" }} />
          <span style={{ fontWeight: "600", marginLeft: "2px" }}>Location: </span>
          <div className="row" style={{ width: "98%", height: "calc(100vh - 450px)", zIndex: "100", display: "flex", marginTop: "5px", marginLeft: "4px" }}>

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
              <Marker
                key={propertyData && propertyData.id}  // Don't forget to add a unique key for each Marker
                latitude={propertyData && propertyData.location.latitude}
                longitude={propertyData && propertyData.location.longitude}
                color="red"
              />

            </Map>
          </div>
          <hr style={{ marginTop: "20px" }} />
          <div>
            {propertyData &&
              propertyData.propertyFiles.map((img) => (
                <img
                  key={img.id}
                  style={{ width: '950px', marginTop: '20px' }}
                  src={img.downloadUrls}
                  alt=""
                />
              ))}
          </div>
        </div>
      </div>
    </div >
  )
}

export default PropertyDetails