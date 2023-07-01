import React from 'react'

function Stage({ type, currentStep, maxSteps, active }) {
    const generateColumns = () => {
        const list = []
        for(let i = 0; i < maxSteps; i++) {
            list.push(<div key={i} className={`Column ${active && 'Column--active'}`} />)
        }
        return list
    }
  return (
    <div className={`Stage ${active && 'Stage--active'}`}>
        <div className={`Title ${active && 'Title--active'}`}>{type}</div>
        <div className='Meter'>
            
            <div className={`Cursor ${active && 'Cursor--active'}`} style={{ transform: `translateX(calc(2.95vw * ${currentStep - 1}))` }}></div>
            <div className={`Bar ${active && 'Bar--active'}`}>
                <div className={`Columns ${active && 'Columns--active'}`}>
                    {generateColumns()}
                </div>
            </div>
            
        </div>
        <div>
            <span className='Label Left'>MIN</span>
            <span className='Label Right'>MAX</span>
        </div>
    </div>
  )
}

export default Stage