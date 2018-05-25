$(document).on('keyup', '.filtering input:text', function(event){
  var keysRegexp = /[\w-@.]+/i;

  if (!keysRegexp.test(event.which)) {
    return
  };

  $.get($(".filtering").attr("action"), $(".filtering").serialize(), null, "script");
  return false;
});
