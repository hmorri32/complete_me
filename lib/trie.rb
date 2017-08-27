require 'csv'
require_relative 'node'

class Trie
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

  def iterate_n_insert(word, node, letters)
    letters.each.with_index do |letter, index|
      create_node_if_absent(letter, node)
      node = node.children[letter]
      update_if_word(word, node, index)
    end
  end

  def update_if_word(word, node, index)
    if index == word.length - 1
      node.is_word = true
      @count +=1
    end
  end

  def create_node_if_absent(letter, node)
    node.children[letter] = Node.new unless node.children[letter]
  end

  def populate(string)
    formatted = format(string)
    formatted.each { |word| insert(word) }
  end

  def populate_csv(file)
    CSV.foreach(file) {|row| insert(row[-1])}
  end

  def format(string)
    string.strip.split("\n")
  end

  def suggest(prefix, node = @head)
    clear_suggestions
    letters = prefix.chars
    letters.each { |letter| node = node.children[letter] }
    find_word(node, prefix)
    @suggestions    
  end

  def find_word(node, prefix)
    push_word(node, prefix)
    reassign_node(node, prefix)
  end

  def reassign_node(node, prefix)
    yung_keys = node.children.keys
    yung_keys.each do |letter|
      child   = node.children[letter]
      concat  = prefix + letter
      find_word(child, concat)
    end
  end

  def push_word(node, prefix)
    @suggestions << prefix if node.is_word     
  end
  
  def clear_suggestions
    @suggestions = []
  end
end