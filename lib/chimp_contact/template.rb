module ChimpContact
  
  class Template
    
    def initialize(hominid, template_id)
      @hominid, @template_id = hominid, template_id
    end

    def template_info
      @template_info ||= @hominid.template_info(@template_id)
    end

    def content
      template_info["source"]
    end
    
    def convert_to_inline_css
      @hominid.inline_css(content, true)
    end
  end
end