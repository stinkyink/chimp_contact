require 'nokogiri'

module ChimpContact
  
  class Convertor
    def initialize(document)
      @document = document
    end  
  end
  
  class StripMailChimpAttributes < Convertor
    def run
      @document.xpath('//*').each { |e| e.attributes.each { |k,v| v.remove if k =~ /^mc/ } }
      @document
    end
  end
end

describe ChimpContact::StripMailChimpAttributes do
  
  let :strip_mail_chimp_attributes do
    ChimpContact::StripMailChimpAttributes.new(
      Nokogiri::HTML("<a href='#' mc:editable='link'></a>")
    )
  end

  it 'should find attributes that start with mc: and remove them' do
    strip_mail_chimp_attributes.run.to_html.should include('<a href="#"></a>')
  end
end