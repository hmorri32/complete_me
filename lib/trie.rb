require_relative 'node'
require_relative 'trie_methods'
require 'csv'

# TODO test a bunch and make modules maybe
class Trie
  include InsertMethods
  include SuggestMethods
  include DeleteMethods

  attr_accessor :head,
                :count, 
                :suggestions

  def initialize
    @head        = Node.new
    @count       = 0
    @suggestions = []
    @node_tank   = []
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

  def suggest(prefix, node = @head)
    clear_suggestions
    letters = prefix.chars
    letters.each { |letter| node = node.children[letter] }
    find_word(node, prefix)
    @suggestions
  end

  def delete(word)
    letters      = word.chars
    nodes        = letters.map { |letter| Node.new(letter) }
    node         = find_node(nodes)
    node.is_word = false
    node_pop(@node_tank)
    @count      -= 1
    @node_tank   = []
  end
end