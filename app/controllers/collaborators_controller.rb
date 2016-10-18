class CollaboratorsController < ApplicationController
  def create
    list = find_list
    collaborator = User.find params[:id]
    membership = list.add_user(collaborator)
    if membership.persisted?
      render json: { result: :success }, status: 201
    else
      render json: membership.errors
    end
  end

  def destroy
    list = find_list
    user = list.users.find params[:id]
    if list.remove_user user
      render json: {"result" => "success" }
    else
      render json: {"result" => "error" }
    end
  end

  private

  def find_list
    current_user.lists.find(params[:list_id])
  end
end
