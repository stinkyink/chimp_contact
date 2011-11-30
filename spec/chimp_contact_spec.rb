require File.join(File.dirname(__FILE__), '../lib/chimp_contact.rb')
require 'fakeweb'

def file_fixture(filename)
  open(File.join(File.dirname(__FILE__), 'fixtures', "#{filename.to_s}")).read
end

describe ChimpContact::Template do
  
  before do
    ChimpContact::Template.any_instance.stub(:content).with(file_fixture("template.html"))
    ChimpContact::Template.any_instance.stub(:convert_to_inline_css).with(file_fixture("template_with_inline_css.html"))
  end
  
  let :template do
    ChimpContact::Template.new(
      Hominid::API.new('fred-us2'), 'whatever'
    )
  end
  
  it { true.should eq(true)}
end

describe ChimpContact::Converter do
  
  let :converter do
    ChimpContact::Converter.new(Nokogiri::HTML(%Q{
      <title>shitty mailchimp tag of doob</title>
      <a href="" mc:editable='link'></a>
      <div id='footer' class='no_cc'></div>
      <a href="http://www.google.co.uk"></a>
      <img src="image.jpg">
      <br>
    }), :params => {:param1 => 1, :param2 => 1})
  end

  subject {converter.convert.to_xhtml}

  it 'should find attributes that start with mc: and remove them' do
    should include('<a href=""></a>')
  end
  
  it 'should add the copyright tag just after the body tag' do
    should include("<CopyRight>")
  end
  
  it 'should remove the any element with the .no_cc class' do
    should_not include('<div id="footer" class="no_cc">')
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