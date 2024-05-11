import React from "react";

const Image = ({src, className, props}) => {

  const s3 = "https://mtg-limited.s3.sa-east-1.amazonaws.com/";

  const fullName = (src) => {
    return s3 + src;
  }

  return (
      <img src={fullName(src)} className={className} {...props} />
  );
}

export default Image;