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
        $('#count-comments').html(result.count_comments);
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
        var countComments = $('#count-comments').text()-1;
        $('#count-comments').html(countComments);
      }
    });
  });

  $(document).on('click', '.edit-comment', function(e){
    e.preventDefault();
    var url = $(this).attr('href');
    $.ajax({
      url: url,
      method: 'get',
      dataType: 'json',
      success: function(result){
        var currentComment = $("#comment-" + result.id);
        currentComment.find(".content").hide();
        currentComment.find(".timestamp").hide();
        currentComment.find(".dropdown").hide();
        currentComment.find(".comment-body").append(editFormFor(result));
        currentComment.find("textarea").focus();
      }
    });
  });

  $(document).on('click', '.cancel-edit', function(e){
    e.preventDefault();
    var currentComment = $("#comment-" + $(this).attr('data-id'));
    currentComment.find('.edit_comment').remove();
    currentComment.find('.content').show();
    currentComment.find('.dropdown').show();
    currentComment.find('.timestamp').show();
  });

  $(document).on('submit', '.edit_comment', function(e){
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
        var currentComment = $("#comment-" + result.id);
        currentComment.find('.edit_comment').remove();
        currentComment.find('.content').text(result.content);
        currentComment.find('.content').show();
        currentComment.find('.dropdown').show();
        currentComment.find('.timestamp').show();
      }
    });
  });
});

function editFormFor(obj){
  var res = "<form class='edit_comment' action='/comments/" + obj.id +
    "' method='put' accept-charset='UTF-8'>" +
    "<input name='utf8' type='hidden' value='✓'>" +
    "<textarea placeholder='Write your comment about this news...' name='comment[content]'" +
    "class='edit-content-comment'>" + obj.content + "</textarea>" +
    "<button class='btn btn-default cancel-edit' data-id='" + obj.id + "'>Cancel</button>" +
    "<input type='submit' name='save' value='Save' class='btn btn-primary'></form>";
  return res;
}

function to_html(obj){
  var res = "<li id='comment-" + obj.id + "'><div class='avatar'>" +
    "<img src='" + obj.image_url + "'></div>" +
    "<div class='comment-body'><div class='user-name'>" + obj.user_name +
    "<span class='dropdown pull-right'>" +
    "<a href='#' class='dropdown-toggle' data-toggle='dropdown'>" +
    "<b class='caret'></b></a><ul class='dropdown-menu'><li>" +
    "<a class='edit-comment' href='/comments/" + obj.id + "/edit'>Edit</a></li>" +
    "<li><a href='/comments/" + obj.id + "' class='delete-comment'" +
    "data-id='" + obj.id + "' data-confirm='Delete this comment?'>Delete</a></li></ul></span>" +
    "</div><div class='content'>" + obj.content + "</div>" +
    "<div class='timestamp'>" + obj.time + "</div></div></li>";
  return res;
}
