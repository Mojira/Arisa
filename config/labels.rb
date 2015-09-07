# A regular expression that matches valid labels.
# Any labels that don't match will be removed from issues.
VALID_LABEL_REGEXP = %r{\A[0-9a-z/][a-z-]{,32}[0-9a-z]\z}i

# A list of labels that should always be removed from issues.
# Labels will be converted to lower case before they're checked against this.
LABEL_BLACKLIST = %w(
                     bad bug bugs ce error game help ios ipad iphone ipod mc mcce mcpe pc pe play
                     scrolls about above after again against all am an and any are as at be because
                     been before being below between both but by cannot could did do does doing
                     down during each few for from further had has have having he her here hers
                     herself him himself his how if in into is it its itself me more most my
                     myself no nor not of off on once only or other ought our ours ourselves out
                     over own same she should so some such than that the their theirs them
                     themselves then there these they this those through to too under until up
                     very was we were what when where which while who whom why with would you your
                     yours yourself yourselves slow fast old new huge large big small tiny medium
                     normal bright dark break breaking forge bukkit mods modded nobug nil null
                     none nan fast slow quick slowly quickly 1x1 omg wtf
                     )

# Labels that are similar to labels listed here will be replaced.
# Similar means that the letters are the same; but case and hyphens
# are ignored when checking if two labels are similar to each other.
# Example: HelloWorld is similar to hello-world.
KNOWN_LABELS = %w(
                  FPS LAN GUI OSX AI UI UX HD UHD IP HUD FX BUD JRE JDK NIC
                  WLAN LAN DNS DHCP FTP SQL
                  
                  timeout mac
                  
                  command-block redstone-block iron-block gold-block diamond-block
                  null-pointer-exception spawn-egg enchanting-table custom-name
                  armor-stand splash-potion pressure-plate weighted-pressure-plate
                  command-block-output command-block-minecart log-in log-out
                  south-east-rule dragon-egg illegal-argument-exception item-frame
                  concurrent-modification-exception chicken-jockey full-screen
                  potion-effect world-generation resource-pack
                  
                  /give /summon /tp /setworldspawn /replaceitem /msg
                  )

# A list of labels that will be substituted with other labels.
LABEL_ALIASES = {
    'render' => 'rendering',
    'items' => 'item',
    'mobs' => 'mob',
    'blocks' => 'block',
    'particles' => 'particle',
    'animals' => 'animal',
    'tabulator' => 'tab',
    'texturepack' => 'resource-pack'
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