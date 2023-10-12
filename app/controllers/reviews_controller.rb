class ReviewsController < ApplicationController
  before_action :set_shop, only: %i[new create]
  before_action :set_review, only: %i[edit update destroy]

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash.now.notice = "レビューを投稿しました"
      render turbo_stream: [
        turbo_stream.prepend("reviews", @review),
        turbo_stream.update("flash", partial: "shared/flash")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @review.update(review_params.except(:shop_id))
      flash.now.notice = "レビューを更新しました"
      render turbo_stream: [
        turbo_stream.replace(@review),
        turbo_stream.update("flash", partial: "shared/flash")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy!
    flash.now.notice = "レビューを削除しました"
    render turbo_stream: [
      turbo_stream.remove(@review),
      turbo_stream.update("flash", partial: "shared/flash")
    ]
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content).merge(shop_id: params[:shop_id])
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end
end
