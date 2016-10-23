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
    item = find_item
    if item.update_attributes item_params
      render json: item, status: 200
    else
      render json: { errors: item.errors }, status: 422
    end
  end

  def destroy
    item = find_item

    if item.destroy
      render json: item, status: 200
    else
      render json: { errors: item.errors }, status: 422
    end
  end

  private

  def find_item
    current_user.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(%i(name completed starred priority due_date notes user_id))
  end
end
