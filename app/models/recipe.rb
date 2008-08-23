class Recipe < ActiveRecord::Base
has_many :amounts
has_many :ingredients, :through => :amounts

#  def to_param
#    name
#  end

end
