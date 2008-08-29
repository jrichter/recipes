class IngredientsController < ApplicationController

before_filter :load_recipe, :except => [:index, :show, :destroy]
auto_complete_for :ingredient, :name

  # GET /ingredients
  # GET /ingredients.xml
  def index
    @ingredients = Ingredient.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ingredients}
    end
  end

  # GET /ingredients/1
  # GET /ingredients/1.xml
  def show
    @ingredient = Ingredient.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ingredient }
    end
  end

  # GET /ingredients/new
  # GET /ingredients/new.xml
  def new
    @ingredient = Ingredient.new  
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ingredient }
    end
  end

  # GET /ingredients/1/edit
  def edit
    @ingredient = Ingredient.find(params[:id])
    @amount= @ingredient.amounts.find_by_recipe_id(@recipe)
  end

  # POST /ingredients
  # POST /ingredients.xml
  # This action checks to see if an ingredient exists, if so it uses that ingredient
  # and links the ingredient to the recipe with the amount
  def create

    @ingredient = Ingredient.find_by_name(params["ingredient"]["name"]) || Ingredient.new(params["ingredient"])
    respond_to do |format|
      if @ingredient.save and Amount.create(params["amount"].merge(:ingredient_id => @ingredient.id, :recipe_id => @recipe.id))
        flash[:notice] = 'Ingredient was successfully created.'
        format.html { redirect_to(@recipe) }
        format.xml  { render :xml => @ingredient, :status => :created, :location => @ingredient }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ingredient.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ingredients/1
  # PUT /ingredients/1.xml
  def update
    @ingredient = Ingredient.find(params[:id])
    @amount = Amount.find(@ingredient)

    respond_to do |format|
      if @ingredient.update_attributes(params[:ingredient]) and @amount.update_attributes(params["amount"].merge(:ingredient_id => @ingredient.id, :recipe_id => @recipe.id ))
        flash[:notice] = 'Ingredient was successfully updated.'
        format.html { redirect_to(@recipe) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ingredient.errors, :status => :unprocessable_entity }
      end
    end
  end

  def load_recipe
    if params[:recipe_id]
      @recipe = Recipe.find(params[:recipe_id])
    end
  end

  # DELETE /ingredients/1
  # DELETE /ingredients/1.xml
  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy

    respond_to do |format|
      format.html { redirect_to(ingredients_url) }
      format.xml  { head :ok }
    end
  end
end
