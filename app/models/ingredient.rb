class Ingredient < ActiveRecord::Base

has_many :amounts
has_many :recipes, :through => :amounts

end
