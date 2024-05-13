import React, { useContext, useEffect, useState } from 'react'
import people from '../assets/Group.png'
import '../styles/Home.css'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faPlay } from '@fortawesome/free-solid-svg-icons'
import { faHandshakeAngle } from '@fortawesome/free-solid-svg-icons'
import Post from './Post/Post.jsx'
import { Link, useNavigate } from 'react-router-dom'
import SearchBar from './SearchBar/SearchBar'
import FilterBar from './SearchBar/FilterBar'
import SearchResultsListPost from './SearchBar/SearchResultsListPost'
import SearchResultsList from './SearchBar/SearchResultsList'
import axios from 'axios'
import { AuthContext } from '../context/authContext'
import PostList from './Post/PostList'
import { useRecoilState } from 'recoil'
import countapi from 'countapi-js';
import { ToastContainer, toast } from 'react-toastify'
import { isLoading } from '../state'
import Cookies from 'js-cookie'

const Home = () => {
  const [count, setCount] = useState(0);
  const navigate = useNavigate()
  const [results, setResult] = useState([])
  const { currentUser, logout } = useContext(AuthContext)
  const [isLoadingHome, setIsLoadingHome] = useRecoilState(isLoading);
  const getCookie = (cookieName) => {
    const cookieValue = Cookies.get(cookieName);
    return cookieValue;
  }
  useEffect(() => {
    // Scroll to the top of the page when the component mounts
    window.scrollTo(0, 0);
  }, []);
  useEffect(() => {
    const fetchData = async () => {
      try {
        // Get the access token from a cookie named "access_token_tuulio"
        const currentCookie = getCookie("access_token_tuulio");

        // Check if the access token is available
        if (!currentCookie && !currentUser) {
          // Handle the case where the access token is missing or undefined
          console.log("Access token is missing.");
          return;
        }

        // Make an authenticated request using the access token
        const res = await axios.get(`${process.env.REACT_APP_BASE_URL}/verifyUser/${currentCookie}`);

        // Process the response data if needed

        // Example: Log the response data
        console.log("Response data:", res.data);
      } catch (err) {
        if (err.message === 'Network Error' && !err.response) {
          // Handle network error
          toast.error('Network error - make sure the server is running!', {
            position: "top-center",
            autoClose: 10000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "dark",
          });
        } else if (err.response && err.response.status === 401) {
          // Handle unauthorized access (status code 401)
          if (currentUser) {
            console.log("Unauthorized access - redirecting to login.");
            logout(true)
            navigate('/login');
          }
        } else {
          // Handle other errors
          console.error("An error occurred:", err);
        }
      }
    };

    const incrementVisits = async () => {
      try {
        const res = await axios.post(`${process.env.REACT_APP_BASE_URL}/auth/visits`);
        console.log("authentication procces")
      } catch (err) {
        if (err.message == 'Network Error' && !err.response)
          toast.error('Network error - make sure server is running!', {
            position: "top-center",
            autoClose: 10000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "colored",
          });
        if (err.response && err.response.status == 401) {
          navigate('/login')
        }
        else {
          console.log(err);
        }
      }
    }
    fetchData()
    setIsLoadingHome(true)
    incrementVisits()
  }, []);

  const languageOptions = [
    { value: '', label: '' },
    { value: 'Afrikaans', label: 'Afrikaans' },
    { value: 'Albanian', label: 'Albanian - shqip' },
    { value: 'Amharic', label: 'Amharic - አማርኛ' },
    { value: 'Arabic', label: 'Arabic - العربية' },
    { value: 'Aragonese', label: 'Aragonese - aragonés' },
    { value: 'Armenian', label: 'Armenian - հայերեն' },
    { value: 'Asturian', label: 'Asturian - asturianu' },
    { value: 'Azerbaijani', label: 'Azerbaijani - azərbaycan dili' },
    { value: 'Basque', label: 'Basque - euskara' },
    { value: 'Belarusian', label: 'Belarusian - беларуская' },
    { value: 'Bengali', label: 'Bengali - বাংলা' },
    { value: 'Bosnian', label: 'Bosnian - bosanski' },
    { value: 'Breton', label: 'Breton - brezhoneg' },
    { value: 'Bulgarian', label: 'Bulgarian - български' },
    { value: 'Catalan', label: 'Catalan - català' },
    { value: 'Central Kurdish', label: 'Central Kurdish - کوردی (دەستنوسی عەرەبی)' },
    { value: 'Chinese', label: 'Chinese - 中文' },
    { value: 'Corsican', label: 'Corsican' },
    { value: 'Croatian', label: 'Croatian - hrvatski' },
    { value: 'Czech', label: 'Czech - čeština' },
    { value: 'Danish', label: 'Danish - dansk' },
    { value: 'Dutch', label: 'Dutch - Nederlands' },
    { value: 'English', label: 'English' },
    { value: 'English', label: 'English (United Kingdom)' },
    { value: 'English', label: 'English (United States)' },
    { value: 'Esperanto', label: 'Esperanto - esperanto' },
    { value: 'Estonian', label: 'Estonian - eesti' },
    { value: 'Faroese', label: 'Faroese - føroyskt' },
    { value: 'Filipino', label: 'Filipino' },
    { value: 'Finnish', label: 'Finnish - suomi' },
    { value: 'French', label: 'French - français' },
    { value: 'French', label: 'French - français (France)' },
    { value: 'Galician', label: 'Galician - galego' },
    { value: 'Georgian', label: 'Georgian - ქართული' },
    { value: 'German', label: 'German - Deutsch (Deutschland)' },
    { value: 'Greek', label: 'Greek - Ελληνικά' },
    { value: 'Guarani', label: 'Guarani' },
    { value: 'Gujarati', label: 'Gujarati - ગુજરાતી' },
    { value: 'Hausa', label: 'Hausa' },
    { value: 'Hawaiian', label: 'Hawaiian - ʻŌlelo Hawaiʻi' },
    { value: 'Hebrew', label: 'Hebrew - עברית' },
    { value: 'Hindi', label: 'Hindi - हिन्दी' },
    { value: 'Hungarian', label: 'Hungarian - magyar' },
    { value: 'Icelandic', label: 'Icelandic - íslenska' },
    { value: 'Indonesian', label: 'Indonesian - Indonesia' },
    { value: 'Interlingua', label: 'Interlingua' },
    { value: 'Irish', label: 'Irish - Gaeilge' },
    { value: 'Italian', label: 'Italian - italiano (Svizzera)' },
    { value: 'Japanese', label: 'Japanese - 日本語' },
    { value: 'Kannada', label: 'Kannada - ಕನ್ನಡ' },
    { value: 'Kazakh', label: 'Kazakh - қазақ тілі' },
    { value: 'Khmer', label: 'Khmer - ខ្មែរ' },
    { value: 'Korean', label: 'Korean - 한국어' },
    { value: 'Kurdish', label: 'Kurdish - Kurdî' },
    { value: 'Kyrgyz', label: 'Kyrgyz - кыргызча' },
    { value: 'Lao', label: 'Lao - ລາວ' },
    { value: 'Latin', label: 'Latin' },
    { value: 'Latvian', label: 'Latvian - latviešu' },
    { value: 'Lingala', label: 'Lingala - lingála' },
    { value: 'Lithuanian', label: 'Lithuanian - lietuvių' },
    { value: 'Macedonian', label: 'Macedonian - македонски' },
    { value: 'Malay', label: 'Malay - Bahasa Melayu' },
    { value: 'Malayalam', label: 'Malayalam - മലയാളം' },
    { value: 'Maltese', label: 'Maltese - Malti' },
    { value: 'Marathi', label: 'Marathi - मराठी' },
    { value: 'Mongolian', label: 'Mongolian - монгол' },
    { value: 'Nepali', label: 'Nepali - नेपाली' },
    { value: 'Norwegian', label: 'Norwegian Nynorsk - nynorsk' },
    { value: 'Occitan', label: 'Occitan' },
    { value: 'Oriya', label: 'Oriya - ଓଡ଼ିଆ' },
    { value: 'Oromo', label: 'Oromo - Oromoo' },
    { value: 'Pashto', label: 'Pashto - پښتو' },
    { value: 'Persian', label: 'Persian - فارسی' },
    { value: 'Polish', label: 'Polish - polski' },
    { value: 'Portuguese', label: 'Portuguese - português' },
    { value: 'Portuguese', label: 'Portuguese - português (Brasil)' },
    { value: 'Punjabi', label: 'Punjabi - ਪੰਜਾਬੀ' },
    { value: 'Quechua', label: 'Quechua' },
    { value: 'Romansh', label: 'Romansh - rumantsch' },
    { value: 'Russian', label: 'Russian - русский' },
    { value: 'Scottish Gaelic', label: 'Scottish Gaelic' },
    { value: 'Serbian', label: 'Serbian - српски' },
    { value: 'Serbo-Croatian', label: 'Serbo-Croatian - Srpskohrvatski' },
    { value: 'Shona', label: 'Shona - chiShona' },
    { value: 'Sindhi', label: 'Sindhi' },
    { value: 'Sinhala', label: 'Sinhala - සිංහල' },
    { value: 'Slovak', label: 'Slovak - slovenčina' },
    { value: 'Slovenian', label: 'Slovenian - slovenščina' },
    { value: 'Somali', label: 'Somali - Soomaali' },
    { value: 'Southern Sotho', label: 'Southern Sotho' },
    { value: 'Spanish', label: 'Spanish - español' },
    { value: 'Spanish', label: 'Spanish - español (España)' },
    { value: 'Sundanese', label: 'Sundanese' },
    { value: 'Swahili', label: 'Swahili - Kiswahili' },
    { value: 'Swedish', label: 'Swedish - svenska' },
    { value: 'Tajik', label: 'Tajik - тоҷикӣ' },
    { value: 'Tamil', label: 'Tamil - தமிழ்' },
    { value: 'Tatar', label: 'Tatar' },
    { value: 'Telugu', label: 'Telugu - తెలుగు' },
    { value: 'Thai', label: 'Thai - ไทย' },
    { value: 'Tigrinya', label: 'Tigrinya - ትግርኛ' },
    { value: 'Tongan', label: 'Tongan - lea fakatonga' },
    { value: 'Turkish', label: 'Turkish - Türkçe' },
    { value: 'Turkmen', label: 'Turkmen' },
    { value: 'Twi', label: 'Twi' },
    { value: 'Ukrainian', label: 'Ukrainian - українська' },
    { value: 'Urdu', label: 'Urdu - اردو' },
    { value: 'Uyghur', label: 'Uyghur' },
    { value: 'Uzbek', label: 'Uzbek - o‘zbek' },
    { value: 'Vietnamese', label: 'Vietnamese - Tiếng Việt' },
    { value: 'Walloon', label: 'Walloon - wa' },
    { value: 'Welsh', label: 'Welsh - Cymraeg' },
    { value: 'Western Frisian', label: 'Western Frisian' },
    { value: 'Xhosa', label: 'Xhosa' },
    { value: 'Yiddish', label: 'Yiddish' },
    { value: 'Yoruba', label: 'Yoruba - Èdè Yorùbá' },
    { value: 'Zulu', label: 'Zulu - isiZulu' },
  ];
  const categoryOptions = [
    { value: '', label: '' },
    , { value: "Practice Sheets", label: "Practice Sheets" }
    , { value: "Written Texts", label: "Written Texts" }
    , { value: "Grammar Practice", label: "Grammar Practice" }
    , { value: "Visuals/Images", label: "Visuals/Images" }
    , { value: "Parts of Speech", label: "Parts of Speech" },
    { value: "Presentations", label: "Presentations" }
    , { value: "Infographics", label: "Infographics" }
    , { value: "Verbs", label: "Verbs" }
    , { value: "Adjectives", label: "Adjectives" }
    , { value: "Nouns", label: "Nouns" }
  ];

  return (
    <>
      <section className="hero">
        <div className='container' id='hero-container'>
          <ToastContainer />
          <div className="row" id='custom-row'>
            <div className="col-md-6" id='left'>
              <div>
                <h1 className='bit-title'>Free online tutoring with student like you</h1>
              </div>
              <p className='text'>
                Here at Tuulio, we believe that the best type of tutoring can come from other students, and with collaboration and teamwork, learning a new language can be simplified!
              </p>
              {
                !currentUser && <div className="buttons">
                  <a href="#start" className="btn-started">
                    <FontAwesomeIcon icon={faPlay} className='play' />
                    Get started</a>
                  <Link to="register" className="btn-volunteer">
                    <FontAwesomeIcon icon={faHandshakeAngle} className='play' />
                    Volunteer</Link>
                </div>
              }
            </div>
            <div className="col-md-6" id='right'>
              <img src={people} id='people-img'></img>
            </div>
          </div>
        </div>
        <hr></hr>

      </section>

      <section className="setup" id='start'>
        <div className="container" id='left-right-setup'>
          <div className="row">
            <h3 className="text-header text-center" id='select-header'>
              Select a suitable filter to display the desired results
            </h3>
            <div className="items">

              <div className="container" id='row-items'>
                <div className="row" id='search-bar-up'>
                  <SearchBar admin={false} />
                </div>
                <div className="row" id='search-bar-below'>

                  <div className="col-md-6" id='filter-bar-container'>
                    <FilterBar placeholder='Select post language' options={languageOptions} filterType="language" />
                  </div>
                  <div className="col-md-6" id='filter-bar-container'>
                    <FilterBar placeholder='Select post category' options={categoryOptions} filterType="category" />
                  </div>
                </div>
              </div>


            </div>
            <div className="row" id='left-setup'>
              <PostList />
            </div>

          </div>

        </div>

      </section>
    </>

  )
}

export default Home

