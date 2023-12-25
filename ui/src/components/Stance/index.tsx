import { Paper, Title, Button, Flex, Text } from '@mantine/core'
import { modals } from '@mantine/modals'
import React, { useState, useContext } from 'react'
import SliderContainer from '../SliderContainer'
import { IconDeviceFloppy, IconCheck, IconArrowBack, IconCircleXFilled } from '@tabler/icons-react'
import { DataContextType } from '../../@types/context'
import { DataContext } from '../../context/Data'
import useApi from '../../hooks/useApi'

const Stance: React.FC = () => {
  const api = useApi()
  const [saving, setSaving] = useState<boolean>(false)
  const [saved, setSaved] = useState<boolean>(false)
  const icon = <IconDeviceFloppy size={18}/>
  const iconRevert = <IconArrowBack size={18}/>

  const { stanceOptions } = useContext(DataContext) as DataContextType

  const save = () => {
    setSaving(true)
    setSaved(false)
  }

  const reset = () => {
    api({ type: 'reset' })
  }

  const openCloseDialog = () => modals.openConfirmModal({
    title: 'Do you really want to exit stance menu?',
    centered: true,
    children: (
      <Text size="sm">
        By closing menu you will lose the current settings set in the menu, the defaults will be loaded after exiting the menu.
      </Text>
    ),
    labels: { confirm: 'Confirm', cancel: 'Cancel' },
    onCancel: () => console.log('Cancel'),
    onConfirm: () => console.log('Confirmed'),
  });

  return (
    <div className='Stance'>
      <Paper withBorder p="lg" radius="md" shadow="md">
        <Flex>
          <Title order={3}>Stance</Title>
          <Button onClick={openCloseDialog}>
            <IconCircleXFilled className='m-auto' />
          </Button>
        </Flex>
        <hr />

        {stanceOptions.map((option: any, _: number) => <SliderContainer key={option.name} {...option} />)}

        <div style={{ display: 'grid', gridAutoFlow: 'column', justifyContent: 'space-between' }}>
          <div>
            <Button style={{ margin: 'auto 0', float: 'right' }} justify='center' rightSection={iconRevert} color="blue" mt="md" onClick={reset}>Reset</Button>
          </div>
          <div style={{ display: 'flex' }}>
            { saved && <span style={{ fontSize: '12px', color: 'lightgreen', display: 'flex', margin: 'auto 0', paddingRight: '10px' }}><IconCheck size={18} />Saved</span> }
            <Button style={{ margin: 'auto 0'}} justify='center' rightSection={icon} color="blue" mt="md" loading={saving} loaderProps={{ type: 'dots' }} onClick={save}>Save</Button>
          </div>
        </div>
      </Paper>
    </div>
  )
}

export default Stance