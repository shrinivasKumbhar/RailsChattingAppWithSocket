class UsersController < ApplicationController

  #index controller which loads the index page
  def index
    @user = User.new
    if session[:current_user_id].present?
      @user_list = User.all
    end
  end

  #used to register new user
  def create
    response = User.new.register_user(params)
    if response[:success] == true
      session[:current_user_id] = response[:data][:id]
      render :json => response
      #redirect_to :controller => 'users', :action => 'index'
    else
      render :json => response
    end
  end

  def login
    response = User.new.user_login(params)
    if response[:success] == true
      session[:current_user_id] = response[:data][:id]
      render :json => response
      #redirect_to :controller => 'users', :action => 'index'
    else
      render :json => response
    end
  end

  def logout
    if session.delete(:current_user_id)
      response ={:success => true, :data => "Logout successfull."}
    else
      response = {:success => false, :message => "Error While Logout Please try again."}
    end
    render :json => response
  end
end
