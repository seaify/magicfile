require 'awesome_print'
require 'active_support'
require 'active_support/core_ext/string'


class Magicfile

  class MagicLine
    def initialize(content='', parent_line_index=-1, space_num=0)
      @content = content
      @parent_line_index = parent_line_index
      @space_num = space_num
      @index = -1
    end
  end

  def initialize(lines=[], current_line=nil)
    @lines = lines
    @current_line = current_line
  end

  def append_module(name, before_line=@current_line)
    if @lines.length == 0
      @lines = [MagicLine.new("module #{name.camelize}"), MagicLine.new("end")]
    else
      @lines.insert(@current_line.index, MagicLine.new("module #{name.camelize}"))
    end
  end

  def display
    @lines.each do |line|
      ap line
    end
  end

  def self.hi
    puts "Hello world!"
  end
end

a = Magicfile.new
ap a
a.append_module('api')
a.append_module('v1')
a.display
