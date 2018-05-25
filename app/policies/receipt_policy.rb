class ReceiptPolicy < ApplicationPolicy
  def show?
    @record.owner == @user
  end

  def destroy?
    show?
  end

  def restore?
    show?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
