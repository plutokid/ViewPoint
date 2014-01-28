$(document).ready ->
  $(".img").click ->
    $(".img").hide();
    $("<img>").attr("src", $(this).attr("popup")).hide().appendTo("#popup").fadeIn 500
    $("#popup > img").click ->
      $("#popup > img").hide()
      $(".img").fadeIn 500
      