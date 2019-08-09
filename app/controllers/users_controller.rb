class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_basic_all, :update_basic_all]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_basic_all, :update_basic_all]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info, :edit_basic_all, :update_basic_all]
  before_action :set_one_month, only: :show

  def index
    # @users = User.all
    @user_key = ""
    if params[:keyword].nil? 
      @users = User.paginate(page: params[:page])
    else
      # @users = User.where(activated: true).paginate(page: params[:page]).search(params[:keyword])
      @users = User.paginate(page: params[:page]).search(params[:keyword])
      @user_key = params[:keyword]
    end
  end

  def show
    # @user = User.find(params[:id])
    # @first_day = Date.current.beginning_of_month
    # @last_day = @first_day.end_of_month
    @worked_sum = @attendances.where.not(started_at: nil).count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功後、ログインします。
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  def edit_basic_all
  end

  def update_basic_all

  # if @user.update_attributes(work_time: Time.current.change(sec: 0)) && @user.update_attributes(basic_time: Time.current.change(sec: 0))
  # if @user.update_attributes(basic_all_params)
  # if @user.update_all(basic_time: params[:basic_time], work_time: params[:work_time])
  # if @user.update(basic_time: Time.current.change(sec: 0), work_time: Time.current.change(sec: 0))
  # if @user.update_all(basic_time: DateTime.parse("2017/04/25 " && :basic_time && ":00"), work_time: DateTime.parse("2019/08/08 10:00:00"))

    @user = User.all
    if @user.update_all(basic_time: dchange(bp[:basic_time]), work_time: dchange(bp[:work_time]), updated_at: Time.current.change(sec: 0))
      flash[:success] = "全ユーザーの指定勤務時間および基本勤務時間を更新しました。"
    else
      flash[:danger] = "全ユーザーの指定勤務時間および基本勤務時間の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to edit_basic_all_user_path(current_user)
  end

  private

    def user_params
      # params.require(:user).permit(:name, :email, :password, :password_confirmation)
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end

    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end

    def bp
      #params.fetch(:user, {}).permit(:basic_time, :work_time)
      params.require(:user).permit(:basic_time, :work_time)
      #  params.permit(:basic_time, :work_time)
    end # fetch(:user, {}).
    



    # beforeフィルター

    # paramsハッシュからユーザーを取得します。
    #def set_user
    #  @user = User.find(params[:id])
    #end

    # ログイン済みのユーザーか確認します。
    #def logged_in_user
    #  unless logged_in?
    #    store_location
    #    flash[:danger] = "ログインしてください。"
    #    redirect_to login_url
    #  end
    #end

    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    #def correct_user
      # @user = User.find(params[:id])
      # redirect_to(root_url) unless @user == current_user
    #  redirect_to(root_url) unless current_user?(@user)
    #end

    # システム管理権限所有かどうか判定します。
    #def admin_user
    #  redirect_to root_url unless current_user.admin?
    #end

end