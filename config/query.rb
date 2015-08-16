# The number of seconds the bot should wait before
# running the module checks again. Can be zero.
# NOTE: As JQL time can only include hours and
# minutes, setting this variable to less than 60
# seconds will waste quite a bit of bandwidth as
# many issues will be retrieved twice, and then
# discarded again.
# See util/issue_pool.rb for more information.
TASK_DELAY = 1 * 60

# The number of seconds the bot should wait if the
# server sends HTTP 429 Too Many Requests (RFC 6585)
EMERGENCY_COOLDOWN = 60 * 60

# The number of seconds the bot should add to its
# copy of TASK_DELAY if the server sends HTTP 429.
EMERGENCY_ADD_DELAY = 1 * 60

# The smallest amount of query results the bot can request
JQL_RESULTS_MIN = 1

# The amount of query results the bot requests by default
JQL_RESULTS_DFL = 50

# The largest number of query results the bot can request.
# This will be used by the IssuePool to retrieve as many
# results as possible. NOTE: The server will most likely
# implement its own limit on JQL query results.
JQL_RESULTS_MAX = 2**(32 - 1) - 1

API_TIME_FORMAT = '%FT%T.%L%z'
JQL_TIME_FORMAT = '%F %R'
