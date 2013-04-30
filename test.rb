require_relative './shimmer.rb'
require 'minitest/autorun'

class ShimmerTest < MiniTest::Unit::TestCase

  def run_program(input)
    s = Shimmer.new
    s.evaluate(s.parse(input))
  end

  def test_define_var_num_1
    input = "(define x 4)"
    assert_equal(4, run_program(input))
  end

  def test_define_var_num_2
    s = Shimmer.new
    input = "(define x 4)"
    s.evaluate(s.parse(input))
    input = "x"
    assert_equal(4, s.evaluate(s.parse(input)))
  end

  def test_quote
    input = "(quote (x + y))"
    assert_equal("(x + y)", run_program(input))
  end

  def test_undefined_variable
    input = "x"
    assert_nil(run_program(input))
  end

  def test_string_literal
    input = "8"
    assert_equal(8, run_program(input))
  end

  def test_addition
    input = "(+ 2 3)"
    assert_equal(5, run_program(input))
  end
end