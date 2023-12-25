import "@mantine/core/styles.css";
import { MantineProvider } from "@mantine/core";
import { theme } from "./theme";
import Components from "./components";
import DataContextProvider from "./context/Data";
import { ModalsProvider } from "@mantine/modals";

export default function App() {
  return <MantineProvider theme={theme} defaultColorScheme="dark">
    <ModalsProvider>    
      <DataContextProvider>
        <Components />
      </DataContextProvider>
    </ModalsProvider>
  </MantineProvider>;
}
