require 'rspec'
require File.join(File.dirname(__FILE__), '..', 'pentix.rb')

# a dummy window class to test the modules separately from the main game
class DummyWindow < Gosu::Window
  attr_accessor :glass, :status

  # converting `.new` into a singleton to avoid memory leaks in Gosu
  def self.new
    @@win ||= super
  end

  def initialize
    super(100, 100, false)
  end

end

#
# Some pretty formatted matrixes handling helpers
#
module MatrixHelper
  def str_to_matrix(str)
    str.scan(/\s*\|(.+?)\|/).map do |line|
      line[0].split('.').map{ |c| c != ' ' }
    end
  end

  def matrix_to_str(matrix)
    matrix.map do |row|
      "|#{row.map{ |c| c ? 'x' : ' '}.join('.')}|"
    end.join("\n          ")
  end

  def draw_matrix(figure)
    block  = actual.instance_variable_get('@block')
    matrix = figure.instance_variable_get('@matrix')
    result = []
    max_x  = 0

    block.class.instance_eval do
      define_method :draw do |x, y|
        x = x - figure.pos_x
        y = y - figure.pos_y

        result[y]  ||= []
        result[y][x] = true
        max_x = x if max_x < x
      end
    end

    figure.draw

    # making the size of the rows even
    result.map do |row|
      (row || []).tap do |row|
        (0..max_x).each do |x|
          row[x] = false unless row[x]
        end
      end
    end
  end

  # making a set of boolean values out of the matrix
  def boolify(matrix)
    matrix.map do |row|
      row.map{ |cell| !!cell}
    end
  end
end

#
# Figures rendering matcher
#
RSpec::Matchers.define :render_blocks do |expected|
  extend MatrixHelper

  match do |actual|
    boolify(draw_matrix(actual)) == boolify(str_to_matrix(expected))
  end

  failure_message_for_should do |actual|
    "expected: #{matrix_to_str(str_to_matrix(expected))}\n\n" \
    "     got: #{matrix_to_str(draw_matrix(actual))}"
  end
end


#
# a readable matrix matcher
#
RSpec::Matchers.define :have_matrix do |expected|
  extend MatrixHelper

  match do |actual|
    boolify(actual.matrix) == boolify(str_to_matrix(expected))
  end

  failure_message_for_should do |actual|
    "expected: #{matrix_to_str(str_to_matrix(expected))}\n\n" \
    "     got: #{matrix_to_str(actual.matrix)}"
  end
end