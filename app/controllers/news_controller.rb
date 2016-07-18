class NewsController < ApplicationController
  load_and_authorize_resource

  def show
    @comments = @news.comments.order created_at: :desc
    @comment = Comment.new
  end
end
