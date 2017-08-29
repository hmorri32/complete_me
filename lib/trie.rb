require_relative 'node'
require_relative 'trie_methods'
require 'csv'

# TODO test a bunch and make modules maybe 
class Trie
  include InsertMethods
  include SuggestMethods

  attr_accessor :head,
                :count, 
                :suggestions

  def initialize
    @head        = Node.new(nil)
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

  def delete(word)
    letters = word.downcase.chars
    nodes   = letters.map {|letter| Node.new(letter)}
    node    = find_node(nodes)
    # return if node.nil?
    node.word_toggle

    node_pop(@node_tank)
    
    @count -= 1
    @node_tank = []

  end
  
  def node_pop(node_list)
    node = node_list.pop
    return if node.nil? || node.is_word

    # delete_node(node, node_list) 

    if node.children.empty?
      parent = node_list.last
      return if parent.nil?
      parent.children.delete(node.value)
    end
    node_pop(node_list)
  end

  def find_parent(node, node_list)
    node = node_list.last
  end

  def find_node(arr, parent = @head)
    # return nil if parent.nil?
    return @node_tank.last if arr.empty?
    node = arr.shift 
    @node_tank << parent.children[node.value]
    find_node(arr, parent.children[node.value])
  end
end