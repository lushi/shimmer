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
    input1 = "(define x 4)"
    s.evaluate(s.parse(input1))
    input2 = "x"
    assert_equal(4, s.evaluate(s.parse(input2)))
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

  def test_multiplication
    input = "(* 2 3)"
    assert_equal(6, run_program(input))
  end

  def test_subtraction
    input = "(- 3 2)"
    assert_equal(1, run_program(input))
  end

  def test_division
    input = "(/ 3 2)"
    assert_equal(1, run_program(input))
  end

  def test_exponent
    input = "(** 3 2)"
    assert_equal(9, run_program(input))
  end

  def test_lambda
    s = Shimmer.new
    input1 = "(define sum (lambda (a b) (+ a b)))"
    s.evaluate(s.parse(input1))
    input2 = "(sum 2 3)"
    assert_equal(5, s.evaluate(s.parse(input2)))
  end
end