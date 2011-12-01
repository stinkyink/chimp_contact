require 'sinatra/base'
require 'chimp_contact'

module ChimpContact

  class MailChimpError < StandardError;end

  class Dashboard < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/dashboard/views"
    set :public_folder, "#{dir}/dashboard/public"
    
    error MailChimpError do
      'Mailchimp failed to respond, please try refreshing your browser'
    end
    
    get "/" do
      begin
        @templates = Template.all
      rescue
        raise MailChimpError
      end  
      erb :index
    end
    
    post "/" do
      begin
        html = Template.find(params["template_id"]).to_inline_css
        @result = Converter.new(Nokogiri::HTML(html), params).convert.to_xhtml
      rescue
        raise MailChimpError
      end
      erb :show
    end
  end  
end