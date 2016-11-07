class ApplicationController < ActionController::Base
  include UsersHelper, SessionsHelper

  protect_from_forgery with: :exception
  before_action :set_locale

  # 设置语系
  def set_locale
    supported_locale = %w(zh-CN en)
    if params[:locale] && I18n.locale_available?( params[:locale].to_sym ) && supported_locale.include?( params[:locale] )
      cookies.permanent[:locale] = params[:locale]
    end
    I18n.locale = cookies[:locale] || I18n.default_locale
  end

  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
    end
  end

  # 确保已登录, 否则转向登录页面
  def check_signed_in
    unless signed_in?
      store_location
      flash[:warning] = I18n.t "flash.warning.need_sign_in"
      redirect_to signin_path
    end
  end

end
