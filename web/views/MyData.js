import React, { useEffect } from "react";
import MasterPage from "./MasterPage";
import { EyeOutlined } from "@ant-design/icons";
import { Modal } from "antd";

const MyData = () => {
  const [ratingSeries, setRatingSeries] = React.useState([]);
  const [image, setImage] = React.useState(null);

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
    // TODO: Replace the hard coded set with a dynamic set
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
        <li className="pt-2 pl-2 text-base">Outlaws of the Thunder Junction Block</li>
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

  const renderTopMisses = (ratingSeries) => {
    // TODO: Group result by set
    const ratingsGroupedByCards = ratingSeries.reduce((acc, series) => {
      const ratings = series.series;
      ratings.forEach((rating) => {
        const cardId = rating.card_id;
        console.log(rating, cardId);
        if (!acc[cardId]) {
          acc[cardId] = [];
        }
        acc[cardId].push(rating);
      });
      return acc;
    }, {});
    
    console.log(ratingsGroupedByCards);

    const topMisses = Object.keys(ratingsGroupedByCards).map((cardId) => {
      const ratings = ratingsGroupedByCards[cardId];
      const misses = ratings.filter((rating) => rating.conclusion === "false");
      return {
        cardId: cardId,
        card_name: ratings[0].card.name,
        card_image: ratings[0].card.image_uris.normal,
        misses: misses.length,
      };
    });

    topMisses.sort((a, b) => b.misses - a.misses);
    return topMisses.slice(0, 9).map((topMiss) => {
      return (
        <li key={topMiss.cardId} className="pl-2 flex flex-row">
          <div className="shrink pr-2">
            <EyeOutlined onClick={() => setImage({
              url: topMiss.card_image,
              name: topMiss.card_name,
            })} />
          </div>
          <div className="grow">
            {topMiss.card_name}
          </div>
          <div className="shrink">
            {topMiss.misses} Misses
          </div>
        </li>
      );
    });
  };

  return (
    <MasterPage>

      <Modal
        open={image !== null}
        onOk={() => setImage(null)}
        okText="Close"
        cancelButtonProps={{ style: { display: 'none' } }}
      >
        <img src={image ? image.url : "#"} alt="Card" />
      </Modal>    

      <div className="p-4">        
        <h1 className="text-4xl font-bold">My Data</h1>

        <h2 className="pt-4 font-bold">Overall Performance</h2>
        <ul>
          {renderRatingSeries(ratingSeries)}
        </ul>

        <h2 className="pt-4 font-bold">Top Misses</h2>
        <ul>
          {renderTopMisses(ratingSeries)}
        </ul>

      </div>
    </MasterPage>
  );
};
export default MyData;
