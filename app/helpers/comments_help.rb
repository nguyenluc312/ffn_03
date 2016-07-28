module CommentsHelp
  include ActionView::Helpers::DateHelper
  def json_data comment
    data = Hash.new
    data[:id] = comment.id
    data[:image_url] = comment.user_avatar.small.url
    data[:user_name] = comment.user_name
    data[:user_id] = comment.user_id
    data[:content] = comment.content.gsub "\n", "<br/>"
    data[:time] = time_ago_in_words comment.created_at
    return data
  end
end
