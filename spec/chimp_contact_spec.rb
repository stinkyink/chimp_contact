module ChimpContact
  
  class StripMailChimpAttributes
    
    def initialize(document)
      @document = document
    end
    
    def perform
    end
  end
end

describe ChimpContact::StripMailChimpAttributes do

  it 'should find attributes that start with mc: and strip them'
  
end