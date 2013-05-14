module GHRH
  class Auth
    def self.perform(user, pass)
      GHRH::Client.basic_auth user, pass
      body = GHRH::Client.post('/authorizations',
                               { :body => {:scopes => %w{public_repo repo},
                                 :note => 'ghrh',
                                 :note_url => 'https://github.com/r4um/ghrh'}.to_json})
      token = body['token']
    end
  end
end
