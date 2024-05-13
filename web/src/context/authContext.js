import axios from "axios";
import { createContext, useEffect, useState } from "react";
import Swal from 'sweetalert2'



export const AuthContext = createContext()

export const AuthContextProvider = ({children}) => {
    const [currentUser, setCurrentUser] = useState(
        JSON.parse(localStorage.getItem("user")) || null)


    const logout = async(flag)=>{
        await axios.post(`${process.env.REACT_APP_BASE_URL}/auth/logout`);
        Swal.fire({
            position: 'center',
            icon: flag ? "info" : 'success',
            confirmButtonColor: '#00BF63',
            title: flag ? 'Your session has expired, please login' : 'Logged out successfully',
            showConfirmButton: false,
            timer: 1500
          })
        setCurrentUser(null)
    }  


    

    useEffect(()=>{
        localStorage.setItem("user", JSON.stringify(currentUser))
    }, [currentUser])

    return (
          <AuthContext.Provider value={{ currentUser, setCurrentUser, logout }}>
            {children}
          </AuthContext.Provider>
        
    )
    
}