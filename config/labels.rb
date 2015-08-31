# A regular expression that matches valid labels.
# Any labels that don't match will be removed from issues.
VALID_LABEL_REGEXP = %r{\A[0-9a-z/][a-z-]{,30}[0-9a-z]\z}i

# A list of labels that should always be removed from issues.
# Labels will be converted to lower case before they're checked against this.
LABEL_BLACKLIST = %w(
  bad bug bugs ce error game help ios ipad iphone ipod mcce mcpe pc pe play
  scrolls
)

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
  /\Anew/i,
  /\Anot/i,
  /\Apocket/i
]
