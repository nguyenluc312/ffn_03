$(document).ready(function(){
  $("#new_comment").submit(function(e){
      e.preventDefault();
      var url = $(this).attr('action');
      var method = $(this).attr('method');
      var data = $(this).serializeArray();
      console.log(data);
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
});

function to_html(obj){
  var res;
  res = "<li><div class='avatar'>";
  res += "<img src='" + obj.image_url + "'></div>";
  res += "<div class='comment-body'><div class='user-name'>";
  res += obj.user_name + "</div><div class='content'>" + obj.content + "</div>";
  res += "<div class='timestamp'>" + obj.time + "</div></div></li>";
  return res;
}
