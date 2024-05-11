import React from "react";
import ReactDOM from "react-dom";
import { MenuOutlined, TagOutlined, FundViewOutlined } from "@ant-design/icons";
import Classifier from "./Classifier";
import MyData from "./MyData";

const MasterPage = ({ children, className }) => {
  const [menuState, setMenuState] = React.useState(false);

  const toogleMenu = () => {
    setMenuState(!menuState);
  };

  const launchClassifier = () => {
    ReactDOM.render(<Classifier />, document.getElementById("app"));
  };

  const launchMyData = () => {
    ReactDOM.render(<MyData />, document.getElementById("app"));
  }


  const menuVisibility = (state) => (state ? "block" : "hidden");
  return (
    <>
      <div className="flex flex-row bg-gray-900 p-4">
        <MenuOutlined
          style={{ fontSize: 32, marginRight: 20, color: "#f1f5f9" }}
          onClick={toogleMenu}
        />
        <div className="logo text-slate-100">MTG Limited</div>
      </div>
      <div className="flex flex-row">
        <div
          className={`${menuVisibility(
            menuState
          )} bg-gray-900 text-slate-100 h-screen w-[190px] absolute top-[67px] z-10`}
        >
          <ul>
            <li className="py-4 pl-4">
              <a onClick={launchClassifier}>
                <TagOutlined
                  style={{ fontSize: 20, marginRight: 8, color: "#f1f5f9" }}
                />
                Classifier game
              </a>
            </li>
            <li className="py-4 pl-4">
              <a onClick={launchMyData}>
                <FundViewOutlined
                  style={{ fontSize: 20, marginRight: 8, color: "#f1f5f9" }}
                />
                My data
              </a>
            </li>
          </ul>
        </div>
        <div className={`content flex-1 bg-white h-screen ${className}`}>
          {children}
        </div>
      </div>
    </>
  );
};
export default MasterPage;
