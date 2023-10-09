import "@mantine/core/styles.css";
import { MantineProvider } from "@mantine/core";
import { theme } from "./theme";
import Components from "./components";
import DataContextProvider from "./context/Data";

export default function App() {
  return <MantineProvider theme={theme} defaultColorScheme="dark">
    <DataContextProvider>
      <Components />
    </DataContextProvider>
  </MantineProvider>;
}
