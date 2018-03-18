class UsersController < ApplicationController
  def activate_form
    @membership = Membership.find_by!(invitation_token: params[:invitation_token])
    @user = @membership.user
  end

  def activate
    membership = Membership.find_by!(invitation_token: params[:invitation_token])

    @user = membership.user
    organization = membership.organization

    if @user.update(user_params)
      sign_in(@user)
      redirect_to root_path
    else
      render :activate_form
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
