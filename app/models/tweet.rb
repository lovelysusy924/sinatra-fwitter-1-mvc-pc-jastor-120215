class Tweet
    
    ALL_TWEETS = []
    attr_accessor :username; :status
    
    def initialize(username, status)
        @username = username
        @status = status
        # ALL_TWEETS << self
    end
    
    #instead of ALL_TWEETS << SELF, WE CAN USE THIS:
    def self.all
        ALL_TWEETS
    end
    
    
end

# ex: astors_new_tweet = Tweet.new ('@astorology', 'living the thug life is easy when youre beautiful)