import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import { AuthContextProvider } from './context/authContext';
import { RecoilRoot } from 'recoil';

const root = document.getElementById('root');

// Set the title here
document.title = 'Tuulio';

ReactDOM.render(
  <AuthContextProvider>
    <RecoilRoot>
      <App />
    </RecoilRoot>
  </AuthContextProvider>,
  root
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
