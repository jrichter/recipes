require 'nokogiri'
class RecipesController < ApplicationController
in_place_edit_for :recipe, :in_place_name
in_place_edit_for :recipe, :in_place_author
in_place_edit_for :recipe, :in_place_directions
in_place_edit_for :recipe, :in_place_oven_temp
in_place_edit_for :recipe, :in_place_picture_url
in_place_edit_for :amount, :in_place_ing_amnt
in_place_edit_for :amount, :in_place_ing_group

before_filter :ensure_login, :except => [:index, :show]

UNITS = %w(bag(?:s)? box(?:es)? teaspoon(?:s)? tsp(?:s)? tablespoon(?:s)? tbsp(?:s)? ounce(?:s)? cup(?:s)? pint(?:s)? quart(?:s)? gallon(?:s)? pinch(?:es)? dash(?:es)? firkin(?:s)? hogshead(?:s)?)

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
    @details = ""
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit 
    @recipe = Recipe.find(params[:id])
    details = ""
    @details = details
    if @recipe.owner == @logged_in_user.login
      @amounts = @recipe.amounts
      amount_groups = @amounts.group_by(&:ing_group)
      amount_groups.keys.each do |key|
        details = details + "<p>#{key}</p>
                   <p><ul>"
        amount_groups[key].each do |amnt|
          details = details + "<li>#{amnt.ing_amnt} #{amnt.ingredient.name}</li>"
        end
        details = details + "</ul></p>"        
      end
      if details == []
        details = ""
      end
      @details = details
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
    @details = ""
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
  
  # adds ingredients and amounts to recipes
  def update_all
    #find recipe
    @recipe = Recipe.find(params[:id])
    if @recipe.update_attribute(:directions, params[:recipe][:directions])
      flash[:notice] = 'Recipe was successfully updated.'
    else
      flash[:notice] = 'Recipe was not updated.'
    end
    
    #start iterating through ingredients
    raw_ings = params[:recipe][:ingredients]
    #check and see if there is any list items, if not assume all items are list items
    if raw_ings.scan(/<li>/) == []
      @all_list_item = true
      raw_ings.gsub!(/<p>/,"<li>").gsub!(/<\/p>/,"</li>")
      flash[:notice] = flash[:notice] + '<br/>' + 'A List was not used so I am assuming all ingredients are in one group/layer.' 
    else
      @all_list_item = false
    end

    #remove bold and italics and split to array
    ings = raw_ings.gsub(/<\/?p>/,"").gsub(/<\/?em>/,"").gsub(/<\/?strong>/,"").split(/[\r\n]/) #split by newline
    #remove unwanted stragglers
    ings.each {|item| ings.delete item if item == "&nbsp;"}
    ings.each {|item| ings.delete item if item == ""}
    ings.each {|item| ings.delete item if item == "<li>&nbsp;</li>"}    
    #check if array item contains a list tag, if not set that as group for rest of elements until encountered again
    #maybe itterate through array and find index points of non list items?    
    groups = []
    i = 0
    logger.info("#{ings}")
    unless @all_list_item == true
      ings.each do |item|
        if item.scan(/<li>/) == []
          groups << i
        end
        i += 1
      end
    end
    count = 0
    unless ings == nil
      ings.each do |array_item|
         #parse ing.text
         if groups.member? count
           @ing_group = ings[count]
         end
         count += 1      
         if array_item.scan(/<li>/) != [] or @all_list_item == true
           array_item.gsub(/<li>/,"").gsub(/<\/li>/,"") =~ /([0-9]+(?:(?:\s)?and(?:\s)?)?(?:(?:\s)?&(?:\s)?)?(?:(?:\s)?[0-9\/-]+)?)?(?:\s*)?(#{UNITS.join('|')})?(?:\s*)?([&a-zA-Z, 0-9 \/]+)/
           name = $3.strip
           quantity = $1
           unit = $2
           logger.info(name)
           if unit != nil
             if quantity != nil
               amnt = quantity + ' ' + unit
             else
               amnt = unit
             end
           elsif quantity == nil
             amnt = ''
           else
             amnt = quantity
           end
         #Find or create ingredient, and amount for recipe
         #Need to remove or modify any ingredients already belonging to this recipe as we should be getting all the ingredients on this mass update
         if ingredient = Ingredient.find_by_name(name)
           #find amount
           if amount = Amount.find(:first, :conditions => {:ingredient_id => ingredient.id, :recipe_id => @recipe.id})
             #update amount
             amount.update_attributes(:ing_amnt => "#{amnt}", :ing_group => @ing_group)
             flash[:notice] = flash[:notice] + '<br/>' + "#{name} updated."
           else
             amount = Amount.create(:ing_amnt => "#{amnt}", :ing_group => @ing_group, :ingredient_id => ingredient.id, :recipe_id => @recipe.id)
             flash[:notice] = flash[:notice] + '<br/>' + "#{name} was successfully added to recipe."
           end
         else ingredient = Ingredient.create(:name => name)         
           amount = Amount.create(:ing_amnt => "#{amnt}", :ing_group => @ing_group, :ingredient_id => ingredient.id, :recipe_id => @recipe.id)
           flash[:notice] = flash[:notice] + '<br/>' + "#{name} was successfully added to recipe."  
         end
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to(@recipe) }
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
