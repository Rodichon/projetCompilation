require_relative 'ast'

class Visitor

  def initialize
    @indent = 0
  end

  def indent
    @indent += 2
  end

  def desindent
    @indent -= 2
  end

  def doIt ast
    puts "==> Application du visiteur sur l'Ast"
    self.visitTitle(ast,nil)
  end

  def say txt
    puts " "*@indent+txt
  end

  def visitIdentifier(ident, args=nil)
    say "visitIdentifier"
  end

  def visitTitle(title, args=nil)
    say "visitTitle"

    indent
    title.ident.accept(self, args)
    title.key.accept(self, args)
    desindent
  end

  def visitKey(key, args=nil)
    say "visitKey"

    indent
    #key.ident.accept(self, args)
    key.tone.accept(self, args) if key.tone
    key.rythm.accept(self, args) if key.rythm
    key.stmts.accept(self, args) if key.stmts
    desindent
  end

  def visitTone(tone, args=nil)
    say "visitTone"
  end

  def visitRythm(rythm, args=nil)
    say "visitRythm"
  end

  def visitStatementSequence(stmts, args=nil)
    say "visitStatementSequence"

    indent
    stmts.list.each{|li| li.accept(self,nil)}
    desindent
  end

  def visitStatement(stmt, args=nil)
    say "visitStatement"

    indent
    stmt.accept(self, nil)
    desindent
  end

  def visitNolet(nol, args=nil)
    say "visitNolet"

    indent
    nol.stmts.list.each{|li| li.accept(self,nil)}
    desindent
  end

  def visitAccord(acc, args=nil)
    say "visitAccord"

    indent
    acc.note.each{|no| no.accept(self, nil)}
    desindent
  end

  def visitBar(symbol, args=nil)
    say "visitBar"
  end

  def visitNote(note, args=nil)
    say "visitNote"
  end

  def visitPause(pause, args=nil)
    say "visitPause"
  end
end
