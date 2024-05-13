import './App.css';
import React, { useEffect } from 'react'
// import Register from "../Registration/Register.jsx";
import Login from "./pages/Login.jsx";
import Footer from "./components/Footer.jsx";
import Home from "./components/Home";
import Navbar from "./components/Navbar/Navbar.jsx";

// Bootstrap CSS
import "bootstrap/dist/css/bootstrap.min.css";
// Bootstrap Bundle JS
import "bootstrap/dist/js/bootstrap.bundle.min";
import './styles/Home.css'

import {
  createBrowserRouter,
  createRoutesFromElements,
  Outlet,
  Route,
  RouterProvider,
} from "react-router-dom";
import Student from './components/Student';
import Admin from './pages/Admin';
import AboutUs from './components/AboutUs';
import CreatePost from './components/Post/CreatePost';
import PostDetails from './components/Post/PostDetails';
import Posts from './components/Post/Posts';
import ResetPassword from './components/ResetPassword/ResetPassword';
import ForgotPassword from './components/ResetPassword/ForgetPassword';
import RegisterAdmin from './components/Registration/RegisterAdmin';
import AccountVerification from './pages/AccountVerification';
import Register from './components/Registration/Register';
import AccountConfirmation from './pages/AccountConfirmation';
import Properties from './menuItems/Properities.jsx';
import Statistics from './menuItems/Statistics.jsx';
import Contracts from './menuItems/Contracts.jsx';
import Offers from './menuItems/Offers.jsx';
import Users from './menuItems/Users.jsx';
import Agents from './menuItems/Agents.jsx';
import Applications from './menuItems/Applications.jsx';
import UserComplaints from './menuItems/UserComplaints.jsx';
import ComplaintsList from './menuItems/ComplaintsList.jsx';
import PersonalVerificationRequests from './menuItems/PersonalVerificationRequests.jsx';
import Contract from './menuItems/Contract.jsx';
import ContractDetails from './menuItems/ContractDetails.jsx';
import ContractsList from './menuItems/ContractsList.jsx';
import PropertiesList from './menuItems/PropertiesList.jsx';
import PropertyDetails from './menuItems/PropertyDetails.jsx';
import User from './menuItems/User.jsx';
<style>
  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@200;300;600;700;800;900&family=Work+Sans:ital,wght@0,200;0,800;1,100;1,600&display=swap');
</style>


const Layout = () => {
  return (
    <>
      <Navbar />
      <Outlet />
      <Footer />
    </>
  );
};

const router = createBrowserRouter(
  createRoutesFromElements(
    <Route path="/" >
      <Route path="/register" element={<Register />} />
      <Route path="/register-admin" element={<RegisterAdmin />} />
      <Route path="/login" element={<Login />} />
      <Route path="/verification/:id/:token" element={<AccountVerification />} />
      <Route path="/account-confirmation" element={<AccountConfirmation />} />
      <Route path="/forgot-password" element={<ForgotPassword />}></Route>
      <Route path="/reset_password/:id/:token" element={<ResetPassword />}></Route>

      {/* <Route path="/student/:id" element={<Student />} >
            <Route path="posts/:id" element={<PostDetails />} />
        <Route/>
        <Route path="login" element={<Login />} />
      </Route> */}

      <Route path="/" element={<Layout />}>
        <Route element={<Admin />} >
          <Route path="/" element={<Statistics />} />
          <Route path="/users" element={<Users />} />
          <Route path="/users/:id" element={<User />} />
            <Route path="/properties" element={<PropertiesList />} />
            <Route path="/properties/:propertyCode" element={<PropertyDetails />} />
          <Route path="/contracts" element={<Contracts />} >
            <Route path="" element={<ContractsList />} />
            <Route path=":id" element={<ContractDetails />} />
          </Route>
          <Route path="/offers" element={<Offers />} />
          <Route path="/applications" element={<Applications />} />
          <Route path="/agents" element={<Agents />} />
          <Route path="/user-complains" element={<UserComplaints />} />
          <Route path="/complaints-list/:id" element={<ComplaintsList />} />
          <Route path="/verification-requests" element={<PersonalVerificationRequests />} />
        </Route>

        {/* <Route path="posts/:id" element={<PostDetails />} />
        <Route path="/students/:id" element={<Student />} >
          <Route path="posts/:id" element={<PostDetails />} />
          <Route path="" element={<Posts />} />
          <Route path="create-post" element={<CreatePost />} />
          <Route />
        </Route>
        <Route path="about-us" element={<AboutUs />} /> */}
      </Route>
    </Route>
  )
)



function App() {
  useEffect(() => {
    document.title = "RedHouse"
  })

  return (
    <div className="big-wrapper">
      <RouterProvider router={router} />
    </div>
  );
}

export default App;