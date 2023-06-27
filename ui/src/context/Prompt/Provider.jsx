import { useState, useCallback } from 'react';
import context from './context';

const Provider = ({ children }) => {
  const showPrompt = ({ title, options }) => {
    setData(state => ({...state, title, options, visible: true }))
  }
  const hidePrompt = () => {
    setData(state => ({...state, visible: false}))
  }
  const [data, setData] = useState({
    prompt: {
        visible: true,
        options: [],
        title: ""
    },
    showPrompt,
    hidePrompt
  });

  return <context.Provider value={data}>{children}</context.Provider>;
};

export default Provider