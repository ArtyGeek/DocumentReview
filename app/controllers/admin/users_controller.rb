class Admin::UsersController < Admin::AdminController
  before_action :set_admin_user, only: [:show, :edit, :update, :destroy, :add_user_role]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user), notice: 'User was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
  end
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_dashboard_url, notice: 'User was successfully destroyed.'
  end

  def add_user_role
    if @user.add_user_role params[:role]
      redirect_to admin_user_path(@user), notice: 'Role was successfully added'
    end
  end

  private
    def set_admin_user
      @user = User.find(params[:id])
      @roles = Role.all
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :roles)
    end
end
