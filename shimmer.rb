class Shimmer
  def initialize
    @env = {}
  end

  def repl
    while true
      print 'shimmer> '
      val = eval(parse(gets.chomp))
      puts "=> #{val.nil? ? 'null' : @env.values[0]}"
    end
  end

  def eval(x)
    if x.nil?
      nil
    elsif x.is_a? Symbol
      @env[x]
    elsif x.is_a? Numeric
      x
    elsif x[0] == :define
      _, var, exp = x
      @env[var] = eval(exp)
    end
  end

  def parse(s)
    read(s)
  end

  def read(s)
  	read_from(tokenize(s))
  end

  def tokenize(s)
  	s.gsub(/[\(\)]/, '('=>'( ', ')'=>' )').split
  end

  def read_from(tokens)
  	nil if tokens.length == 0

  	token = tokens.shift

  	if token == '('
  		l = []
  		l << read_from(tokens) while tokens[0] != ')'
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

Shimmer.new.repl