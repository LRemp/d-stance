import { useCallback, useEffect } from 'react';
import useAsync from './useAsync';
import useApi from './useApi';

const useApiResult = (fn, dependencies = []) => {
  const api = useApi();
  const { loading, result, error, run } = useAsync(true);

  const requestAndSetResults = useCallback(
    async (...args) => {
      const promise = api(fn(...args));
      run(promise);
      return promise;
    },
    [api, run, fn]
  );

  useEffect(() => {
    // if we have specified any dependencies, auto request
    if (dependencies) {
      requestAndSetResults().catch(() => {
        // catch the error to stop the "uncaught exception error"
      });
    }
  }, [...dependencies]); // eslint-disable-line react-hooks/exhaustive-deps

  if (error) {
    // throw in render to allow the error boundary to catch it
    throw error;
  }

  return {
    loading,
    result,
    error,
    request: requestAndSetResults,
  };
};

export default useApiResult;
