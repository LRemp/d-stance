import React from 'react'
import Stance from './Stance'
import { DataContext } from '../context/Data'
import { DataContextType, StanceOption } from '../@types/context'
import useEvent from '../hooks/useEvent'
import useKeybind from '../hooks/useKeybind'
import useApi from '../hooks/useApi'

const Components: React.FC = () => {
  const api = useApi()
  const { visible, setVisible, setValue, loadConfiguration } = React.useContext(DataContext) as DataContextType

  useEvent("toggle-ui", () => {
    setVisible(true)
  })
  
  useEvent("load-configuration", ({ features }: { features: Array<StanceOption> }) => {
    loadConfiguration(features)
  })
  
  useEvent("update-values", ({ preset }: { preset: any }) => {
    for (const [key, value] of Object.entries(preset)) {
      setValue({ id: key, value })
    }
  })

  useKeybind("Escape", () => {
    setVisible(false)
    api({ type: "close-ui" })
  })

  return (
    <div className='Container'>
      {visible && <Stance />}
    </div>
  )
}

export default Components