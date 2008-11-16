require 'net/http'
require 'net/https'
class SessionsController < ApplicationController
  
  #GET
  def new
#    redirect_to 'https://www.google.com/accounts/AuthSubRequest?scope=http%3A%2F%2Fwww.google.com%2Fcalendar%2Ffeeds%2F&session=1&secure=1&next=http%3A%2F%2Fwww.jetfive.com/login'
    redirect_to 'https://www.google.com/accounts/AuthSubRequest?next=http%3A%2F%2Fwww.jetfive.com%2Flogin&scope=http%3A%2F%2Fwww.google.com%2Fcalendar%2Ffeeds%2F&session=1&secure=1'
    
  end
  
  #POST
  def create
    @session = Session.new
  end

  def login
    token = params[:token] 

    http = Net::HTTP.new('www.google.com', 443)
    http.use_ssl = true
    path = '/accounts/AuthSubTokenInfo'

    headers = google_header('www.jetfive.com', token)

    resp, data = http.get(path, headers)

    @header = headers
    @code =  'Code = ' + resp.code
    @msg =  'Message = ' + resp.message
    @data = data
    @token = token
  end

  def google_header url, token
    time = Time.now.to_i.to_s
    nonce = OpenSSL::BN.rand_range(2**64)
    data = "GET #{url} #{time} #{nonce}"

    key = OpenSSL::PKey::RSA.new(File.read("#{RAILS_ROOT}/config/jetrsakey.pem"))
    sig = key.sign(OpenSSL::Digest::SHA1.new, (data))
    sig = Base64.b64encode(sig).gsub(/\n/, '')

    header = {'Authorization' => "AuthSub token=\"#{token}\" sigalg=\"rsa-sha1\" data=\"#{data}\" sig=\"#{sig}\""}
    header["Content-Type"] = "application/x-www-form-urlencoded"

    return header
  end 

end
