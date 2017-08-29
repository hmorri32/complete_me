require_relative 'require_helper'

class NodeTest < MiniTest::Test 
  def setup
    @node = Node.new
  end

  def test_node_exists
    assert @node
  end

  def test_instance
    assert_instance_of Node, @node
  end 
  
  def test_is_word_default_false
    assert_equal false, @node.is_word
  end

  def test_value_is_nil_by_default
    assert_nil @node.value
  end

  def test_value_doesnt_have_to_be_nil 
    not_nil = Node.new('l')
    
    assert_equal 'l',  not_nil.value
  end

  def test_children_default_empty
    assert_equal ({}), @node.children
  end
end