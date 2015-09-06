# A regular expression that matches valid labels.
# Any labels that don't match will be removed from issues.
VALID_LABEL_REGEXP = %r{\A[0-9a-z/][a-z-]{,30}[0-9a-z]\z}i

# A list of labels that should always be removed from issues.
# Labels will be converted to lower case before they're checked against this.
LABEL_BLACKLIST = %w(
  bad bug bugs ce error game help ios ipad iphone ipod mcce mcpe pc pe play
  scrolls about above after again against all am an and any are as at be because
  been before being below between both but by cannot could did do does doing
  down during each few for from further had has have having he her here hers
  herself him himself his how if in into is it its itself me more most my
  myself no nor not of off on once only or other ought our ours ourselves out
  over own same she should so some such than that the their theirs them
  themselves then there these they this those through to too under until up
  very was we were what when where which while who whom why with would you your
  yours yourself yourselves
)

# A list of labels that will be substituted with other labels.
LABEL_ALIASES = {
  # TODO: Add more useful labels here
  'myzel' => 'mycelium'
}

# A list of regular expressions that match labels which should be removed.
# As always in Ruby, \A matches the start of a string, \z matches the end.
# NOTE: Regular expressions without \A and \z match anywhere in the label.
LABEL_BLACKLIST_REGEXP = [
  /[0-9]{2}w[0-9]{2}[a-z]/, # Don't allow snapshot versions in labels
  /\A[[:digit:]]+\z/, # Don't allow labels containing only digits
  /android/i,
  /annoying/i,
  /creative/i,
  /feature/i,
  /galaxy/i,
  /glitch/i,
  /issue/i,
  /launcher/i,
  /minecraft/i,
  /mojang/i,
  /please/i,
  /problem/i,
  /stupid/i,
  /survival/i,
  /xperia/i,
  /\Anew-/i,
  /\Anot-/i
]
