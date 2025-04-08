module ApplicationHelper
    def soli_brand_link_path
        current_user&.admin? && session[:admin_mode] ? admin_home_index_path : home_path
    end
end
