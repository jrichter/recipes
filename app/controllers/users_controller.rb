class UsersController < ApplicationController
  layout 'ingredients'
  before_filter :ensure_login, :except => [:new, :create]

  def index
    if @logged_in_user.login == "justin"
      @users = User.find(:all)
    else
      redirect_to recipes_path
    end
  end

  def show
    @user = User.find(params[:id])
    if @logged_in_user.login == @user.login
      #continue
    else
      redirect_to recipes_path
    end
  end

  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
    if @logged_in_user.login == @user.login
      #continue
    else
      redirect_to recipes_path
    end    
  end
  
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to @user }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end 
  end
  
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to @user }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end
