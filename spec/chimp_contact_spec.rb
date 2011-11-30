require 'nokogiri'

module ChimpContact
  
  class Convertor
    
    def initialize(document)
      @document = document
    end
    
    def convert
      strip_mail_chimp_attributes
      @document
    end
    
    protected
    def strip_mail_chimp_attributes
      @document.xpath('//*').each { |e| e.attributes.each { |k,v| v.remove if k =~ /^mc/ } }
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
end