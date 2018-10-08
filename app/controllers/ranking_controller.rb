class RankingController < ApplicationController

  before_action :set_ranking_data

  def set_ranking_data
    ids = REDIS.zrevrangebyscore "articles/daily/#{Date.today.to_s}", "+inf", 0, limit: [0, 5]
    @ranking_articles = ids.map{ |id| Article.find(id) }
    if @ranking_articles.count < 5
      adding_articles = Article.order(updated_at: :DESC).where.not(id: ids).limit(5 - @ranking_articles.count)
      @ranking_articles.concat(adding_articles)
    end
  end

end
