Puppet::Functions.create_function(:'pulpcore::generate_header_content') do
  dispatch :generate_header_content do
    param 'Variant[String, Array[String]]', :raw_content
    param 'Integer', :line_width
    param 'String', :comment_glyph
    return_type 'Array[String]'
  end

  def generate_header_content(raw_content, line_width, comment_glyph)
    raw_content = [raw_content] unless raw_content.is_a?(Array)
    buffer = comment_glyph * (line_width / comment_glyph.length.to_f.ceil)
    reduced_width = line_width - (2*(1+comment_glyph.length))

    raw_content.map do |text|
      text.scan(/\S.{0,#{reduced_width}}\S(?=\s|$)|\S+/).map do |line|
        "#{comment_glyph} " + line + (" " * (reduced_width - line.length)) + " #{comment_glyph}"
      end.append(buffer)
    end.flatten.prepend(buffer)
  end
end
