require 'awesome_print'
require 'active_support'
require 'active_support/core_ext/string'

class MagicLine
  attr_accessor :content, :parent_line_index, :space_num

  def initialize(content='', parent_line_index=-1, space_num=0)
    @content = content
    @parent_line_index = parent_line_index
    @space_num = space_num
  end
end

class Magicfile

  def initialize(lines=[], current_line_index=-1, current_line_space_num=-2)
    @lines = lines
    @current_line_index = current_line_index
    @current_line_space_num = current_line_space_num
  end

  def append_module(name)
    module_start_line = MagicLine.new("module #{name.camelize}")
    module_end_line = MagicLine.new("end")

    append_after_current(module_start_line, true, 2)
    append_after_current(module_end_line, false, 0)
  end

  def append_after_current(line, enable_move_down=true, spaces=2)


    line.space_num = @current_line_space_num + spaces
    @lines.insert(@current_line_index + 1, line)


    if enable_move_down
      @current_line_space_num = line.space_num
      @current_line_index += 1
    end

    ap "after start======"
    ap @lines
    ap @current_line_index
    ap @current_line_space_num
    ap "end======"

  end

  def display
    @lines.each do |line|
      ap ' ' * line.instance_variable_get("@space_num") + line.instance_variable_get("@content")
    end
  end

end

a = Magicfile.new
ap a
a.append_module('api')
a.display

a.append_module('v1')
a.display

ap a.instance_variable_get("@lines")
