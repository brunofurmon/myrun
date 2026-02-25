class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    user = User.find(params[:id])
    authorize user, :show?

    render json: UserSerializer.new(user)
  end
end