$(document).ready(function(){
  $("#new_comment").submit(function(e){
    e.preventDefault();
    var url = $(this).attr('action');
    var method = $(this).attr('method');
    var data = $(this).serializeArray();
    $.ajax({
      url: url,
      method: method,
      data: data,
      dataType: 'json',
      success: function(result){
        $('#count-comments').html("(" + result.count_comments + ")");
        $('#comments').prepend(to_html(result));
        $('#comment_content').val('');
      }
    });
  });

  $(document).on('click', '.delete-comment', function(e){
    e.preventDefault();
    var url = $(this).attr('href');
    var id = $(this).attr('data-id');
    $.ajax({
      url: url,
      method: 'delete',
      dataType: 'text',
      success: function(){
        $("#comment-" + id).remove();
      }
    });
  });
});

function to_html(obj){
  var res = "<li id='comment-" + obj.id + "'><div class='avatar'>" +
    "<img src='" + obj.image_url + "'></div>" +
    "<div class='comment-body'><div class='user-name'>" + obj.user_name +
    "<span class='dropdown pull-right'>" +
    "<a href='#' class='dropdown-toggle' data-toggle='dropdown'>" +
    "<b class='caret'></b></a><ul class='dropdown-menu'><li>" +
    "<a href='/comments/" + obj.id + "' class='delete-comment'" +
    "data-id='" + obj.id + "' data-confirm='Delete this comment?'>Delete</a></li></ul></span>" +
    "</div><div class='content'>" + obj.content + "</div>" +
    "<div class='timestamp'>" + obj.time + "</div></div></li>";
  return res;
}
