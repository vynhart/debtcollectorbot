require_relative 'service'

class BaseInlineOweService < Service
  def initialize(form)
    @form = form
  end

  private

  def assign_params
    x = @form.text.split(' ')
    _, @username, @amount = x
    @username = @username.tr('@', '')
    @desc = x[3..-1].join(' ')
  end

  def validate
    validate_params
  end

  def validate_params
    raise MessageError.new('Format salah: username tidak boleh kosong') unless @username
    raise MessageError.new('Format salah: jumlah hutang harus berupa angka') unless !!(@amount =~ /\A\d+\z/)
  end
end
