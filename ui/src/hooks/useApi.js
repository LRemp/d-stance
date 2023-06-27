import { useCallback } from 'react';
import { GetParentResourceName } from '../fivem';

const useApi = () => {
  const request = useCallback(({ type, ...rest }) => {

    return fetch(`https://${GetParentResourceName()}/${type}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(rest),
    })
      .then((resp) => resp.json())
  }, []);

  return request;
};

export default useApi;
