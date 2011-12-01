module ChimpContact
  class Converter

    COPYRIGHT = [
      'Copyright (c) 1996-2011 Constant Contact. All rights reserved.  Except as permitted under a separate',
      'written agreement with Constant Contact, neither the Constant Contact software, nor any content that appears on any Constant Contact site,',
      'including but not limited to, web pages, newsletters, or templates may be reproduced, republished, repurposed, or distributed without the',
      'prior written permission of Constant Contact.  For inquiries regarding reproduction or distribution of any Constant Contact material, please',
      'contact legal@constantcontact.com.'
    ]
    
    def initialize(document, options = {})
      @document = document
      @params   = options["params"] || {}
      @title    = options["title"]  || "Newsletter"
    end
    
    def convert
      strip_mail_chimp_attributes
      insert_copyright
      remove_no_cc
      add_url_parameters
      replace_title
      @document
    end
    
    protected
    def strip_mail_chimp_attributes
      @document.xpath('//*').each { |e| e.attributes.each { |k,v| v.remove if k =~ /^mc/ } }
    end
    
    def insert_copyright
      body_tag = @document.at_xpath('//body')
      copyright_tag = Nokogiri::XML::Node.new("CopyRight", @document)
      copyright_tag.content = COPYRIGHT.join("\n")
      body_tag.children.first.add_previous_sibling(copyright_tag)
    end
    
    def remove_no_cc
      no_cc = @document.css(".no_cc")
      no_cc.remove
    end
    
    def add_url_parameters
      unless @params.empty?
        param_string = @params.inject([]){|result, param| result << "#{param[0]}=#{param[1]}"; result}.join("&")
        @document.xpath('//@href').each { |e| e.value += "?#{param_string}" unless e.value == "" }
      end
    end
    
    def replace_title
      title_tag = @document.at_xpath('//title')
      title_tag.content = @title
    end
  end
end