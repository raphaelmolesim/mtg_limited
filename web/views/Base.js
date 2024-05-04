import { Button } from "antd";
import React from "react";

const PrimaryButton = ({children, onClick, className = "", props }) => {
  return (
    <Button onClick={onClick} className={`bg-cyan-700 text-slate-100 ${className}`} {...props} >
      {children}
    </Button>
  )
}
export default PrimaryButton;