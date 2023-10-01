class MyPagesController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def show
    @shop_saved_lists = current_user.shop_saved_lists
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to my_page_path, success: t('defaults.message.updated')
    else
      flash.now[:danger] = t('defaults.message.update_failed')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
