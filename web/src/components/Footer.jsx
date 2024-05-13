import React from 'react'
import { MDBFooter, MDBContainer, MDBRow, MDBCol, MDBIcon } from 'mdb-react-ui-kit';
import '@fortawesome/fontawesome-free/css/all.min.css';
import 'bootstrap-css-only/css/bootstrap.min.css';
import 'mdbreact/dist/css/mdb.css';
import '../styles/Footer.css'
const Footer = () => {
  return (
    <>
      <MDBFooter Color='' className='text-center text-lg-start text-white mt-5' id='footer-'>

          <div className='text-center p-4 d-flex justify-content-center justify-content-lg-between p-4 border-bottom' style={{ backgroundColor: 'rgba(0, 0, 0, 0.05)' }}>
            <div className='social-icons'>
              <a href='#' className='me-4 text-reset'>
              <MDBIcon color='white' fab icon='facebook-f' />
              </a>
              <a href='#' className='me-4 text-reset'>
                <MDBIcon color='white' fab icon='twitter' />
              </a>
              <a href='#' className='me-4 text-reset'>
                <MDBIcon color='white' fab icon='google' />
              </a>
              
            </div>
          </div>
          <MDBContainer className='text-center text-md-start mt-5'>
            <MDBRow className='mt-3'>
              <MDBCol md='3' lg='4' xl='3' className='mx-auto mb-4'>
                <h6 className='text-uppercase fw-bold mb-4'>
                  <MDBIcon color='white' icon='gem' className='me-3' />
                  RedHouse
                </h6>
                <p>
                Got any questions or support issues? Reach out to us at our email tuulio.contact@gmail.com
                </p>
              </MDBCol>

              <MDBCol md='4' lg='3' xl='3' className='mx-auto mb-md-0 mb-4'>
                <h6 className='text-uppercase fw-bold mb-4'>Contact</h6>

                <p>
                  <MDBIcon color='white' icon='envelope' className='me-3' />
                  tuulio.contact@gmail.com
                </p>
               
              </MDBCol>
              <MDBCol md='4' lg='3' xl='3' className='mx-auto mb-md-0 mb-4'>
              <h6 className='text-uppercase fw-bold mb-4'>POLICIES</h6>

              <p>
                <a href='https://firebasestorage.googleapis.com/v0/b/tuulio-website.appspot.com/o/TuulioPrivacyPolicy.pdf?alt=media&token=b0c038e6-a017-4702-99b6-6bd04b69b568' target='_blank' className='text-reset'>
                  Privacy policy
                </a>
                <span> and </span>
                <a href='https://firebasestorage.googleapis.com/v0/b/tuulio-website.appspot.com/o/TuulioTermsAndConditions.pdf?alt=media&token=11e10f89-24ca-4a66-bac1-cc20a5447abd' target='_blank' className='text-reset'>
                  terms of condition
                </a>
              </p>

            </MDBCol>
              <MDBCol md='3' lg='2' xl='2' className='mx-auto mb-4'>
                <h6 className='text-uppercase fw-bold mb-4'>Useful links</h6>

                <p>
                  <a href='#!' className='text-reset'>
                    Help
                  </a>
                </p>
              </MDBCol>

            </MDBRow>
          </MDBContainer>
      </MDBFooter>
    </>
  )
}

export default Footer;