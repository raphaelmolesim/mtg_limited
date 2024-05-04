import React, { useEffect } from "react";
import MasterPage from "./MasterPage";
import SetList from "./SetList";
import Card from "./Card";

const Classifier = () => {
  const [set, setSet] = React.useState(null);
  const [card, setCard] = React.useState(null);

  const setListVisibily = set === null ? "block" : "hidden";
  const setCardVisibility = set === null ? "hidden" : "block";

  const nextCard = () => {
    fetch(`/api/sets/${set}/cards/sample`)
      .then((response) => response.json())
      .then((data) => {
        console.log("card", data);
        setCard(data);
      });
  };

  useEffect(() => {
    if (set) {
      nextCard();
    }
  }, [set]);

  return (
    <MasterPage>
      <div className={setListVisibily}>
        <h1 className="text-4xl font-bold text-center pt-8">Choose a set:</h1>
        <SetList setSelectorFunction={setSet} />
      </div>

      <div className={setCardVisibility}>
        <Card card={card} nextCardFunction={nextCard}/>
      </div>
    </MasterPage>
  );
};
export default Classifier;
