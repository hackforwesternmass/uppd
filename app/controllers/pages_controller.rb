class PagesController < InheritedResources::Base
	before_filter :authenticate_admin_user!, only: [:new, :create, :edit, :save]

end
