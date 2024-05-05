import React, { useEffect } from "react";
import PrimaryButton from "./Base";
import { Modal } from "antd";
import Image from "./Image";

const Card = ({ card, nextCardFunction }) => {
  const [isCorrect, setIsCorrect] = React.useState(null);
  const [lastRating, setLastRating] = React.useState(null);

  const answerVisibility = isCorrect === null ? "hidden" : "block";
  const imageStyle = "absolute top-0 left-0 w-full h-[190px] object-cover rounded-lg"
  const incorrectImage = <Image src="swat-crop.jpg" className={`${imageStyle} object-top`} /> 
  const correctImage = <Image src="true-believer.png" className={`${imageStyle} object-center`} /> 
  const answerText =
    isCorrect === true ? "Nice! You got it!!!" : "Ops, not that...";
  const textColor = isCorrect === true ? "text-emerald-600" : "text-red-600";
  const answerImage = isCorrect === true ? correctImage : incorrectImage;
  const openModal = isCorrect === null ? false : true;
  const nextAndViewCardButtonVisibility = lastRating != null ? "block" : 'hidden';
  const ratingButtonsVisibility = lastRating != null ? 'hidden' : "block";

  const ratingMap = {
    bomb: [4.5, 5],
    impactful: [3.5, 4.0],
    filler_a: [2.5, 3.0],
    filler_b: [2.5, 2.0],
    trap: [1.0, 1.0, 0],
  }

  const reverseRatingMap = Object.keys(ratingMap).reduce((acc, key) => {
    const ratings = ratingMap[key];
    console.log("ratings", ratings);
    console.log("key", key, acc);
    ratings.forEach(rating => {
      acc[rating.toString()] = key;
    });
    return acc;
  }, {});

  const selectRating = (rating) => {
    setLastRating(rating)
    const ratings = ratingMap[rating];

    if (ratings.includes(card["rating"])) {
      console.log("Correct!");
      setIsCorrect(true);
    } else {
      console.log("Incorrect!");
      setIsCorrect(false);
    }
  };

  const nextCard = () => {
    setIsCorrect(null);
    setLastRating(null)
    nextCardFunction();
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
      <h1 className="text-center font-bold text-2xl py-4">
        How would you rate this card?
      </h1>
      <div>
        <img src={card["image_uris"]["normal"]} alt={card["name"]} />
      </div>
      <div className={`grid justify-items-center grid-cols-2 grid-rows-2 pt-2 ${ratingButtonsVisibility}`}>
        <PrimaryButton
          className="py-6 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating("bomb")}
        >
          Bomb!
        </PrimaryButton>
        <PrimaryButton
          className="py-6 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating("impactful")}
        >
          Impactful
        </PrimaryButton>
        <PrimaryButton
          className="py-6 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating("filler_a")}
        >
          Filler A
        </PrimaryButton>
        <PrimaryButton
          className="py-6 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating("filler_b")}
        >
          Filler B
        </PrimaryButton>
        <PrimaryButton
          className="py-6 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating("trap")}
        >
          Trap
        </PrimaryButton>
      </div>
      <div className={`grid justify-items-center grid-cols-2 pt-2 ${nextAndViewCardButtonVisibility}`}>
        <PrimaryButton
          className="py-6 w-full justify-center text-xl flex items-center"
          onClick={nextCard}
        >
          Next
        </PrimaryButton>
        <PrimaryButton
          className="py-6 w-full justify-center text-xl flex items-center"
          onClick={() => selectRating(lastRating)}
        >
          View rating
        </PrimaryButton>        
      </div>
    </div>
  );
};

export default Card;
