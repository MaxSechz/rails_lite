require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @req = req
      @route_params = route_params
      @params = parse_www_encoded_form(@req.query_string || '')
      @params.merge!(parse_www_encoded_form(@req.body || ''))
      @params.merge!(route_params)
    end

    def [](key)
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      params_hash = URI.decode_www_form(www_encoded_form).to_h
      real_hash = {}

      params_hash.each do |key, value|
        parsed_keys = parse_key(key)
        temp_hash = real_hash

        parsed_keys.each_with_index do |key, index|
          next temp_hash = temp_hash[key] if !temp_hash[key].nil?
          temp_hash[key]=  index+1 == parsed_keys.count ? value : {}
          temp_hash = temp_hash[key]
        end
      end

    real_hash
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
