require_relative 'require_helper'

class TrieTest < Minitest::Test
  def setup
    @trie = Trie.new
  end
  
  def test_populate_csv_small_file
    @trie.populate_csv('test/20_addresses.csv')
    assert_equal 20, @trie.count
  end
  
  def test_suggest_addresses
    @trie.populate_csv('test/20_addresses.csv')
    assert_equal ["16100 E 56th Ave", "19100 E 40th Ave"], @trie.suggest('1')
    assert_equal ["21541 E 44th Ave", "21563 E 44th Ave"], @trie.suggest('215')
  end

  def test_populate_csv_large_file
    skip
    # works but takes forever
    @trie.populate_csv('test/addresses.csv')
    assert_equal 306013, @trie.count
  end
end