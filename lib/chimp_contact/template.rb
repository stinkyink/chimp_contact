module ChimpContact
  
  class Template
    
    def initialize(template_info)
      @template_info = template_info
    end
    
    def self.find(id)
      id = id.gsub(".0", "").to_i
      new(ChimpContact.hominid.template_info(id))
    rescue EOFError
      unless @find_failed
        @find_failed = true
        retry
      end
    end

    def self.all
      ChimpContact.hominid.templates["user"].inject([]) do |result, element|
        result << {:name => element["name"], :id => element["id"]}
        result
      end
    rescue EOFError
      unless @all_failed
        @all_failed = true
        retry
      end
    end

    def content
      @template_info["source"]
    end
    
    def to_inline_css
      ChimpContact.hominid.inline_css(content, true)
    rescue EOFError
      unless @to_inline_css_failed
        @to_inline_css_failed = true
        retry
      end
    end
  end
end