class ShopSavedListsController < ApplicationController
  before_action :set_list, only: %i[show edit update destroy]

  def index
    @shop_saved_lists = current_user.shop_saved_lists.order(created_at: :asc)
  end

  def new
    @shop_saved_list = current_user.shop_saved_lists.build
  end

  def create
    @shop_saved_list = current_user.shop_saved_lists.build(list_params)
    if @shop_saved_list.save
      redirect_to shop_saved_lists_path
    else
      render :new
    end
  end

  def show
    @list_shops = @shop_saved_list.shops.order(created_at: :desc)
  end

  def edit; end

  def update
    if @shop_saved_list.update(list_params)
      flash.now.notice = "リスト名を更新しました"
      render turbo_stream: [
        turbo_stream.replace(@shop_saved_list),
        turbo_stream.update("flash", partial: "shared/flash")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shop_saved_list.destroy!
    redirect_to my_page_path, success: "リストを削除しました"
  end

  private

  def list_params
    params.require(:shop_saved_list).permit(:name)
  end

  def set_list
    @shop_saved_list = current_user.shop_saved_lists.find(params[:id])
  end
end
