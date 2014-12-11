require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @req = req
      cookie = @req.cookies.find {|cookie| cookie.name == '_rails_lite_app'}
      value= cookie.nil? ? {} : JSON.parse(cookie.value)
      @cookie = WEBrick::Cookie.new('_rails_lite_app', value)
    end

    def [](key)
      @cookie.value[key]
    end

    def []=(key, val)
      @cookie.value[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie = WEBrick::Cookie.new(@cookie.name, @cookie.value.to_json)
      res.cookies << cookie
    end
  end
end
