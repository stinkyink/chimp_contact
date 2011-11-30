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
    
    def initialize(document, options = {})
      @document = document
      @params   = options[:params] || {}
      @title    = options[:title]  || "Newsletter"
    end
    
    def convert
      strip_mail_chimp_attributes
      insert_copyright
      remove_footer
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
      body_tag.add_next_sibling(copyright_tag)
    end
    
    def remove_footer
      footer = @document.css("#footer")
      footer.remove
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

describe ChimpContact::Convertor do
  
  let :convertor do
    ChimpContact::Convertor.new(Nokogiri::HTML(%Q{
      <title>shitty mailchimp tag of doob</title>
      <a href="" mc:editable='link'></a>
      <div id='footer'></div>
      <a href="http://www.google.co.uk"></a>
      <img src="image.jpg">
      <br>
    }), :params => {:param1 => 1, :param2 => 1})
  end

  subject {convertor.convert.to_xhtml}

  it 'should find attributes that start with mc: and remove them' do
    should include('<a href=""></a>')
  end
  
  it 'should add the copyright tag just after the body tag' do
    should include("<CopyRight>")
  end
  
  it 'should remove the footer div' do
    should_not include('<div id="footer">')
  end
  
  it 'should add ?param1=1&param2=1 to the end of all urls' do
    should include('<a href="http://www.google.co.uk?param1=1&amp;param2=1"></a>')
  end
  
  it 'should replace the title tag' do
    should include('<title>Newsletter</title>')
  end

  context "converting to XHTML" do
    it 'should close img tags' do
      should include('<img src="image.jpg" />')
    end

    it 'should close all br tags' do
      should include('<br />')
    end
  end
end