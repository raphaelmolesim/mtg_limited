import React, { useEffect } from "react";
import PrimaryButton from "./Base";
import { Modal } from "antd";
import Image from "./Image";
import ProgressSeries from "./ProgressSeries";

const Card = ({ card, nextCardFunction, ratingSeriesId, createRatingSeriesFunction, set }) => {
  const [isCorrect, setIsCorrect] = React.useState(null);
  const [lastRating, setLastRating] = React.useState(null);
  const [renewSeries, setRenewSeries] = React.useState(false);
  const [isLoading, setIsLoading] = React.useState(false);
  const imageStyle = "absolute top-0 left-0 w-full h-[190px] object-cover rounded-lg"
  const incorrectImage = <Image src="swat-crop.jpg" className={`${imageStyle} object-top`} /> 
  const correctImage = <Image src="true-believer.png" className={`${imageStyle} object-center`} /> 
  const answerText =
    isCorrect === true ? "Nice! You got it!!!" : "Ops, not that...";
  const textColor = isCorrect === true ? "text-emerald-600" : "text-red-600";
  const answerImage = isCorrect === true ? correctImage : incorrectImage;
  const openModal = isCorrect === null ? false : true;
  const nextAndViewCardButtonsVisibility = lastRating != null ? "block" : 'hidden';
  const ratingButtonsVisibility = lastRating != null ? 'hidden' : "block";

  const ratingMap = {
    bomb: [4.5, 5],
    impactful: [3.5, 4.0],
    filler_a: [2.5, 3.0],
    filler_b: [1.5, 2.0],
    trap: [1.0, 0.5, 0],
  }

  const reverseRatingMap = Object.keys(ratingMap).reduce((acc, key) => {
    const ratings = ratingMap[key];
    ratings.forEach(rating => {
      acc[rating.toString()] = key;
    });
    return acc;
  }, {});

  const selectRating = async (rating) => {
    setIsLoading(true);
    if (lastRating === null) {
      const data = await createRating(ratingSeriesId, card["id"], rating, card["set"]);
    }
    setLastRating(rating)
    const ratings = ratingMap[rating];

    if (ratings.includes(card["rating"])) {
      setIsCorrect(true);
    } else {
      setIsCorrect(false);
    }
    setIsLoading(false);
  };

  const createRating = async (seriesId, cardId, rating, set) => {
    let response = await fetch(`/api/rating_series/${seriesId}/ratings`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        card_id: cardId,
        rating: rating,
        set: set
      }),
    });
    let data = await response.json();
    if (data["renew_series"])
      setRenewSeries(true);
    return data;
  };

  const nextCard = () => {
    setIsCorrect(null);
    setLastRating(null);
    if (renewSeries) {
      createRatingSeriesFunction(set);
    } else {
      nextCardFunction();
    }
  };

  const toHuman = (input) => input.split('_').map(s => s.charAt(0).toUpperCase() + s.slice(1)).join(' ');

  const viewCard = () => {
    setIsCorrect(null);
  }

  if (card === null) return null;

  return (
    <div>
      <Modal title={""} open={openModal} onOk={nextCard} okText="Next card" onCancel={viewCard} cancelText="View card">
        {answerImage}
        <p className="mt-[180px] mb-4 font-bold text-3xl text-center">Rating: {toHuman(reverseRatingMap[card["rating"].toString()])} ({card["rating"]})</p>
        <p className={`font-bold text-lg ${textColor}`}>{answerText}</p>
        <p className="mb-4">{card["comment"]}</p>  
      </Modal>      
      <h1 className="text-center font-bold text-2xl py-2">
        How would you rate this card?
      </h1>
      <div>
        <ProgressSeries ratingSeriesId={ratingSeriesId} refresherFlag={isCorrect} />
      </div>
      <div>
        <img src={card["image_uris"]["normal"]} alt={card["name"]} className="w-[280px] m-auto" />
      </div>
      <div className={`grid justify-items-center grid-cols-2 grid-rows-2 pt-2 ${ratingButtonsVisibility}`}>
        <PrimaryButton
          className="py-4 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating("bomb")}
          loading={isLoading}
        >
          Bomb!
        </PrimaryButton>
        <PrimaryButton
          className="py-4 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating("impactful")}
          loading={isLoading}
        >
          Impactful
        </PrimaryButton>
        <PrimaryButton
          className="py-4 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating("filler_a")}
          loading={isLoading}
        >
          Filler A
        </PrimaryButton>
        <PrimaryButton
          className="py-4 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating("filler_b")}
          loading={isLoading}
        >
          Filler B
        </PrimaryButton>
        <PrimaryButton
          className="py-4 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating("trap")}
          loading={isLoading}
        >
          Trap
        </PrimaryButton>
      </div>
      <div className={`grid justify-items-center grid-cols-2 pt-2 ${nextAndViewCardButtonsVisibility}`}>
        <PrimaryButton
          className="py-4 w-full justify-center text-xl flex items-center"
          onClick={nextCard}
        >
          Next
        </PrimaryButton>
        <PrimaryButton
          className="py-4 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating(lastRating)}
        >
          View rating
        </PrimaryButton>
      </div>
    </div>
  );
};

export default Card;
