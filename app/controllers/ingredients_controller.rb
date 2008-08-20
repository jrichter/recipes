class IngredientsController < ApplicationController
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
    @amount = Amount.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ingredient }
    end
  end

  # GET /ingredients/1/edit
  def edit
    @ingredient = Ingredient.find(params[:id])
  end

  # POST /ingredients
  # POST /ingredients.xml
  # This action should check if the ingredient already exists, if it does redirect_to :action => :update, :ingredient => params[:ingredient]...recipe...amount and so on
  def create
    @recipe = Recipe.find(params["recipe"]["id"])
    @ingredient = Ingredient.new(params["ingredient"])
    respond_to do |format|
      if @ingredient.save and Amount.create(params["amount"].merge(:ingredient_id => @ingredient.id, :recipe_id => @recipe.id))
        flash[:notice] = 'Ingredient was successfully created.'
        format.html { redirect_to(@ingredient) }
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
    @recipe = Recipe.find(params["recipe"]["id"])
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


  # DELETE /ingredients/1
  # DELETE /ingredients/1.xml
  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy

    respond_to do |format|
      format.html { redirect_to(ingredient_url) }
      format.xml  { head :ok }
    end
  end
end
