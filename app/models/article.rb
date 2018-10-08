class Article < ApplicationRecord

  def redis_page_view
    if REDIS.zscore("articles/daily/#{Date.today.to_s}", id).present?
      REDIS.zscore("articles/daily/#{Date.today.to_s}", id).floor
    end
  end
end
