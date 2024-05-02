const path = require('path');

module.exports = {
  entry: "./web/views/index.js",
  output: {
    path: path.resolve(__dirname, 'web/public'),
    filename: "bundle.js"
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        options: {
          presets: ['@babel/preset-env', '@babel/preset-react']
        }
      }
    ]
  }
}