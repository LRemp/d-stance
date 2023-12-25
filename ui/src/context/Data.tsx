import * as React from 'react'
import { DataContextType, StanceOption } from '../@types/context';

export const DataContext = React.createContext<DataContextType | null>(null);

type ComponentProps<T = React.ReactNode> = {
    children: T;
  };

const DataContextProvider: React.FC<ComponentProps> = ({ children }) => {
  const setValue = ({ id, value } : { id: string, value: number }) => {
    const index = data.stanceOptions.findIndex(x => x.id == id)
    const options = data.stanceOptions
    options[index].value = value
    setData((state) => ({ ...state, stanceOptions: [...options] }))
  }
  const loadConfiguration = (data: Array<StanceOption>) => {
    const options: any = []
    data.map((option: StanceOption) => options.push({ 
      id: option.id,
      name: option.name,
      value: 0.0
    }))
    setData((state) => ({ ...state, stanceOptions: options }))
  }
  const setVisible = (value: boolean) => setData((state) => ({ ...state, visible: value }))
  const [data, setData] = React.useState({
    visible: true,
    setVisible,
    stanceOptions: [
      {
        id: "frontCamber",
        name: "Front camber",
        value: 0.0
      },
      {
        id: "rearCamber",
        name: "Rear camber",
        value: 0.0
      },
      {
        id: "frontWidth",
        name: "Front outter",
        value: 0.0
      },
      {
        id: "rearWidth",
        name: "Rear outter",
        value: 0.0
      },
      {
        id: "suspensionHeight",
        name: "Suspension height",
        value: 0.0
      },
      {
        id: "wheelSize",
        name: "Wheels size",
        value: 0.0
      },
    ],
    setValue,
    loadConfiguration
  });

  return <DataContext.Provider value={data}>{children}</DataContext.Provider>;
};

export default DataContextProvider