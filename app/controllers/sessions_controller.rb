require 'net/http'
require 'net/https'
class SessionsController < ApplicationController
  
  #GET
  def new
    @session = Session.new
  end
  
  #POST
  def create
    @session = Session.new
  end

  def login
    if params[:token]
      token = params[:token] 

      http = Net::HTTP.new('www.google.com', 443)
      http.use_ssl = true
      path = '/accounts/AuthSubTokenInfo'
      full_path = 'https://www.google.com' + path
      headers = google_header(full_path, token)

      resp, data = http.get(path, headers)

      @header = headers
      @code =  'Code = ' + resp.code
      @msg =  'Message = ' + resp.message
      @data = data
      @token = token
      
      if resp.message == "OK"
        @session = Session.new(:ip_addr => request.remote_addr, :logged_in => true)
      else
        flash[:notice] = "Something failed with Google authentication."
      end
    else
      redirect_to 'https://www.google.com/accounts/AuthSubRequest?next=http%3A%2F%2Fwww.jetfive.com%2Flogin&scope=http%3A%2F%2Fwww.google.com%2Fcalendar%2Ffeeds%2F&session=1&secure=1'    
    end
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
