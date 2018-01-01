class Debt < ActiveRecord::Base
  default_scope { where(state: :unpaid) }
  scope :paid, -> { where(state: :paid) }

  def debt?(username)
    self.from == username
  end

  def loan?(username)
    self.to == username
  end

  def paid?
    self.state == 'paid'
  end
end
