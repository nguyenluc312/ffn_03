module CommentsHelp
  def json_data comment
    data = Hash.new
    data[:id] = comment.id
    data[:image_url] = comment.user_avatar.small.url
    data[:user_name] = comment.user_name
    data[:content] = comment.content
    data[:time] = comment.created_at
    return data
  end
end
