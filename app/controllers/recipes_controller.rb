class RecipesController < ApplicationController
in_place_edit_for :recipe, :in_place_name
in_place_edit_for :recipe, :in_place_author
in_place_edit_for :recipe, :in_place_directions
in_place_edit_for :recipe, :in_place_oven_temp
in_place_edit_for :recipe, :in_place_picture_url
in_place_edit_for :amount, :in_place_ing_amnt
in_place_edit_for :amount, :in_place_ing_group

before_filter :ensure_login, :except => [:index, :show]
  def set_amount_ing_amnt
    @item = Amount.find(params[:id])
    @item.update_attribute(:ing_amnt, params[:value])
    render :text => @item.send(:ing_amnt).to_s
  end

  def set_amount_ing_group
    @item = Amount.find(params[:id])
    @item.update_attribute(:ing_group, params[:value])
    render :text => @item.send(:ing_group).to_s
  end

  # GET /recipes
  # GET /recipes.xml
  def index
    options = {
      :order => 'name DESC'
    }
   if params[:term]
     options[:conditions] = [
     "name LIKE :term OR directions LIKE :term OR author LIKE :term",
     {:term => "%#{params[:term]}%"}
      ] 
   end
    @ingredients = Ingredient.find(:all)
    @recipes = Recipe.find(:all, options)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recipes }
    end
  end

  # GET /recipes/1
  # GET /recipes/1.xml
  def show
#    @recipe = Recipe.find_by_name(params[:id])
     @recipe = Recipe.find(params[:id])
      @amounts = @recipe.amounts
      @groups = @amounts.group_by do |amount|
        amount.ing_group
      end
      if @groups == nil
        @groups[""] = ""
      end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recipe }
    end
  end

   def change_group
    @amount = Amount.find(params[:amount])
    @amount.update_attributes(:ing_group => params[:group])
    @groups = @amount.recipe.amounts.group_by &:ing_group
    render :partial => "ingredients" #, :object => @groups
  end

  # GET /recipes/new
  # GET /recipes/new.xml
  def new
    @recipe = Recipe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit
    @recipe = Recipe.find(params[:id])
    if @recipe.owner == @logged_in_user.login
      @amounts = @recipe.amounts
      @groups = @amounts.group_by do |amount|
        amount.ing_group
      end
    else
      redirect_to recipe_path(@recipe)
    end
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # POST /recipes
  # POST /recipes.xml
  def create
    params[:recipe]["owner"] = @logged_in_user.login
    @recipe = Recipe.new(params[:recipe])
    
    respond_to do |format|
      if @recipe.save
        flash[:notice] = 'Recipe was successfully created.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recipe, :status => :created, :location => @recipe }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recipe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recipes/1
  # PUT /recipes/1.xml
  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.owner == @logged_in_user.login
      respond_to do |format|
        if @recipe.update_attributes(params[:recipe])
          flash[:notice] = 'Recipe was successfully updated.'
          format.html { redirect_to(@recipe) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @recipe.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to recipe_path(@recipe)
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.xml
  # Deletes the amounts and ingredients if there are no other recipes that share that ingredient
  def destroy
    @recipe = Recipe.find(params[:id])
    if @recipe.owner == @logged_in_user.login    
      @amounts = @recipe.amounts
      @amounts.each do |amount|
        ingredient = amount.ingredient
        amount.destroy
        ingredient.destroy if ingredient.recipes.length == 0
      end
      @recipe.destroy

      respond_to do |format|
        format.html { redirect_to(recipes_url) }
        format.xml  { head :ok }
      end
    else
      redirect_to recipe_path(@recipe)
    end
  end
end
