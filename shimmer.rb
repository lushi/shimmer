class Env
  attr_accessor :context, :parent
  def initialize(parent=nil)
    @parent = parent
    @context = {}
  end

  def find(var)
    if @context.include? var
      self
    else
      @parent.find(var) unless @parent.nil?
    end
  end
end

class Shimmer
  attr_accessor :global_env
  def initialize
    @global_env = (Env.new)
  end

  def to_scheme(exp)
    case exp
    when TrueClass then '#t'
    when FalseClass then '#f'
    else
      list = ' ('
      exp.each do |n|
        if n.is_a? Array
          list << to_scheme(n)
        else
          list << "#{n.to_s} "
        end
      end
      list << ') '
      list.gsub!(' )', ')').strip!
    end
  end

  def repl
    while true
      print 'shimmer> '
      val = evaluate(parse(gets.chomp))
      puts "=> #{val}"
    end
  end

  def evaluate(x, env=@global_env)
    ops = [:+, :*, :-, :/, :**, :<, :>]
    if x.is_a? Numeric
      x
    elsif x.is_a? Symbol
      env.find(x).context[x] unless env.find(x).nil?
    elsif ops.include? x[0]
      _, exp1, exp2 = x
      evaluate(exp1).send(x[0], evaluate(exp2))
    elsif x == :null
      nil
    elsif x[0] == :quote
      _, exp = x
      to_scheme(exp)
    elsif x[0] == :set! #Not entirely sure this works properly. Need to revisit
      _, var, exp = x
      env.find(var).context[var] = evaluate(exp)
    elsif x[0] == :define
      _, var, exp = x
      env.context[var] = evaluate(exp)
    elsif x[0] == :if
      _, test, conseq, alt = x
      evaluate(test) ? evaluate(conseq) : evaluate(alt)
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
      until tokens[0] == ')'
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