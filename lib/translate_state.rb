class TranslateState
  def initialize(options = {})
    @replacement = options[:replacement].nil? || options[:replacement]
    @glossary    = options[:glossary].nil? || options[:glossary]

    @replacement = false if @replacement == 'false'
    @glossary    = false if @glossary == 'false'
  end

  def self.replacement(str)
    return str if Tooltip.count == 0

    Tooltip.where(:replacement => true).order(:slug => :desc).each do |tooltip|
      tooltip.slug.gsub(', ', ',').split(',').each do |slug|
        str = patterned_templater str, slug, tooltip.body, true
      end
    end

    str
  end

  def self.glossary(str)
    return str if Tooltip.count == 0

    Tooltip.where(:replacement => false).order(:slug => :desc).each do |tooltip|
      tooltip.slug.gsub(', ', ',').split(',').each do |slug|
        tmp = str.clone

        str = patterned_templater str, slug, "<span class='tooltiped'  title='#{tooltip.body}'>#{slug}</span>", false

        break if tmp != str
      end
    end

    str
  end

  def replacement?
    @replacement
  end

  def glossary?
    @glossary
  end

  def self.patterned_templater(str, key, template, all = true)
    return str if str.length == 0

    positions = []

    str.to_enum(:scan, /\b(#{Regexp.quote key})\b/u).map do |m,|
      positions.push $`.size
    end

    positions.each do |i|
      if i == 0 || !['">', "'>"].include?(str[i-1]) && str[i + key.length, 3] != '</s'
        str[i..(i + key.length - 1)] = template

        return str unless all
      end
    end

    str
  end
end
