class Ast
  def accept(visitor, arg=nil)
    name = self.class.name.split(/::/)[0]
    if visitor.class == PrettyPrinter
      visitor.send("pPrint#{name}".to_sym, self ,arg)
    elsif visitor.class == Visitor
      visitor.send("visit#{name}".to_sym, self ,arg)
    elsif visitor.class == LilypondGenerator
      visitor.send("generate#{name}".to_sym, self ,arg)
    end
  end
end

class Identifier < Ast
  attr_accessor :name
  def initialize name=nil
    @name=name
  end

  def to_s
    @name.value
  end
end

class Title < Ast
  attr_accessor :ident, :key
  def initialize ident=nil, key=nil
    @ident, @key = ident, key
  end
end

class Key < Ast
  attr_accessor :ident, :tone, :rythm, :stmts
  def initialize ident=nil, tone=nil, rythm = [], stmts=nil
    @ident, @tone, @rythm, @stmts = ident, tone, rythm, stmts
  end
end

class Tone < Key
  attr_accessor :tone
  def initialize tone = []
    @tone = tone
  end
end

class Rythm < Key
  attr_accessor :digits
  def initialize digits=[]
    @digits = digits
  end
end

class StatementSequence < Ast
  attr_accessor :list
  def initialize list=[]
    @list = list
  end

  def each &block
    list.each(&block)
  end
end

class Statement < Ast
end

class Nolet < Statement
  attr_accessor :name, :duration, :stmts
  def initialize name=nil, duration=[], stmts=nil
    @name, @duration, @stmts = name, duration, stmts
  end
end

class Accord < Statement
  attr_accessor :note, :duration
  def initialize note=[], duration=nil
    @note, @duration = note, duration
  end
end

class Bar < Statement
  attr_accessor :symbol
  def initialize symbol=[]
    @symbol = symbol
  end
end

class Note < Statement
  attr_accessor :note, :tone, :height, :symbol, :duration
  def initialize note=nil, tone=[], height = [], symbol = [], duration=nil
    @note, @tone, @height, @symbol, @duration = note, tone, height, symbol, duration
  end
end

class Pause < Statement
  attr_accessor :duration
  def initialize duration=nil
    @duration = duration
  end
end
