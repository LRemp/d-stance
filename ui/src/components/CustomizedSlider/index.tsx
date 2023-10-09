import * as React from 'react'
import { DataContextType, StanceOption } from "../../@types/context"
import classes from "./CustomizedSlider.module.css"
import { Slider } from "@mantine/core"
import { useMove } from "@mantine/hooks"
import { DataContext } from '../../context/Data'

import useApi from '../../hooks/useApi'

const CustomizedSlider = ({ id, value = 0.0 }: StanceOption) => {
  const api = useApi();
  const { setValue } = React.useContext(DataContext) as DataContextType
  const { ref } = useMove(({ x }) => {
    if(value == x) return;
    setValue({ id, value: x })
    api({
      type: 'set-value',
      id: id,
      value: x
    })
  });

  return (
    <div style={{ marginTop: '10px', marginBottom: '30px'}}>
      <Slider 
        defaultValue={value * 100}
        marks={[
          { value: 25, label: '25%' },
          { value: 50, label: '50%' },
          { value: 75, label: '75%' },
        ]}
        size={2}
        color='blue'
        classNames={classes}
        ref={ref}
        step={1}
      >
      </Slider>
    </div>
  )
}

export default CustomizedSlider