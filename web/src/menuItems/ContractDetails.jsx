import React, { useContext, useEffect, useState } from 'react'
import { MDBFooter, MDBContainer, MDBRow, MDBCol, MDBIcon } from 'mdb-react-ui-kit';
import '../styles/FileItem.css'
import { faFileAlt, faSpinner, faCalendarDays, faBuilding, faHandshake, faCity, faTrash, faX } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { Link, Outlet, useLocation, useNavigate, useParams } from 'react-router-dom'
import '@fortawesome/fontawesome-free/css/all.min.css';
import 'bootstrap-css-only/css/bootstrap.min.css';
import 'mdbreact/dist/css/mdb.css';
import '../styles/Post.css'
import { AuthContext } from '../context/authContext';
import axios from 'axios';
import { useRecoilState } from 'recoil';
import { PostDetails, isCreatingPost, searchedDContracts, studentPosts } from '../state';
import { ToastContainer, toast } from 'react-toastify';
import profile_pic from '../assets/user-pic.png';
import DatePicker from 'react-date-picker';
import 'react-date-picker/dist/DatePicker.css';
import 'react-calendar/dist/Calendar.css';
import Swal from 'sweetalert2'
import ProgressBar from "@ramonak/react-progress-bar";
import { faFire } from '@fortawesome/free-solid-svg-icons'
import { Step, Stepper } from 'react-form-stepper';
import { StepperNav } from "vertical-stepper-nav";

// type ValuePiece = Date | null;

// type Value = ValuePiece | [ValuePiece, ValuePiece];
const ContractDetails = () => {
  const params = useParams();
  // const paymentPercentage = 
  const [contracts, setContracts] = useRecoilState(searchedDContracts);
  const [contractData, setContractData] = useState()

  useEffect(() => {
    console.log(contracts);
    console.log(params.id);
    setContractData(prevContractData => {
      const updatedContractData = contracts.find(contract => contract.id === Number(params.id));
      console.log(updatedContractData);
      return updatedContractData;
    });
  }, [params.id]);











  return (
    <div style={{
      display: "flex",
      justifyContent: "center",
      flexDirection: "column",
      marginLeft: "150px",
      borderRadius: "8px",
      minWidth: "250px",
      maxWidth: "1000px"
    }}>
      <div
        className="row"
        style={{
          display: "flex",
          justifyContent: "space-between",
          backgroundColor: "black",
          marginLeft: "0px",
          color: "white",
          borderRadius: "8px",
          minWidth: "250px",
          maxWidth: "1000px"
        }}
        id="post-up"
      >


        <div className="col-2">
          <div className="row">
            <div className="col">
              <FontAwesomeIcon icon={faHandshake}
                style={{ fontSize: "40px", marginRight: "5px" }} />
            </div>
            <div style={{ justifyItems: "center", paddingTop: "10px" }} className="col">
              {contractData && contractData.offer.offerDate ? contractData.offer.offerDate.substring(0, 10) : null}
            </div>
          </div>
        </div>
        <div className="col-3" style={{ fontSize: "30px", fontWeight: "700", margin: "10px" }}>Contract details</div>

      </div>
      <div className="container" id='post'>

        <div className="row" style={{ fontSize: "20px", fontWeight: "700", marginBottom: "5px", marginTop: "5px", marginLeft: "0px" }} id='post-up'>
          Overview
        </div>
        <hr style={{ marginTop: "0px" }} />
        <div className="post-down">
          <div>
            <div className="row">
              <div className="col-6" >
                <span style={{ fontWeight: "600" }}>* Landlord: </span>
                <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{contractData && contractData.offer.landlord.name}</span>
                {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
              </div>
              <div className="col-6" >
                <span style={{ fontWeight: "600" }}>* Contract type: </span>
                <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{contractData && contractData.contractType}</span>
                {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
              </div>
            </div>
            <div className="row mt-2">
              <div className="col-6" >
                <span style={{ fontWeight: "600" }}>* Customer: </span>
                <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{contractData && contractData.offer.customer.name}</span>
                {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
              </div>
              <div className="col-6" >
                <span style={{ fontWeight: "600" }}>* {contractData && contractData.listingType == "For rent" ? "Monthly rent: " : "Price: "} </span>
                <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>${contractData && contractData.offer.price}</span>
                {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
              </div>
            </div>
            <div className="row mt-2 mb-4">
              <div className="col-6" >
                <span style={{ fontWeight: "600" }}>* Property code: </span>
                <Link to={`/properties/${contractData && contractData.offer.property.propertyCode}`} style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{contractData && contractData.offer.property.propertyCode}</Link>
                {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
              </div>
              <div className="col-6" >
                <span style={{ fontWeight: "600" }}>* Contract status: </span>
                <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{contractData && contractData.contractStatus}</span>
                {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
              </div>
            </div>

          </div>
        </div>
      </div>

      <div className="container" id='post'>
        <div className="row" style={{ fontSize: "20px", fontWeight: "700", marginBottom: "5px", marginTop: "5px", marginLeft: "0px" }} id='post-up'>
          Earnings
        </div>
        <hr style={{ marginTop: "0px" }} />

        <div className="post-down">
          <div>
            <div className="row">
              <ProgressBar
                completed={
                  // contractData &&
                  // contractData.offer &&
                  // contractData.offer.price &&
                  // (Number(contractData.earnings) / Number(contractData.offer.price))
                  35
                }
              />
            </div>

            <div className="row mt-4 mb-4">
              <div className="col-4" >
                <span style={{ fontWeight: "600" }}>* Total price: </span>
                <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>${contractData && contractData.offer.price}</span>
                {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
              </div>
              <div className="col-4" >
                <span style={{ fontWeight: "600" }}>* Earnings: </span>
                <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>${contractData && contractData.earnings}</span>
                {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
              </div>
              <div className="col-4" >
                <span style={{ fontWeight: "600" }}>* Is should pay </span>
                <span style={{ color: "#C4271B", fontWeight: "700", fontSize: "15px" }}>{contractData && contractData.isShouldPay ? "Yes" : "No"}</span>
                {/* <span style={{ fontWeight: "800" }}>  |  </span> */}
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="container" id='post'>
        <div className="row" style={{ fontSize: "20px", fontWeight: "700", marginBottom: "5px", marginTop: "5px", marginLeft: "0px" }} id='post-up'>
          Milestones
        </div>
        <hr style={{ marginTop: "0px" }} />

        <div className="post-down">
          <div>
            <div style={{ marginLeft: 20 }}>
              {contractData && contractData.milestones ? (
                <StepperNav
                  steps={contractData.milestones.map((milestone) => {
                    return {
                      stepContent: () => 
                      <div style={{ fontSize: 18 }}>
                        <div style={{marginLeft: "30px", fontWeight: "600"}} className="row">
                          {milestone.milestoneName}
                        </div>  
                        <div style={{marginLeft: "30px"}} className="row">
                         {milestone.description}
                        </div>
                        <div style={{marginLeft: "30px", color: "#C4271B", fontWeight: "600"}} className="row mt-2">
                          <div className="col-2" >${milestone.amount}</div>
                          <div  style={{borderColor: "black", borderWidth: "0.2px", border: "solid", borderRadius: "8px", width: "100px", textAlign: "center"}}> {milestone.milestoneStatus}</div>
                        </div>
                      </div>,
                      stepStatusCircleSize: 25,
                      stepStateColor: "#C4271B",
                    };
                  })}
                />
              ) : (
                <p>No milestones available.</p>
              )}
            </div>

            <div className="row mt-4 mb-4">

            </div>
          </div>
        </div>
      </div>
    </div>

  )
}

export default ContractDetails