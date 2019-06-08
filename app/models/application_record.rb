class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def cache_or_block(key, &block)
    return Rails.cache.read(key) if Rails.cache.exist?(key)
    value = yield
    Rails.cache.write(key, value)
    value
  end
end
