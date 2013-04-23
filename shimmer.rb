require 'minitest/autorun'

class Env
  attr_accessor :context, :parent
  def initialize(parent=nil)
    @parent = parent
    @context = {}
  end
end

class Shimmer
  attr_accessor :global_env
  def initialize
    @global_env = Env.new
  end

  def to_scheme(exp)
    '(' + exp.join(" ") + ')'
  end

  def repl
    while true
      print 'shimmer> '
      val = evaluate(parse(gets.chomp))
      puts "=> #{val}"
    end
  end

  def evaluate(x, env=@global_env)
    ops = [:+, :*, :-, :/]
    if x.nil? || env.nil?
      nil
    elsif x.is_a? Symbol
      if env.context[x]
        env.context[x][0] == :lambda ? "#<procedure>" : env.context[x]
      end
    elsif x.is_a? Numeric
      x
    elsif ops.include? x[0]
      _, *exp = x
      exp.inject(x[0])
    elsif x[0] == :define
      _, var, exp = x
      env.context[var] = evaluate(exp)
    elsif x[0] == :quote
      _, exp = x
      to_scheme(exp)
    elsif x[0] == :lambda
      puts '#<procedure>'
      x
    else
      var, *arg = x
      param = env.context[x[0]][1]
      proc = env.context[x[0]][2]

      new = nil
      param.each do |n|
        new = proc.map do |p|
          p == n ? p = arg[param.index(n)] : p
        end
      end

      evaluate(new)
    end
  end

  def parse(s)
  	read_from(tokenize(s))
  end

  def tokenize(s)
  	s.gsub(/[\(\)]/, '('=>'( ', ')'=>' )').split
  end

  def read_from(tokens)
  	return nil if tokens.length == 0

  	token = tokens.shift

  	if token == '('
  		l = []
      while tokens[0] != ')'
    		l << read_from(tokens)
      end
  		tokens.shift
  		l
  	elsif token == ')'
  		nil
  	else
  		atom(token)
  	end
  end

  def atom(token)
  	Integer token
  rescue ArgumentError
    begin
      Float token
    rescue ArgumentError
      token.to_sym
    end
  end
end

class ShimmerTest < MiniTest::Unit::TestCase
  def test_define_var_num_1
    program = "(define x 4)"
    s = Shimmer.new
    assert_equal(4, s.evaluate(s.parse(program)))
  end

  def test_define_var_num_2
    program = "(define x 4)"
    s = Shimmer.new
    s.evaluate(s.parse(program))
    input = "x"
    assert_equal(4, s.evaluate(s.parse(input)))
  end

  def test_quote
    program = "(quote (x + y))"
    s = Shimmer.new
    assert_equal("(x + y)", s.evaluate(s.parse(program)))
  end

  def test_undefined_variable
    program = "x"
    s = Shimmer.new
    assert_nil(s.evaluate(s.parse(program)))
  end

  def test_string_literal
    program = "8"
    s = Shimmer.new
    assert_equal(8, s.evaluate(s.parse(program)))
  end
end