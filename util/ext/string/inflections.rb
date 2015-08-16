# Add inflection methods to the String class
class String
  def symbolify
    dup.symbolify!
  end

  def symbolify!
    strip!
    downcase!
    gsub!(/[^a-z_]+/, '_')
    self
  end
end
