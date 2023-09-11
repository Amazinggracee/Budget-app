class PurchasesController < ApplicationController
  before_action :authenticate_user!

  def new
    @purchase = Purchase.new
    @categories = Category.where(author_id: current_user.id).order(created_at: :desc)
    @selected_category = Category.find(params[:category_id])
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.author_id = current_user.id  # Use author_id instead of author

    if @purchase.save
      params[:category_ids].each do |id|
        CategoriesPurchase.create(category_id: id.to_i, purchase_id: @purchase.id)  # Corrected class name
      end
      redirect_to category_path(params[:category_id]), notice: 'Transaction added successfully'
    else
      @categories = Category.where(author_id: current_user.id).order(created_at: :desc)
      render :new, status: :unprocessable_entity  # Use symbol instead of status code
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(:name, :amount)
  end
end
