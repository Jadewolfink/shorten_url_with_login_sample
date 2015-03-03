class Url < ActiveRecord::Base
  before_create :generate_short_url

  def generate_short_url
    self.short_url = SecureRandom.urlsafe_base64(4, padding=false)
    until Url.where(short_url: self.short_url).count == 0
      self.short_url = SecureRandom.urlsafe_base64(4, padding=false)
    end
  end
end

