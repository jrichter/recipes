class Session < ActiveRecord::Base


  attr_accessor :login, :password, :match

  belongs_to :user
 
  before_validation :authenticate
 
  validates_presence_of :match, :message => 'for your login and password could not be found',
                                :unless => :session_has_been_associated?
 
  before_save :associate_session_to_user
 
  
  def authenticate
    if login == nil
      login = ""
      password = ""
    end
    authenticate_user unless session_has_been_associated?
  end
  
 
 private  
  def authenticate_user
    self.match = User.find_by_login_and_password(self.login, self.password) unless session_has_been_associated?
  end
 
  def associate_session_to_user
    self.user_id ||= self.match.id
  end
 
  def session_has_been_associated?
    self.user_id
  end


end
