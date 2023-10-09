import { useEffect } from 'react'

const useKeybind = (keybind: string, callback: Function) => {
  useEffect(() => {
    const handler = (event: KeyboardEvent) => {
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