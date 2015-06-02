require_relative 'ast'
require 'pp'

class LilypondGenerator

  def initialize
    @code = ""
    @title = ""
  end

  def generate ast
    puts "\n ==> Generation du code Lilypond de l'Ast <=="
    self.generateTitle(ast,nil)
    puts @code
    return @code
  end

  def getTitle
    return @title
  end

  def generateTitle(title,args=nil)

    @code << "\\version \"2.18.2\"\n"
    @code << "\\header{ \n \t title = \""
    @title = title.ident.name.value
    title.ident.accept(self, nil)
    @code << " \" \n} \n \n"
    title.key.accept(self, args)
    @code << "\n "
  end

  def generateIdentifier(ident, args=nil)
    @code << ident.name.value
  end

  def generateKey(key, args=nil)
    @code << "{ \n"
    #@code << key.ident.value + " "
    #key.tone.accept(self, args) if key.tone
    #@code << " "
    key.rythm.accept(self, args) if key.rythm
    #@code << "\n"
    key.stmts.accept(self, args) if key.stmts
  end

  def generateTone(tone, args=nil)

    for i in (0..tone.tone.size-1)
      @code << tone.tone[i].value
    end
  end

  def generateRythm(rythm, args=nil)
    @code << "\\"+"time "
    for i in (0..rythm.digits.size-1)
      @code << rythm.digits[i].value
      @code << "/" if i==0
    end
    @code << "\n"
  end

  def generateStatementSequence(stmts, args=nil)
    #@code << "{ "
    stmts.list.each{|li| li.accept(self,nil)}
    @code << "} "
  end

  def generateStatement(stmt, args=nil)

    stmt.accept(self, nil)
  end

  def generateNolet(nol, args=nil)

    @code << "\\tuplet "
    @code << nol.duration[0].value + "\/" + nol.duration[1].value + " { "
    nol.stmts.accept(self, nil)
  end

  def generateAccord(acc, args=nil)
    if !acc.duration
      duration = " "
    else
      duration = acc.duration.value
    end

    @code << "<"
    acc.note.each{|no| no.accept(self, nil)}
    @code <<">" + duration
  end

  def generateBar(bar, args=nil)
    @code << "\\bar \""
    for i in (0..bar.symbol.size-1)
      @code << bar.symbol[i].value
    end
    @code << "\" "
  end

  def generatePause(pause, args=nil)
    @code << "r" + pause.duration.value + " "
  end

  def generateNote(note, args=nil)

    @code << trans(note.note.value)

    for i in (0..note.tone.size-1)
      if note.tone[i].value == "b"
        @code << "es"
      elsif note.tone[i].value == "d"
        @code << "is"
      end
    end

    for i in (0..note.height.size-1)
      @code << note.height[i].value[0]
    end

    if note.duration
      @code << note.duration.value
    end

    for i in (0..note.symbol.size-1)
      @code << note.symbol[i].value[0]
    end
    @code << " "
  end

  def trans str
    switch case str
    when "do"
      return "c"
    when "re"
      return "d"
    when "mi"
      return "e"
    when "fa"
      return "f"
    when "sol"
      return "g"
    when "la"
      return "a"
    when "si"
      return "b"
    end
  end
end
