#
# The main game window class
#
# NOTE: all the sizes in the code are _in_blocks_
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Game < Window

  attr_accessor :glass, :status

  def initialize
    super(27 * Block::SIZE, 27 * Block::SIZE, false)
    self.caption = "Pentix"

    @glass    = Glass.new(self,   1, 1)
    @status   = Status.new(self, 16, 1)

    @controls = Controls.new

    reset!

    self.level = 2
  end

  def draw
    @glass.draw
    @status.draw
    @figure.draw
  end

  def update
    if time_to_move
      if @figure.distance > 0
        @figure.move_down
      else
        @figure.drop
      end
    end
  end

  def reset!
    @status.reset!
    @glass.reset!

    show_next_figure
  end

  def level
    @status.level
  end

  def level=(value)
    @status.level = value

    @time_offset = 1000 / level # blocks per second
    @next_time   = 0

    time_to_move
  end

  def button_down(button)
    case @controls.command_for(button)
      when :drop       then @figure.drop
      when :left       then @figure.move_left
      when :right      then @figure.move_right
      when :turn_left  then @figure.turn_left
      when :turn_right then @figure.turn_right
      when :reset      then reset!
      when :quit       then close
    end
  end

  def show_next_figure
    @figure        = @status.figure || Figure.new(self)
    @status.figure = Figure.new(self)

    @figure.move_to((Glass::WIDTH - @figure.size_x)/2 + 2, 1)
  end

  def time_to_move
    if Gosu::milliseconds > @next_time
      @next_time = Gosu::milliseconds + @time_offset
    else
      false
    end
  end

end
