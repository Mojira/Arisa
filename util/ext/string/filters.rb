# Add filtering methods to the String class
class String
  def squish
    dup.squish!
  end

  def squish!
    gsub!(/[[:space:]]+/, ' ')
    strip!
    self
  end
end
