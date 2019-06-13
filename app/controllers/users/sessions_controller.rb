# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :check_recaptcha_v3, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def check_recaptcha_v3
    valid = verify_recaptcha(
      # action：當收到 recaptcha token 的時候要認哪一個名稱來做驗證
      #         與前端 form 表單呼應
      action: 'login',
      minimum_score: 0.5,
      secret_key: ENV["RECAPTCHA_V3_SECRET_KEY"],
    )

    if not valid
      redirect_to new_user_session_path_path
    end
  end
end
