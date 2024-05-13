import { initializeApp } from "firebase/app";
import { getStorage } from "firebase/storage";
import { getAnalytics } from "firebase/analytics";


// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBb2gJmrFJuxKgN7WCBmSzc5KytbHjVGiI",
  authDomain: "tuulio-website.firebaseapp.com",
  projectId: "tuulio-website",
  storageBucket: "tuulio-website.appspot.com",
  messagingSenderId: "309803816050",
  appId: "1:309803816050:web:53448f1526efc91298deeb",
  measurementId: "G-JR86MM786Y"
};



// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const storage = getStorage(app);

const analytics = getAnalytics(app);



