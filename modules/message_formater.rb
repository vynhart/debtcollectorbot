module MessageFormater
  def self.debt_message_format(d)
    m = "Kepada @#{d.to} sebesar *Rp#{d.amount}* (#{d.desc}) | #{d.created_at.strftime("%d %b %Y")}"
    m << " Dilunasi oleh: @#{d.paid_by}" if d.paid?
    m
  end

  def self.loan_message_format(l)
    m = "Dari @#{l.from} sebesar *Rp#{l.amount}* (#{l.desc}) | #{l.created_at.strftime("%d %b %Y")}"
    m << " Dilunasi oleh: @#{l.paid_by}" if l.paid?
    m
  end

  def self.message_format(d, username)
    if d.debt?(username)
      debt_message_format(d)
    elsif d.loan?(username)
      loan_message_format(d)
    end
  end

  def self.debt_inline_format(d)
    "Hutang: @#{d.to} *Rp#{d.amount}* #{d.desc} [#{d.created_at.strftime("%d %b %Y")}]"
  end

  def self.loan_inline_format(l)
    "Piutang: @#{l.from} *Rp#{l.amount}* #{l.desc} [#{l.created_at.strftime("%d %b %Y")}]"
  end

  def self.inline_format(d, username)
    if d.debt?(username)
      debt_inline_format(d)
    elsif d.loan?(username)
      loan_inline_format(d)
    end
  end

  def self.in_group_format(d)
    "@#{d.from} -> @#{d.to} | *Rp#{d.amount}* | #{d.desc} | #{d.created_at.strftime("%d %b %Y")}"
  end
end
