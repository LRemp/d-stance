import { useEffect } from 'react';

const useEvent = (type: string, callback: Function) => {
  useEffect(() => {
    const handler = (event: any) => {
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
