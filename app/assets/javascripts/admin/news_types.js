$(document).ready(function(){
  $(document).on('click', '#cancel-form', function(e){
    $('#news-type-form').empty();
    $('#new-news-type').show();
  });
});
