module Cacheable
  extend ActiveSupport::Concern

  included do
    after_update :expire_cache
    after_destroy :expire_cache
  end

  class_methods do
    def cached_find(id, expires_in: 1.hour)
      Rails.cache.fetch("#{name.downcase}/#{id}", expires_in: expires_in) do
        find(id)
      end
    end

    def cached_search(query_params, expires_in: 30.minutes)
      cache_key = "#{name.downcase}_search/#{Digest::MD5.hexdigest(query_params.to_s)}"
      Rails.cache.fetch(cache_key, expires_in: expires_in) do
        yield
      end
    end
  end

  private

  def expire_cache
    Rails.cache.delete("#{self.class.name.downcase}/#{id}")
    # Expire search caches
    Rails.cache.delete_matched("#{self.class.name.downcase}_search/*")
  end
end