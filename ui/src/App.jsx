import { useState } from 'react'
import Container from './components/Container'
import Prompt from './components/Prompt'

import './style/index.scss'

import PromptDataProvider from './context/Prompt/Provider'
import DataProvider from './context/Data/Provider'

function App() {
  const [visible, setVisible] = useState(true)

  return (
    <>
      <DataProvider>
        <PromptDataProvider>
          <Container>

          </Container>
          <Prompt />
        </PromptDataProvider>
      </DataProvider>
    </>
  )
}

export default App
