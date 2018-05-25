$(function(){ 
  $('.delete').bind('ajax:complete', function(e) {
    $(e.target.closest("li")).fadeOut(300, function(){ $(this).remove();});
    if ($(".list-group-item").length == 2) {
      $("ul.list-group").append("<li class='list-group-item'>Nothing here :-)</li>");
    }
  });
});
 