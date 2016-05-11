class UsersController < ApplicationController
  def index
    @users =
        if params[:sort] == 'proteges_count'
          User.order_by_people_sponsoring(get_order_direction)
        else
          User.all
        end

    # @users = @users.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:login, :first_name, :last_name, :sponsor_id))

    respond_to do |format|
      if @user.save
        format.html do
          redirect_to @user, notice: 'User created successfully'
        end
      else
        format.html do
          render action: :new
        end
      end
    end
  end

  def destroy
    @user = User.find(params[:user_id] || params[:id])

    if request.delete?
      @user.delete_with_responsoring
      redirect_to users_path, notice: "User #{@user.login} has been deleted."
    end
  end

  private
  def get_order_direction
    params[:order].nil? || params[:order] == 'ASC' ? 'ASC' : 'DESC'
  end
end
