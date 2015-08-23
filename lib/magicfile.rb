require 'awesome_print'
require 'active_support'
require 'active_support/core_ext/string'

class MagicLine
  attr_accessor :content, :space_num

  def initialize(content='', space_num=0)
    @content = content
    @space_num = space_num
  end
end

class Magicfile

  def initialize(lines=[], current_line_index=-1, current_line_space_num=-2)
    @lines = lines
    @current_line_index = current_line_index
    @current_line_space_num = current_line_space_num
  end

  def append_class(name, parent_class_name=nil)

    if parent_class_name
      class_start_line = MagicLine.new("class #{name.camelize} < #{parent_class_name}")
    else
      class_start_line = MagicLine.new("class #{name.camelize}")
    end

    append_after_current(class_start_line, true, 2)
    append_after_current(MagicLine.new("end"), false, 0)
  end

  def append_module(name)
    module_start_line = MagicLine.new("module #{name.camelize}")
    module_end_line = MagicLine.new("end")

    append_after_current(module_start_line, true, 2)
    append_after_current(module_end_line, false, 0)
  end

  def append_modules(names)
    names.each do |name|
      append_module(name)
    end
  end

  def append_string_lines(line_contents)
    space_num = @current_line_space_num + 2
    content = line_contents.join("\n" + " " * space_num)
    ap content
    line = MagicLine.new(content, space_num)
    @lines.insert(@current_line_index + 1, line)
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

  def to_file(name)
    infos = @lines.map { |line| " " * line.instance_variable_get("@space_num") + line.instance_variable_get("@content") }
    ap infos.join("\n")
    File.open(name, 'w') { |file| file.write(infos.join("\n")) }
  end

  def display
    @lines.each do |line|
      ap ' ' * line.instance_variable_get("@space_num") + line.instance_variable_get("@content")
    end
  end

end

a = Magicfile.new
a.append_modules(['api', 'v1', 'entities'])
a.append_class('screen', 'Grape::Entity')
a.append_string_lines(['expose :id', 'expose :name'])
a.to_file('tmp.txt')
