class ItemsController < ApplicationController
  def create
    list = current_user.lists.find params[:list_id]
    item = list.items.create item_params
    if item.persisted?
      render json: item, status: 201
    else
      render json: { errors: item.errors }, status: 422
    end
  end

  def update
    item = current_user.items.find(params[:id])
    if item.update_attributes item_params
      render json: item, status: 200
    else
      render json: { errors: item.errors }, status: 422
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :completed, :starred, :priority, :due_date, :notes)
  end
end
