import React from 'react';
import MasterPage from './master_page';

const App = () => {

  return (
    <MasterPage>
      <h1 className="text-4xl font-bold text-center pt-8">Welcome to the</h1>
      <h1 className="text-5xl font-bold text-center pb-8">MTG Limited</h1>
      <div class="flex flex-row items-center justify-center py-8">
        <img src="phage-splash.jpeg" alt="MTG Limited" className="w-[340px] h-[462px]" />
      </div>
    </MasterPage>
  );
};
export default App;