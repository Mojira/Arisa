# A hash containing queries used by modules.
# This allows for easier modification as everything is in one place,
# and makes the modules more readable.
QUERIES = {
  chk: '"Confirmation Status" != "Unconfirmed" AND "CHK" is EMPTY',
  fixversion: 'project in (MCL, MCPI, MCPE, MCCE, SC) ' \
              'AND resolution = Fixed AND fixVersion is EMPTY'
}
