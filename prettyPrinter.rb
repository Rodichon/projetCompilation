require_relative 'ast'
require 'pp'

class PrettyPrinter

  def initialize
    @code = ""
  end

  def pPrint ast
    puts "\n ==> Application du prettyPrinter sur l'ast <=="
    self.pPrintTitle(ast,nil)
    puts @code
  end

  def pPrintTitle(title,args=nil)

    @code << "Titre "
    title.ident.accept(self, nil)
    @code << "\n \n"
    title.key.accept(self, args)
    @code << "\n "
  end

  def pPrintIdentifier(ident, args=nil)
    @code << ident.name.value
  end

  def pPrintKey(key, args=nil)

    @code << key.ident.value + " "
    key.tone.accept(self, args) if key.tone
    @code << " "
    key.rythm.accept(self, args) if key.rythm
    @code << "\n"
    key.stmts.accept(self, args) if key.stmts
  end

  def pPrintTone(tone, args=nil)

    for i in (0..tone.tone.size-1)
      @code << tone.tone[i].value
    end
  end

  def pPrintRythm(rythm, args=nil)

    for i in (0..rythm.digits.size-1)
      @code << rythm.digits[i].value + " "
    end
  end

  def pPrintStatementSequence(stmts, args=nil)
    @code << "{ "
    stmts.list.each{|li| li.accept(self,nil)}
    @code << "} "
  end

  def pPrintStatement(stmt, args=nil)

    stmt.accept(self, nil)
  end

  def pPrintNolet(nol, args=nil)

    @code << "\\nolet "
    @code << nol.duration[0].value + "\\" + nol.duration[1].value + " "
    nol.stmts.accept(self, nil)
  end

  def pPrintAccord(acc, args=nil)
    if !acc.duration
      duration = ""
    else
      duration = acc.duration.value
    end

    @code << "<"
    acc.note.each{|no| no.accept(self, nil)}
    @code <<">" + duration
  end

  def pPrintBar(bar, args=nil)
    @code << "\\bar "
    for i in (0..bar.symbol.size-1)
      @code << bar.symbol[i].value
    end
    @code << " "
  end

  def pPrintPause(pause, args=nil)
    @code << "\\p" + pause.duration.value + " "
  end

  def pPrintNote(note, args=nil)

    for i in (0..note.tone.size-1)
      @code << note.tone[i].value
    end
    @code << note.note.value
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
end
