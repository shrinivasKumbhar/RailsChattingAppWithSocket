class User < ActiveRecord::Base

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence:true, uniqueness: { case_sensitive: false }
  validates :password, presence:true

  #@method  register_user : Method will register new user
  #@param params: name : name of user, email: Email of user, password: Password
  #@return response that will be sent as json response contains success and list of compeleted requests OR error message.
  def register_user(params)
    Rails.logger.info{"#{__FILE__}: #{__LINE__} register_user method start"}
    begin
      if params.present?
        user = User.new(
            name: params[:name],
            email:params[:email],
            password: params[:password]
        )
        if user.save
          response = {:success => true, :data => user}
        else
          response = {:success => false, :message => user.errors.full_messages.join(',')+'.'}
          Rails.logger.error{"#{__FILE__}: #{__LINE__} Exceptoin : #{user.errors.full_messages.join(', ')+'.'}"}
        end
      else
        response = {:success => false, :message => "Parameters not present."}
      end
    rescue => e
      Rails.logger.error{"#{__FILE__}: #{__LINE__} Exception : #{e.message}"}
      response = {:success => false, :message => "Internal server error, please try again."}
    end
    Rails.logger.info{"#{__FILE__}: #{__LINE__} register_user method end"}
    return response
  end

  #@method  user_login : Method will used to login
  #@param params:email: Email of user, password: Password
  #@return response that will be sent as json response contains success and list of compeleted requests OR error message.
  def user_login(params)
    Rails.logger.info{"#{__FILE__}: #{__LINE__} user_login method start"}
    begin
      if params.present?
        user = User.where(:email => params[:email], :password => params[:password]).first
        if user.present?
          response = {:success => true, :data => user}
        else
          response = {:success => false, :message => "Invalid username or password."}
        end
      else
        response = {:success => false, :message => "Parameters are not present"}
      end
    rescue => e
      Rails.logger.error{"#{__FILE__}: #{__LINE__} Exception : #{e.message}"}
      response = {:success => false, :message => "Internal server error, please try again."}
    end
    Rails.logger.info{"#{__FILE__}: #{__LINE__} user_login method end"}
    return response
  end
end
