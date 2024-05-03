import React from 'react';
import ReactDOM from 'react-dom';
import App from './app';
import Classifier from './classifier';

const Homepage = () => (
  <div className="App">
    <Classifier />
  </div>
);

ReactDOM.render(<Homepage />, document.getElementById('app'));