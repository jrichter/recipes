require 'digest/sha2'

class User < ActiveRecord::Base

attr_reader :password
 
  ENCRYPT = Digest::SHA256
 
  has_many :sessions, :dependent => :destroy
 
  validates_uniqueness_of :login, :message => "is already in use by another user"
 
  validates_format_of :login, :with => /^([a-z0-9_]{2,16})$/i,
                      :message => "must be 4 to 16 letters, numbers or underscores and have no spaces"
 
  validates_format_of :password, :with => /^([\x20-\x7E]){4,16}$/,
                      :message => "must be 4 to 16 characters",
                      :unless => :password_is_not_being_updated?
 
  validates_confirmation_of :password
 
  before_save :scrub_login
  after_save :flush_passwords
 
  def self.find_by_login_and_password(login, password)
    user = self.find_by_login(login)
    
    if user and user.encrypted_password == ENCRYPT.hexdigest(password + user.salt)
      return user
    end
  end
 
  def password=(password)
    @password = password
    unless password_is_not_being_updated?
      self.salt = [Array.new(9){rand(256).chr}.join].pack('m').chomp
      self.encrypted_password = ENCRYPT.hexdigest(password + self.salt)
    end
  end
 
 
  private
 
  def scrub_login
    self.login.downcase!
  end
 
  def flush_passwords
    if @password
      @password = @password_confirmation = nil
    end
  end
 
  def password_is_not_being_updated?
    if self.id and self.password.blank?
      return true
    else
      return false
    end
  end  

end
