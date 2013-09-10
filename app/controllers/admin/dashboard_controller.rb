class Admin::DashboardController < Admin::AdminController


  def index
    @roles = Role.all
    @states = Document.counted_by_state
    @users = User.all
    @documents = Document.with_state(:pending_publication)
  end



end
