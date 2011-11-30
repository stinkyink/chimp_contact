require 'nokogiri'

module ChimpContact
  
  class Convertor
    def initialize(document)
      @document = document
    end  
  end
  
  class StripMailChimpAttributes < Convertor
    def convert
      @document.gsub(/mc:.+=["|'].+["|']/, "")
    end
  end
end

describe ChimpContact::StripMailChimpAttributes do
  
  before do
    @smc = ChimpContact::StripMailChimpAttributes.new("<a href='#' mc:editable='link'></a>")
  end

  it 'should find attributes that start with mc: and remove them' do
    @smc.convert.should eql("<a href='#' ></a>")
  end
end