class StartService
  def initialize(form)
    @form = form
  end

  def process
    msg  = %(Halo!\nSaya dapat membantu anda dalam mencatat dan mengingatkan urusan perhutangan anda.)
    msg << %(\n\nBerikan saya perintah dengan command berikut:)
    msg << %(\n\n*Hutang baru:*)
    msg << %(\n/owe `username` `amount` `description` - Menambah catatan hutang.)
    msg << %(\n/lend `username` `amount` `description` - Menambah catatan piutang.)

    msg << %(\n\n*Daftar hutang:*)
    msg << %(\n/list - Menampilkan daftar hutang.)
    msg << %(\n/paidlist - Menampilkan daftar hutang yang sudah dibayar.)

    msg << %(\n\n*Bayar hutang:*)
    msg << %(\n/paid - Mengupdate status hutang.)

    msg << %(\n\n/help- Jika anda lupa list command.)
    msg << %(\n\nAgar semua berjalan lancar, jika belum, silakan perkenalkan diri anda terlebih dahulu dengan mengirim private message ke saya.) if @form.nonprivate?
    msg << %(\nHave a good day!)
    MessageHandler.send_message(@form.chat['id'], msg)
  end
end

