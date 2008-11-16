class SessionsController < ApplicationController
  
  #GET
  def new
    redirect_to 'https://www.google.com/accounts/AuthSubRequest?scope=http%3A%2F%2Fwww.google.com%2Fcalendar%2Ffeeds%2F&session=1&secure=1&next=http%3A%2F%2Fwww.jetfive.com'
  end
  
  #POST
  def create
    @session = Session.new
    
    #get(google_header(url,token))
  end


  def google_header url, token
    time = Time.now.to_i.to_s
    nonce = OpenSSL::BN.rand_range(2**64)
    data = "GET #{url} #{time} #{nonce}"

    key = OpenSSL::PKey::RSA.new(File.read("config/jetkey.pem"))
    sig = key.sign(OpenSSL::Digest::SHA1.new, (data))
    sig = Base64.b64encode(sig).gsub(/\n/, '')

    header = {'Authorization' => "AuthSub token=\"#{token}\" sigalg=\"rsa-sha1\" data=\"#{data}\" sig=\"#{sig}\""}
    header["Content-Type"] = "application/x-www-form-urlencoded"

    return header
  end 

end

 <meta name="verify-v1" content="NmMeXo9TOd80XYsMd6SOjKvJ4+rf7gMEFLV++QehvnM=" />   
