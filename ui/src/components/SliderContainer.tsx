import React from 'react'
import { Title } from "@mantine/core"
import CustomizedSlider from './CustomizedSlider'

interface Props {
  id: string,
  name: string,
  value: number
}

const SliderContainer: React.FC<Props> = ({ id, name, value }: Props) => {
  return (
    <div>
        <Title order={5} ta="center">{name}</Title>
        <div>
            <CustomizedSlider value={value} id={id} name={name}></CustomizedSlider>
        </div>
    </div>
  )
}

export default SliderContainer