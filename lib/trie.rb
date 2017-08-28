require 'csv'
require_relative 'trie_methods'

# TODO test a bunch and make modules maybe 
class Trie
  include InsertMethods
  include SuggestMethods

  attr_accessor :count, :suggestions

  def initialize
    @head        = Node.new
    @count       = 0
    @suggestions = []
  end

  def insert(word, node = @head)
    return if word.empty? || word.nil?
    letters = word.chars
    iterate_n_insert(word, node, letters)
  end

  def populate(string)
    formatted = format(string)
    formatted.each { |word| insert(word) }
  end

  def populate_csv(file)
    CSV.foreach(file) {|row| insert(row[-1])}
  end

  def suggest(prefix, node = @head)
    clear_suggestions
    letters = prefix.chars
    letters.each { |letter| node = node.children[letter] }
    find_word(node, prefix)
    @suggestions
  end
end