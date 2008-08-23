class AmountsController < ApplicationController

before_filter :load_recipe_ingredient

  # DELETE /amounts/1
  # DELETE /amounts/1.xml
  # This will also delete an ingredient if it is no longer attached to any recipes
  def destroy
    @amount = Amount.find(:first, :conditions => {:recipe_id => @recipe, :ingredient_id => @ingredient})
    @amount.destroy
    @ingredient.destroy if @ingredient.recipes.length == 0

    respond_to do |format|
      format.html { redirect_to(@recipe) }
      format.xml  { head :ok }
    end
  end

  def load_recipe_ingredient
    @recipe = Recipe.find(params[:recipe_id])
    @ingredient = Ingredient.find(params[:ingredient_id])
  
  end

end
