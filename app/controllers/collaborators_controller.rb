class CollaboratorsController < ApplicationController
  def create
    list = current_user.lists.find(params[:list_id])
    collaborator = User.find params[:id]
    membership = list.add_user(collaborator)
    if membership.persisted?
      render json: { result: :success }, status: 201
    else
      render json: membership.errors
    end
  end
end
