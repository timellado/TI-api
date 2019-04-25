require 'base64'
require 'cgi'
require 'openssl'

base = String('GET534960ccc88ee69029cd3fb2')
key = String('acbd12345')

puts CGI.escape(Base64.encode64("#{OpenSSL::HMAC.digest('sha1',key,base)}\n"))
