class MiniCardPictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  def extension_whitelist
    %w(jpg jpeg png)
  end

  def filename
    if original_filename.present?
      if model.real_id.present?
        "#{model.real_id}.#{file.extension}"
      else
        "#{secure_token}.#{file.extension}"
      end
    end
  end

  def crop(x, y, width, height)
    manipulate! do |img|
      img.crop! x, y, width, height

      img
    end
  end

  protected

    def secure_token
      var = :"@#{mounted_as}_secure_token"

      model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.hex(10))
    end
end
