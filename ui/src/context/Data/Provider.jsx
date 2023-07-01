import { useState } from 'react';
import context from './context';

const Provider = ({ children }) => {
  const setOptions = () => {

  }
  const reduce = (type) => {
    const index = data.stanceOptions.findIndex(x => x.type == type)
    const options = data.stanceOptions
    if(options[index].currentStep - 1 > 0) options[index].currentStep = options[index].currentStep - 1
    setData({...data, stanceOptions: [...options]})
  }
  const increase = (type) => {
    const index = data.stanceOptions.findIndex(x => x.type == type)
    const options = data.stanceOptions
    if(options[index].currentStep < options[index].maxSteps) options[index].currentStep = options[index].currentStep + 1
    setData({ ...data, stanceOptions: [...options] })
  }
  const [data, setData] = useState({
    stanceOptions: [
      {
        type: "frontcamber",
        currentStep: 1,
        maxSteps: 8
      },
      {
        type: "rearcamber",
        currentStep: 6,
        maxSteps: 8
      },
      {
        type: "frontoutter",
        currentStep: 7,
        maxSteps: 8
      },
      {
        type: "rearoutter",
        currentStep: 8,
        maxSteps: 8
      },
    ],
    reduce,
    increase,
    setOptions
  });

  return <context.Provider value={data}>{children}</context.Provider>;
};

export default Provider