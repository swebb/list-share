class ListsController < ApplicationController
  def create
    list = List.create_for current_user, with: list_params
    if list.persisted?
      render json: list, status: 201
    else
      render json: { errors: list.errors }, status: 422
    end
  end

  def update
    list = find_list
    if list.update_attributes list_params
      render json: list, status: 200
    else
      render json: { errors: list.errors }, status: 422
    end
  end

  def destroy
    membership = current_user.memberships.find_by_list_id(params[:id])
    list = find_list
    if membership.destroy && (Membership.exists?(list_id: params[:id]) || list.destroy)
      render json: list, status: 200
    else
      render json: { errors: list.errors }, status: 422
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def find_list
    current_user.lists.find(params[:id])
  end
end
