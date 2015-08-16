# Parent issues will be identified by at least one of the following:
#   headers: The first line of the stack trace
#   classes: The exception class in the first line of the stack trace
#   descriptions: The error description above the stacktrace
#   versions: Game versions affected by this issue
# The issue will then be resolved and linked to the corresponding parent issue.
# You can specify different comments for each parent issue. To do so, just
# create the file responses/duplicate/issue/{key}, replacing {key} with the
# key of the parent issue (like MC-1). Then, put the comment body in that file.

PARENT_ISSUES = {
  # The infamous MC-297: no supported graphics drivers
  'MC-297' => {
    headers: [
      'org.lwjgl.LWJGLException: Could not create context',
      'org.lwjgl.LWJGLException: Pixel format not accelerated'
    ]
  },
  # Failed to check session.lock
  'MC-10167' => {
    headers: [
      'java.lang.RuntimeException: Failed to check session lock, aborting'
    ]
  },
  # JRE out of RAM
  'MC-12949' => {
    classes: [
      'java.lang.OutOfMemoryError'
    ]
  },
  # Unable to fit texture, use a lower texture resolution
  'MC-29565' => {
    headers: [
      'Maybe try a lowerresolution texturepack'
    ]
  },
  # Malware or antivirus software blocking localhost connection
  'MC-34749' => {
    headers: [
      'java.lang.IllegalStateException: failed to create a child event loop'
    ]
  },
  # Incompatible view distance after downgrading
  'MC-38527' => {
    classes: [
      'java.lang.IndexOutOfBoundsException'
    ],
    versions: [
      '1.7.2',
      '1.7.4',
      '1.7.10'
    ]
  },
  # Watchdog shuts down server
  'MC-63590' => {
    descriptions: [
      'Watching Server'
    ],
    classes: [
      'java.lang.Error'
    ]
  }
}
