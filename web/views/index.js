import React from 'react';
import ReactDOM from 'react-dom';
import App from './app';

const Homepage = () => (
  <div className="App">
    <App />
  </div>
);

ReactDOM.render(<Homepage />, document.getElementById('app'));