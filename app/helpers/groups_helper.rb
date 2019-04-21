module GroupsHelper

  def get_group_qr_code(url, size)
    RQRCode::QRCode.new(url).to_img
                   .resize(size, size).to_data_url
  end
end
