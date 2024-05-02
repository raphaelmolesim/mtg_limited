import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'antd';


const App = () => (
  <div className="App">
    <Button type="primary">Button</Button>
  </div>
);

ReactDOM.render(<App />, document.getElementById('app'));