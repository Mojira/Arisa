# Add filtering methods to the Hash class
class Hash
  alias_method :__fetch, :[]

  def traverse(*path)
    path.inject(self) { |a, e| a.__fetch(e) || break }
  end

  def [](*args)
    (args.length > 1) ? traverse(*args) : __fetch(*args)
  end
end
