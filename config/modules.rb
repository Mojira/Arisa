# Require all modules
core_dir = File.dirname(__FILE__)
files = File.join(core_dir, '..', 'modules', '**', '*.rb')
Dir[files].each { |file| require file }

# List of modules that will be loaded when the bot starts
ENABLED_MODULES = [
    # Query modules
    Arisa::CHKModule,
    Arisa::FixVersionModule,

    # Issue modules
    Arisa::PiracyModule,

    # Update modules
    Arisa::AttachmentModule,
    Arisa::TrashModule,
    Arisa::IncompleteModule,
    Arisa::UnreleasedModule,
    Arisa::LabelModule,
    Arisa::ReopenAffectedModule,
    Arisa::ReopenUpdatedModule,
    Arisa::SecurityModule,

    # Crash modules
    Arisa::JavaVersionModule,
    Arisa::DuplicatesModule,
    Arisa::ModsModule,
    Arisa::VersionModule
]
