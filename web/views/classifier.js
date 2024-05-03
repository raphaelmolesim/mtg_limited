import React, { useDeferredValue, useEffect } from 'react';
import MasterPage from './master_page';
import { render } from 'react-dom';

const Classifier = () => {
  const [sets, setSets] = React.useState([]);

  useEffect(() => {
    console.log('Classifier component mounted');
    fetch('/api/sets')
      .then(response => response.json())
      .then(data => {
        console.log(data);
        setSets(data);
      });
  }, []);

  const renderSets = (sets) => {
    console.log('renderSets', sets);
    return sets.map(set => {
      return (
        <li key={set.code} className="py-12 text-xl font-bold flex flex-row justify-center items-center">
          <img src="https://svgs.scryfall.io/sets/otj.svg?1714363200" className="w-8 h-8 mr-4" />
          <a href={`/classifier/${set.code}`}>{set.name}</a>

        </li>
      );
    })
  };

  return(
    <MasterPage>      
      <h1 className="text-4xl font-bold text-center pt-8">Choose a set:</h1>

      <ul>
        {renderSets(sets)}
      </ul>
      
    </MasterPage>
  )
}
export default Classifier;