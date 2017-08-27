require_relative 'trie'

class CompleteMe
  attr_reader :library
  def initialize 
    @trie    = Trie.new
    @library = Hash.new
  end

  def insert(word)
    @trie.insert(word)
  end
  
  def count
    @trie.count
  end

  def populate(string)
    @trie.populate(string)
  end

  def suggest(word)
    if @library[word].nil?
      @trie.suggest(word)
    else 
      (library_sort(word) << @trie.suggest(word)).flatten.uniq
    end
  end

  def select(key = prefix, word)
    # TODO - check if the word is actually in our yung trie 
    if @library[key].nil?
       @library[key] = {word => 1}
    else
      if @library[key][word]
         @library[key][word] += 1
      else 
        @library[key][word] = 1   
      end
    end
  end

  def library_sort(prefix)
    @library[prefix].sort
                    .reverse!
                    .map(&:first)
  end
end