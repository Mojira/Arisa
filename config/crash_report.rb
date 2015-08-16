# An array of regular expressions that match the
# "System Details / Is Modded" values of crash
# reports that should be treated as modded
CR_MODDED = [
  /very likely/i,
  /definitely/i
]

# Crash report parsing configuration
# You probably don't need to change this
CR_HEADER = '---- Minecraft Crash Report ----'
CR_STACKTRACE_HEADER = 'Stacktrace:'
CR_DETAILS_HEADER = 'Details:'
CR_VALUE_SEPARATOR = ': '
CR_COMMENT_PREFIX = '//'
CR_SECTIONS = {
  main: {
    stacktrace: :block
  },
  head: {
    title: 'Head',
    stacktrace: :value
  },
  ticked_entity: {
    title: 'Entity being ticked',
    stacktrace: :value
  },
  tesselated_block: {
    title: 'Block being tesselated',
    stacktrace: :value
  },
  screen: {
    title: 'Affected screen',
    stacktrace: :value
  },
  message: {
    title: 'Serialized Message',
    stacktrace: :value
  },
  level: {
    title: 'Affected level',
    stacktrace: :value
  },
  initialization: {
    title: 'Initialization',
    stacktrace: :value
  },
  system: {
    title: 'System Details'
  }
}
