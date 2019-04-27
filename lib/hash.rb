require 'base64'
require 'cgi'
require 'openssl'

module Sha1
    def get_sha1(base)
        key = 'Jvv4ZyC3IS.LBQp'
        sha1 = Base64.encode64("#{OpenSSL::HMAC.digest('sha1',key,base)}")
        puts sha1
        return sha1
    end
end

