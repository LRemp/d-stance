export type DataContextType = {
    visible: boolean,
    setVisible: Function,
    stanceOptions: Array<StanceOption>,
    setValue: Function,
    loadConfiguration: Function<Array<StanceOption>>,
}

export type StanceOption = {
    id: string,
    name: string,
    value?: number
}