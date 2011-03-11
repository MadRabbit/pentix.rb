#
# This class handles the game status and things like
# the next figure, the score and so one
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Status
  HEAD_FONT  = ['Courier',     Block::SIZE + 5, Color::GRAY].freeze
  TEXT_FONT  = ['Courier New', Block::SIZE, Color::GRAY].freeze
  TEXT_WIDTH = 22 # chars

  attr_accessor :figure, :pos_x, :pos_y, :level, :lines, :figures, :score

  def initialize(window, x, y)
    @pos_x   = x
    @pos_y   = y

    @head_font  = Font.new(window, HEAD_FONT[0], HEAD_FONT[1])
    @text_font  = Font.new(window, TEXT_FONT[0], TEXT_FONT[1])

    reset!
  end

  def draw
    draw_head "Next:", 0
    @figure.pos_x = @pos_x
    @figure.pos_y = @pos_y + 2
    @figure.draw

    draw_head "Score:",             9
    draw_text "Level",      @level, 10
    draw_text "Score",      @score, 11
    draw_text "Lines",      @lines, 12
    draw_text "Figures",  @figures, 13

    draw_head "Winnars:",           18
    draw_text "Boo hoo!",    10000, 19
    draw_text "Trololo",    999999, 20
    draw_text "Bla bla bla", 44444, 21
  end

  def reset!
    @level   = 0
    @lines   = 0
    @score   = 0
    @figures = 0
  end

private

  def draw_head(text, pos)
    @head_font.draw(
      text,   @pos_x * Block::SIZE,
      (@pos_y + pos) * Block::SIZE - 5, # -5 is to shift the too large font a bit
      0, 1.0, 1.0, HEAD_FONT[2]
    )
  end

  def draw_text(text, value, pos)
    value = "..#{value}"

    @text_font.draw(
      text.ljust(TEXT_WIDTH - value.size, '.') + value,
      @pos_x * Block::SIZE, (@pos_y + pos) * Block::SIZE,
      0, 1.0, 1.0, TEXT_FONT[2]
    )
  end

end