import React, { useEffect } from "react";
import MasterPage from "./MasterPage";

const MyData = () => {
  const [ratingSeries, setRatingSeries] = React.useState([]);

  useEffect(() => {
    console.log("MyData mounted");
    fetch("/api/rating_series")
      .then((response) => response.json())
      .then((data) => setRatingSeries(data));
  }, [])
  
  const renderStatus = (status) => {
    const cssColor = status === "open" ? "bg-stone-500" : "bg-cyan-700";
    return (
      <span className={`text-xs rounded-lg	text-center ${cssColor} px-2 w-[170px] text-slate-100 font-bold pb-[2px]`}>
        {status}
      </span>
    );
  };

  const renderRatingSeries = (ratingSeries) => {
    const ratingSeriesGroupBySet = ratingSeries.reduce((acc, series) => {
      const set = "otj"
      if (!acc[set]) {
        acc[set] = [];
      }
      acc[set].push(series);
      return acc;
    }, {});
    return Object.keys(ratingSeriesGroupBySet).map(function(set) {
      const ratingSeriesList = ratingSeriesGroupBySet[set];
      const ul = <ul key={set}>
        </ul>
      return (<ul>
        <li className="pt-8 text-base font-bold">Outlaws of the Thunder Junction Block</li>
        <ul>
          {ratingSeriesList.map((series, idx) => {
            const ratings = series.series
            const percentage = (ratings.filter((rating) => rating.conclusion == "true").length / ratings.length) * 100.0;
            const performance = percentage.toFixed(0);
            return (
              <li key={series.id} className="pl-4 flex flex-rom">
                <div className="grow">
                  Series {(idx + 1)}
                </div>
                <div className="grow">
                  {renderStatus(series.status)}
                </div>
                <div className="shrink">
                  {performance}%
                </div> 
              </li>
            );
          })}
        </ul>
      </ul>);
    });
  };

  return (
    <MasterPage>
      <div className="p-4">
        <h1 className="text-4xl font-bold">My Data</h1>
        <ul>
          {renderRatingSeries(ratingSeries)}
        </ul>
      </div>
    </MasterPage>
  );
};
export default MyData;
