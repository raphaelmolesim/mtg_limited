if ! test -f out/react.development.js; then
  cp node_modules/react/umd/react.development.js out
fi

if ! test -f out/react-dom.development.js; then
  cp node_modules/react-dom/umd/react-dom.development.js out
fi

npx babel --presets @babel/preset-react views --watch -d out  