require_relative 'trie'
require_relative 'trie_methods' 

class CompleteMe
  include SelectMethods

  attr_reader :selected

  def initialize 
    @trie     = Trie.new
    @selected = Hash.new
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
    if @selected[word].nil?
       @trie.suggest(word)
    else 
      (select_sort(word) << @trie.suggest(word)).flatten.uniq
    end
  end

  def select(key = prefix, word)
    # TODO - check if the word is actually in our yung trie 
    !@selected[key] ? create_key(key, word) : increment(key, word)
  end
end