class CommentsController < ApplicationController
  before_action :load_news, only: :create
  load_and_authorize_resource
  skip_load_resource only: :create

  include CommentsHelp

  def create
    @comment = @news.comments.build comment_params
    @comment.user = current_user
    if @comment.save
      data = json_data @comment
      data[:count_comments] = @news.comments.count
      respond_to do |format|
        format.json {render json: data}
      end
    end
  end

  def edit
    respond_to do |format|
      format.json {render json: @comment}
    end
  end

  def update
    @comment.update_attributes comment_params
    respond_to do |format|
      format.json {render json: @comment}
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html {head :ok}
    end
  end

  private
  def comment_params
    params.require(:comment).permit :content
  end

  def load_news
    @news = News.find_by id: params[:id]
    unless @news
      flash[:danger] = ".invalid"
      redirect_to root_url
    end
  end
end
