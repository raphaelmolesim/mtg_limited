import React, { useEffect } from "react";
import PrimaryButton from "./Base";
import { CheckCircleOutlined, CloseCircleOutlined } from '@ant-design/icons';

const Card = ({card, nextCardFunction}) => {
  const [isCorrect, setIsCorrect] = React.useState(null);

  const answerVisibility = isCorrect === null ? "hidden" : "block";
  const iconColor = { color: isCorrect === true ? "green" : "red"}
  const iconStyle = { fontSize: "xxx-large", ...iconColor }
  const correctIcon = <CheckCircleOutlined style={iconStyle} />;
  const incorrectIcon = <CloseCircleOutlined style={iconStyle} />;
  const answerText = isCorrect === true ? "Nice! You got it!!!" : "Ops, not that...";
  const answerIcon = isCorrect === true ? correctIcon : incorrectIcon;

  const selectRating = (rating) => {
    const ratings = {
      bomb: [4.5, 5],
      impactful: [3.5, 4.0],
      filler_a: [2.5, 3.0],
      filler_b: [2.5, 2.0],
      trap: [1.0, 1.0, 0]
    }[rating]

    if (ratings.includes(card["rating"])) {
      console.log("Correct!");
      setIsCorrect(true);
    } else {
      console.log("Incorrect!");
      setIsCorrect(false);
    }
  }

  const nextCard = () => {
    setIsCorrect(null);
    nextCardFunction();
  }

  if (card === null)
    return null;

  return (
    <div>
      <div className={`${answerVisibility} absolute top-88 p-8 bg-white`}>
        <div className="relative inline float-right -top-[19px]">{answerIcon}</div>
        <h1 className="text-2xl font-bold mb-4">{answerText}</h1>
        <p>Rating: {card["rating"]}</p>
        <p className="mb-4">{card["comment"]}</p>
        <PrimaryButton onClick={nextCard}>Next</PrimaryButton>
      </div>
      <h1 className="text-center font-bold text-2xl py-4">How would you rate this card?</h1>
      <div>
        <img src={card["image_uris"]["normal"]} />
      </div>
      <div className="grid justify-items-center grid-cols-2 grid-rows-2 pt-2">
        <PrimaryButton className="py-6 w-full justify-center text-xl flex items-center" onClick={() => selectRating('bomb')}>Bomb!</PrimaryButton>
        <PrimaryButton className="py-6 w-full justify-center text-xl flex items-center" onClick={() => selectRating('impactful')}>Impactful</PrimaryButton>
        <PrimaryButton className="py-6 w-full justify-center text-xl flex items-center" onClick={() => selectRating('filler_a')}>Filler A</PrimaryButton>
        <PrimaryButton className="py-6 w-full justify-center text-xl flex items-center" onClick={() => selectRating('filler_b')}>Filler B</PrimaryButton>
        <PrimaryButton className="py-6 w-full justify-center text-xl flex items-center" onClick={() => selectRating('trap')}>Trap</PrimaryButton>
      </div>
    </div>
  );
}

export default Card;