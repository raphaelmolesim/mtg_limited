import React, { useEffect } from "react";
import MasterPage from "./MasterPage";
import SetList from "./SetList";
import Card from "./Card";

const Classifier = () => {
  const [set, setSet] = React.useState(null);
  const [card, setCard] = React.useState(null);
  const [ratingSeriesId, setRatingSeriesId] = React.useState(null);

  const setListVisibility = set === null ? "block" : "hidden";
  const setCardVisibility = set === null ? "hidden" : "block";

  const nextCard = () => {
    fetch(`/api/sets/${set}/cards/sample`)
      .then((response) => response.json())
      .then((data) => {
        console.log("card", data);
        setCard(data);
      });
  };

  const createRatingSeries = (set) => {
    console.log("createRatingSeries");
    fetch(`/api/rating_series`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        set: set
      }),
    }).then((response) => response.text())
      .then((ratingSeriesId) => {
        console.log("ratingSeriesId", ratingSeriesId);
        setRatingSeriesId(ratingSeriesId);
      });
  };

  useEffect(() => {
    if (set && ratingSeriesId === null)
      createRatingSeries(set);
  }, [set]);

  useEffect(() => {
    if (ratingSeriesId) 
      nextCard();
  }, [ratingSeriesId]);

  return (
    <MasterPage>
      <div className={setListVisibility}>
        <h1 className="text-4xl font-bold text-center pt-8">Choose a set:</h1>
        <SetList setSelectorFunction={setSet} />
      </div>

      <div className={setCardVisibility}>
        <Card card={card} nextCardFunction={nextCard} ratingSeriesId={ratingSeriesId} />
      </div>
    </MasterPage>
  );
};
export default Classifier;
