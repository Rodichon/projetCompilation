require 'pp'
require_relative 'parser'
require_relative 'visitor'
require_relative 'prettyPrinter'
require_relative 'lilypondGenerator'

class Compiler

  def initialize h={}
    puts "Lilypon compiler".center(40,'=')
    @parser=Parser.new
  end

  def compile filename
    raise "usage error : Text file needed !" if not filename
    puts "==> compiling #{filename}"
    @ast=@parser.parse(filename)
    sVisit
    pPrinter
    lilyGenerator
  end

  def sVisit
    visitor = Visitor.new
    visitor.doIt(@ast)
  end

  def pPrinter
    pp = PrettyPrinter.new
    pp.pPrint(@ast)
  end

  def lilyGenerator
    lily = LilypondGenerator.new
    str = lily.generate(@ast)

    title = lily.getTitle
    info = " ==> Generation du pdf de " + title + " <=="
    puts info

    pp pdf = "xpdf " + title + ".pdf"
    title << ".ly"

    file = File.open(title, "w+")
    file.write(str)
    file.close

    tst = "lilypond "
    tst << title
    system(tst)

    del = "rm -f " + title
    system(del)

    system(pdf)
  end

end

compiler=Compiler.new
compiler.compile ARGV[0]
