require 'pp'
require_relative 'lexer'
require_relative 'ast'

TOKENS_DEF = {
  # - - - - - Punctuation - - - - -
  :dot          => /\./,
  :up           => /\'/,
  :down         => /,/,
  :colon        => /:/,
  :semicolon    => /;/,
  :lParen       => /\(/,
  :rParen       => /\)/,
  :lCro         => /\[/,
  :rCro         => /\]/,
  :lAcc         => /{/,
  :rAcc         => /}/,
  :tilde        => /~/,
  :slash        => /\//,
  :vBar         => /\|/,
  :accL         => /\</,
  :accR         => /\>/,

  :do           => /do/,
  :re           => /re/,
  :mi           => /mi/,
  :fa           => /fa/,
  :sol          => /sol/,
  :la           => /la/,
  :si           => /si/,

  :title        => /\\titre/,

  :bar          => /\\bar/,
  :nolet        => /\\nolet/,

  :bemol        => /b/,
  :diese        => /d/,
  :pause        => /\\p/,

  :digits       => /\d+/,
  :comments     => /#(.*)$/,
  :identifier   => /[a-zA-Z]\w*/,

}

class Parser

  attr_accessor :lexer

  def initialize
    @lexer = Lexer.new(TOKENS_DEF)
  end

  def parse filename
    str = IO.read(filename)
    @lexer.tokenize(str)
    @lexer.print_stream

    parseTitle
  end

  def expect token_kind
    next_tok = @lexer.get_next
    if next_tok.kind != token_kind
      puts "expecting #{token_kind}. Got #{next_tok.kind}"
      raise "parsing error on line #{next_tok.pos.first}"
    end
  end

  def showNext
    @lexer.show_next
  end

  def acceptIt
    @lexer.get_next
  end

  def isNoteNext
    if (showNext.kind == :do || showNext.kind == :re || showNext.kind == :mi || showNext.kind == :fa ||
      showNext.kind == :sol || showNext.kind == :la || showNext.kind == :si)
      return true
    else
      return false
    end
  end

  # - - - - Fonctions du Parser - - - - #
  def parseTitle
    puts "parseTitle"

    expect :title
    title = Title.new
    title.ident = Identifier.new(acceptIt)
    title.key = parseKey()
    return title
  end

  def parseKey
    puts "parseKey"

    if (showNext.kind == :sol || showNext.kind == :fa)
      key = Key.new
      key.ident = acceptIt

      if showNext.kind == :bemol || :diese
        key.tone = parseTone()
      end

      if showNext.kind == :digits
        key.rythm = parseRythm()
      end

      key.stmts = parseStatementSequence()

    end

    return key
  end

  def parseTone
    puts "parseTone"
    tone = Tone.new
    while (showNext.kind == :bemol || showNext.kind == :diese)
      tone.tone << acceptIt
    end
    return tone
  end

  def parseRythm
    puts "parseRythm"
    rythm = Rythm.new
    while showNext.kind == :digits
      rythm.digits << acceptIt
    end
    return rythm
  end

  def parseStatementSequence
    puts "parseStatementSequence"
    stmts = StatementSequence.new
    expect :lAcc
    while (showNext.kind != :rAcc)
      stmts.list << parseStatement
    end
    expect :rAcc
    return stmts
  end

  def parseStatement
    puts "parseStatement"
    stmt = Statement.new
    if (showNext.kind == :bemol || showNext.kind == :diese || isNoteNext)
      stmt = parseNote
    elsif  showNext.kind == :nolet
      stmt = parseNolet
    elsif showNext.kind == :bar
      stmt = parseBar
    elsif showNext.kind == :pause
      stmt = parsePause
    elsif showNext.kind == :accL
      stmt = parseAccord
    end
    return stmt
  end

  def parseNolet
    puts "parseNolet"
    nol = Nolet.new
    expect(:nolet)
    nol.duration << acceptIt
    expect(:slash)
    nol.duration << acceptIt
    nol.stmts = parseStatementSequence
    return nol
  end

  def parseAccord
    puts "parseAccord"
    acc = Accord.new
    expect(:accL)
    while (showNext.kind ==:bemol || showNext.kind ==:diese || isNoteNext)
      acc.note << parseNote
    end
    expect(:accR)

    if showNext.kind == :digits
      acc.duration = acceptIt
    end
    return acc
  end

  def parseBar
    puts "parseBar"
    bar = Bar.new
    expect(:bar)
    while (showNext.kind == :vBar || showNext.kind == :dot)
      bar.symbol << acceptIt
    end
    return bar
  end

  def parsePause
    puts "parsePause"
    pause = Pause.new
    expect(:pause)
    if showNext.kind == :digits
      pause.duration = acceptIt
    else
      pause.duration == 1
    end
    return pause
  end

  def parseNote
    puts "parseNote"
    note = Note.new

    if showNext.kind == :bemol
      while showNext.kind == :bemol
        note.tone << acceptIt
      end
    elsif showNext.kind == :diese
      while showNext.kind == :diese
        note.tone << acceptIt
      end
    end

    if isNoteNext
      note.note = acceptIt
    end

    if showNext.kind == :up
      while showNext.kind == :up
        note.height << acceptIt
      end
    elsif showNext.kind == :down
      while showNext.kind == :down
        note.height << acceptIt
      end
    end

    if showNext.kind == :digits
      note.duration = acceptIt
    end

    if showNext.kind == :dot
      while showNext.kind == :dot
        note.symbol << acceptIt
      end
    elsif showNext.kind == :tilde
      while showNext.kind == :tilde
        note.symbol << acceptIt
      end
    end

    return note
  end

end
