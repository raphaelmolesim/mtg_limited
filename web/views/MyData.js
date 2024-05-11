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
    return status;
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
          {ratingSeriesList.map((series) => {
            const ratings = series.series
            console.log(ratings, ratings.filter((rating) => rating.conclusion == "true").length,  ratings.length);
            const performance = (ratings.filter((rating) => rating.conclusion == "true").length / ratings.length) * 100.0;
            return (
              <li key={series.id} className="pl-8 flex flex-rom">
                <div className="grow">
                  Performance:
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
        <h1 className="text-4xl font-bold pt-4">My Data</h1>
        <ul>
          {renderRatingSeries(ratingSeries)}
        </ul>
      </div>
    </MasterPage>
  );
};
export default MyData;
