import React, { useEffect } from "react";
import PrimaryButton from "./Base";
import { setInputSelection } from "rc-mentions/lib/util";

const SetList = ({ setSelectorFunction }) => {
  const [sets, setSets] = React.useState([]);

  useEffect(() => {
    fetch("/api/sets")
      .then((response) => response.json())
      .then((data) => {
        setSets(data);
      });
  }, []);

  const selectSet = (setCode) => {
    setSelectorFunction(setCode);
  };

  const setIcon = (code) => {
    fetch("/api/sets/otj/icon")
      .then((response) => {
        return response.text()
      }).then((svg) => {
        const el = document.getElementById(`icon-${code}`);
        el.innerHTML = svg;
        el.querySelector("svg").classList.add("w-12", "h-12")
        el.querySelector("path").classList.add("fill-slate-100");
      });
  }

  const renderSets = (sets) => {
    return sets.map((set) => {
      return (
        <li
          key={set.code}
          className="py-12 flex flex-row justify-center items-center"
        >
          <PrimaryButton onClick={() => selectSet(set.code)} className="flex flex-row items-center text-xl font-bold py-16 px-[26px] w-[80%] text-wrap">
            <div className="mr-4" id={`icon-${set.code}`}>
              {setIcon(set.code)}
            </div>
            {set.name}
          </PrimaryButton>
        </li>
      );
    });
  };

  return <ul>{renderSets(sets)}</ul>;
};

export default SetList;
