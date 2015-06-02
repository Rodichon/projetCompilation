require 'pp'

Token = Struct.new(:kind,:value,:pos)

class Lexer

  def initialize token_hash
    @token_def = token_hash
    @stream = []
    @index = -1
  end

  def next_token str
    @token_def.each do |name,rex|
      str.match /\A#{rex}/
      return Token.new(name,$&) if $&
    end
    raise "Lexing error. no match for #{str}"
  end

  def show_next
    @stream[@index + 1]
  end

  def get_next
    nextTok = @stream[@index + 1]
    @index += 1
    return nextTok
  end

  def look_ahead k
    @stream[@index + k]
  end

  def get_stream
    @stream
  end

  def strip_and_count str
    init=str.size
    ret=str.strip || str
    final=ret.size
    [ret,init-final]
  end

  def tokenize_line numline,str
    stream=[]
    col=1
    while str.size>0
      str,length=strip_and_count(str)
      col+=length
      if str.size>0
        stream << tok=next_token(str)
        tok.pos=[numline,col]
        col+= tok.value.size
        str=str.slice(tok.value.size..-1)
      end
    end
    return stream
  end

  def tokenize str
    stream=[]
    str.split(/\n/).each_with_index do |str,numline|
      stream << tokenize_line(1+numline,str)
    end
    @stream = stream.flatten
  end

  def print_stream
    i = 0
    str = "- - - - - - - - - - - - - - - - - - - - - - - - \n- - - - - - Debut du print stream - - - - - - - \n- - - - - - - - - - - - - - - - - - - - - - - - \n"
    while @stream[i]
      str += " Token : \"#{@stream[i].kind}\" \t Valeur : \"#{@stream[i].value}\" \t Position : \"#{@stream[i].pos}\" \n"
      i += 1
    end
    str += "- - - - - - - - - - - - - - - - - - - - - - - \n- - - - - - Fin du print stream - - - - - - - \n- - - - - - - - - - - - - - - - - - - - - - - \n"
    puts str
  end

end
