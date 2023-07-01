import { useEffect } from 'react'

const useKeybind = (keybind, callback) => {
  useEffect(() => {
    const handler = (event) => {
      if (event.key === keybind) {
        callback()
      }
    }
    window.addEventListener('keydown', handler)

    return () => {
      window.removeEventListener('keydown', handler)
    }
  }, [keybind, callback])
}

export default useKeybind;