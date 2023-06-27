import { useEffect } from 'react';

const useEvent = (type, callback) => {
  useEffect(() => {
    const handler = (event) => {
      if (event.data.type === type) {
        callback(event.data);
      }
    };
    window.addEventListener('message', handler);

    return () => {
      window.removeEventListener('message', handler);
    };
  }, [type, callback]);
};

export default useEvent;
