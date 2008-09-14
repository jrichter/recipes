class Recipe < ActiveRecord::Base
has_many :amounts
has_many :ingredients, :through => :amounts

in_place_editable_columns :recipe, :name
in_place_editable_columns :recipe, :author
in_place_editable_columns :recipe, :oven_temp
in_place_editable_columns :recipe, :directions

#  def to_param
#    name
#  end

end
