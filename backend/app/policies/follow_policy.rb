class FollowPolicy
  attr_reader :user, :record
  
  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    FollowAccess.new(user, record).request?
  end

  def approve?
    FollowAccess.new(user, record).approve?
  end
end