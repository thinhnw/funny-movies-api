class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  before_action :render_not_found, only: [ :new, :edit, :update, :destroy, :cancel ]

  private
  def render_not_found
    head :not_found
  end
end
