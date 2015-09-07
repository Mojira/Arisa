# A regular expression that matches unreleased versions
# Set this to nil if you'd like to use JIRA's `released` field instead
VERSION_UNRELEASED_REGEXP = /future/i

# Cache duration for versions when used passively,
# for example in JQL queries
VERSION_CACHE_TTL_PASSIVE = 60 * 60

# Cache duration for versions when used actively,
# for example when updating issues
VERSION_CACHE_TTL_ACTIVE = 2 * 60

# A URL containing the latest JRE version, for example "1.2.3_45"
JRE_VERSION_URL = 'http://java.com/applet/JreCurrentVersion2.txt'

# The time in seconds after which the JRE version should be updated
JRE_CACHE_TTL = 60 * 60 * 24 * 7

# Regular expression that extracts the main part of the version
# from the full version identifier that's used on crash reports
JRE_VERSION_REGEXP = /([\d\.]+_\d+), (.+)/

# Vendors that should be ignored when checking for outdated Java
# versions. You can find the vendor name after the Java version
# on crash reports. This setting can be used for vendors that
# tend to use versions that are far behind the latest official
# version in order to prevent the bot from notifying every user
# about their outdated Java version.
JRE_OUTDATED_IGNORE_VENDORS = ['Apple Inc.']
