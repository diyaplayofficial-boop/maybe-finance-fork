module AdminRequired
  extend ActiveSupport::Concern

  included do
    before_action :require_admin!
  end

  private

  def require_admin!
    unless current_user_is_admin?
      respond_to do |format|
        format.html { 
          redirect_to root_path, 
          alert: "Access denied. Admin privileges required." 
        }
        format.json { 
          render json: { error: "Unauthorized" }, status: :unauthorized 
        }
      end
    end
  end

  def current_user_is_admin?
    # Check if user exists and has admin or super_admin role
    Current.user.present? && (Current.user.role == "admin" || Current.user.role == "super_admin")
  end
end