class RunPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    RunAccess.new(user, record).allowed?
  end

  def create?
    true
  end
end