require 'nokogiri'

module ChimpContact
  
  class Convertor

    COPYRIGHT = [
      'Copyright (c) 1996-2011 Constant Contact. All rights reserved.  Except as permitted under a separate',
      'written agreement with Constant Contact, neither the Constant Contact software, nor any content that appears on any Constant Contact site,',
      'including but not limited to, web pages, newsletters, or templates may be reproduced, republished, repurposed, or distributed without the',
      'prior written permission of Constant Contact.  For inquiries regarding reproduction or distribution of any Constant Contact material, please',
      'contact legal@constantcontact.com.'
    ]
    
    def initialize(document)
      @document = document
    end
    
    def convert
      strip_mail_chimp_attributes
      insert_copyright
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
      body_tag.add_next_sibling(copyright_tag)
    end
  end
end

describe ChimpContact::Convertor do
  
  let :convertor do
    ChimpContact::Convertor.new(Nokogiri::HTML("<a href='#' mc:editable='link'></a>"))
  end

  subject {convertor.convert.to_html}

  it 'should find attributes that start with mc: and remove them' do
    should include('<a href="#"></a>')
  end
  
  it 'should add the copyright tag just after the body tag' do
    should include("<CopyRight>")
  end
end