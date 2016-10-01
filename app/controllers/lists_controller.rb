class ListsController < ApplicationController
  def create
    list = List.new(list_params)
    list.memberships.build user: current_user
    if list.save
      render json: list, status: 201
    else
      render json: { errors: list.errors }, status: 422
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
