import React from "react";
import ReactDOM from "react-dom";
import App from "./App";
import Classifier from "./Classifier";

const Homepage = () => (
  <div className="App">
    <Classifier />
  </div>
);

ReactDOM.render(<Homepage />, document.getElementById("app"));
