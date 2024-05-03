import React, { useEffect } from "react";
import MasterPage from "./MasterPage";
import SetList from "./SetList"; 

const Classifier = () => {  
  const [set, setSet] = React.useState(null);

  const setListVisibily = set === null ? "block" : "hidden";

  return (
    <MasterPage>
      <div className={setListVisibily} >
        <h1 className="text-4xl font-bold text-center pt-8">Choose a set:</h1>
        <SetList setSelectorFunction={setSet} />        
      </div>

    </MasterPage>
  );
};
export default Classifier;
