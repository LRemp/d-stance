import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import Container from './components/Container'
import Prompt from './components/Prompt'

import PromptDataProvider from './context/Prompt/Provider'

function App() {
  const [visible, setVisible] = useState(true)

  return (
    <>
      <PromptDataProvider>
        <Container>

        </Container>
        <Prompt />
      </PromptDataProvider>
    </>
  )
}

export default App
