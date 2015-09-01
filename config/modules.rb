# Require all modules
core_dir = File.dirname(__FILE__)
files = File.join(core_dir, '..', 'modules', '**', '*.rb')
Dir[files].each { |file| require file }

# List of modules that will be loaded when the bot starts
ENABLED_MODULES = [
  Arisa::AttachmentModule,
  Arisa::CHKModule,
  Arisa::DuplicatesModule,
  Arisa::FixVersionModule,
  Arisa::IncompleteModule,
  Arisa::JavaVersionModule,
  Arisa::LabelModule,
  Arisa::ModsModule,
  Arisa::PiracyModule,
  Arisa::ReopenAffectedModule,
  Arisa::ReopenUpdatedModule,
  Arisa::SecurityModule,
  Arisa::TrashModule,
  Arisa::UnreleasedModule,
  Arisa::VersionModule
]
