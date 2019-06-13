# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :check_recaptcha_v3, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    # 把參數 `verify_v2` 存起來留給 view 使用
    @verify_v2 = params[:verify_v2] === 'true'
    super
  end

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

  def verify_recaptcha_tags
    # 用來驗證 v2 recaptcha_tags (secret_key 不一樣)
    verify_recaptcha secret_key: ENV["RECAPTCHA_V2_CHECKBOX_SECRET_KEY"]
  end 

  def check_recaptcha_v3
    v3_valid = verify_recaptcha(
      # action：當收到 recaptcha token 的時候要認哪一個名稱來做驗證
      #         與前端 form 表單呼應
      action: 'login',
      minimum_score: 0.5,
      secret_key: ENV["RECAPTCHA_V3_SECRET_KEY"],
    )
    v2_valid = verify_recaptcha_tags unless v3_valid

    if v3_valid || v2_valid
      # 如果驗證成功要額外做什麼事...
    else
      # 驗證失敗, 導到登入頁面並帶一個 verify_v2=true 的參數
      redirect_to new_user_session_path(verify_v2: true)
    end
  end
end
