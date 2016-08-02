$(document).ready(function(){

  totalCmts = $('#comments .comment').size();
  currentShownCmts = totalCmts < 5 ? totalCmts : 5;
  minShownCmts = currentShownCmts;
  $('#comments .comment').not(':lt(' + minShownCmts + ')').hide();
  if (totalCmts <= currentShownCmts){
    $("#show-more").hide();
  }
  $('#show-less').hide();

  $(document).on('click', '#show-more', function(e){
    e.preventDefault();
    currentShownCmts = currentShownCmts + 5 < totalCmts ? currentShownCmts + 5 : totalCmts;
    $('#comments .comment:lt(' + currentShownCmts + ')').show();
    $('#show-less').show();
    if (currentShownCmts >= totalCmts) {
      $('#show-more').hide();
    }
  });

  $(document).on('click', '#show-less', function(e){
    e.preventDefault();
    currentShownCmts = currentShownCmts - 5 < minShownCmts ? minShownCmts : currentShownCmts - 5;
    $('#comments .comment').not(':lt(' + currentShownCmts + ')').hide();
    $('#show-more').show();
    if (currentShownCmts <= minShownCmts){
      $('#show-less').hide();
    }
  });

  $(document).on('submit', '#new_comment', function(e){
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
        console.log(result);
        $('#count-comments').html(result.count_comments);
        $('#comments').prepend(to_html(result));
        $('#comment_content').val('');
        totalCmts++;
        currentShownCmts++;
        minShownCmts++;
      },
      error: function(xhr){
        var errors = $.parseJSON(xhr.responseText).errors;
        var errMsg = "";
        $.each(errors, function(key, data){
          errMsg += data + "\n";
        });
        alert(errMsg);
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
        totalCmts--;
        currentShownCmts--;
        minShownCmts--;
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
      },
      error: function(xhr){
        var errors = $.parseJSON(xhr.responseText).errors;
        var errMsg = "";
        $.each(errors, function(key, data){
          errMsg += data + "\n";
        });
        alert(errMsg);
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
  var res = "<li id='comment-" + obj.id + "' class='comment'><div class='avatar'>" +
    "<a href='/users/" + obj.user_id + "'><img src='" + obj.image_url + "'></a></div>" +
    "<div class='comment-body'><div class='user-name'><a href='/users/" + obj.user_id + "'>" +
    obj.user_name + "</a><span class='dropdown pull-right'>" +
    "<a href='#' class='dropdown-toggle' data-toggle='dropdown'>" +
    "<b class='caret'></b></a><ul class='dropdown-menu'><li>" +
    "<a class='edit-comment' href='/comments/" + obj.id + "/edit'>Edit</a></li>" +
    "<li><a href='/comments/" + obj.id + "' class='delete-comment'" +
    "data-id='" + obj.id + "' data-confirm='Delete this comment?'>Delete</a></li></ul></span>" +
    "</div><div class='content'>" + obj.content + "</div>" +
    "<div class='timestamp'>" + obj.time + "</div></div></li>";
  return res;
}
