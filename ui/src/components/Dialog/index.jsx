import React, { useContext, useState } from 'react'
import Stage from './Stage'
import useKeybind from '../../hooks/useKeybind'
import DataContext from '../../context/Data'

function Dialog() {
  const { stanceOptions, increase, reduce } = useContext(DataContext)
  const [activeSlider, setActiveSlider] = useState(0)

  const keyup = () => setActiveSlider(activeSlider - 1 < 0 ? stanceOptions.length - 1 : activeSlider - 1)
  const keydown = () => setActiveSlider(activeSlider + 1 < stanceOptions.length ? activeSlider + 1 : 0)
  const keyleft = () => {
    console.log('left')
    reduce(stanceOptions[activeSlider].type)
  }
  const keyright = () => {
    console.log('right')
    increase(stanceOptions[activeSlider].type)
  }

  useKeybind("ArrowUp", keyup)
  useKeybind("ArrowDown", keydown)
  useKeybind("ArrowLeft", keyleft)
  useKeybind("ArrowRight", keyright)

  return (
    <div className='Dialog'>
        <div className='Header'>
            STANCE
        </div>
        <div className='StagesList'>
          {stanceOptions.map((option, index) => <Stage {...option} key={option.type} active={activeSlider == index} />)}
        </div>
    </div>
  )
}

export default Dialog