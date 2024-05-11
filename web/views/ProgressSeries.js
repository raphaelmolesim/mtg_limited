import React, { useEffect } from "react";

const ProgressSeries = ({ ratingSeriesId, refresherFlag }) => {
  const [ratings, setRatings] = React.useState(null);

  const getColorClass = (isFilled, rating) => {
    if (isFilled) {
      if (rating["conclusion"] == "true") {
        return "border-green-500";
        } else {
        return "border-red-500";
        }
    } else {
      return "border-black";
    }
  }

  const renderProgressSeries = (ratings) => {
    const listItems = []
    for (let i = 0; i < 20; i++) { 
      const isFilled = (ratings || []).length > i;
      const rating = isFilled ? ratings[i] : null;
      const colorClass = getColorClass(isFilled, rating)
      const item = <div className={`flex-1 border ${colorClass}`}></div>
      listItems.push(item) 
    }

    return listItems;
  }

  useEffect(() => {
    fetch(`/api/rating_series/${ratingSeriesId}/ratings`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => {
        setRatings(data);
      });
  }, [refresherFlag, ratingSeriesId])

  return (
    <div className="flex flex-row gap-[1px] mb-1">
      {renderProgressSeries(ratings)}
    </div>
  );
}

export default ProgressSeries;