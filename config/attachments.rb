# Attachments with one of the following
# mime types will be deleted.
ATTACHMENT_DELETE_MIME = [
  'application/java-archive',
  'application/x-msdos-program',
  'application/x-msdownload',
  'application/x-ms-dos-executable'
]

# Attachments with names matching one of the
# following regular expressions will be deleted.
ATTACHMENT_DELETE_NAME = [
  /\.jar\z/,
  /\.exe\z/,
  /\.com\z/,
  /\.bat\z/,
  /\.msi\z/,
  /\.run\z/,
  /\.com\z/,
  /\.lnk\z/
]
