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

describe ChimpContact::StripMailChimpAttributes, "#convert" do
  
  context "with one mc: attribute" do
    it 'should remove mc: attribute from link' do
      @smc = ChimpContact::StripMailChimpAttributes.new("<a href='#' mc:editable='link'></a>")
      @smc.convert.should eql("<a href='#' ></a>")
    end
  end

  context "with multiple mc: attributes" do
    it 'should remove all mc: attributes from link' do
      @smc = ChimpContact::StripMailChimpAttributes.new(
        "<a href='#' mc:hideable='fred' mc:editable='link'></a>"
      )
      @smc.convert.should eql("<a href='#' ></a>")
    end
  end

  context "with multiple tags with multiple mc: attributes" do
    it 'should remove all mc: attributes from all links' do
      @smc = ChimpContact::StripMailChimpAttributes.new(
        ("<a href='#' mc:hideable='fred' mc:editable='link'></a>") * 5
      )
      @smc.convert.should eql("<a href='#' ></a>" * 5)
    end
  end
end