class ArticleController < RankingController

  before_action :move_to_index, except: [:index, :show]
  before_action :find_article, only: [:edit, :update, :destroy, :show]

  def index
    @articles = Article.order("created_at DESC")
  end

  def new
    @article = Article.new
  end

  def create
    Article.create(article_params)

    redirect_to controller: :article, action: :index
  end

  def show
    REDIS.zincrby "articles/daily/#{Date.today.to_s}", 1, @article.id
  end

  def edit
  end

  def update
    @article.update(article_params) if @article.user_id == current_user.id

    redirect_to controller: :article, action: :index
  end

  def destroy
    @article.destroy if @article.user_id == current_user.id
    REDIS.zrem "articles/daily/#{Date.today.to_s}", @article.id

    redirect_to controller: :article, action: :index
  end

  private

  def move_to_index
      redirect_to action: :index unless user_signed_in?
  end

  def article_params
    params.require(:article).permit(:title, :detail).merge(user_id: current_user.id)
  end

  def find_article
    @article = Article.find(params[:id])
  end
end
