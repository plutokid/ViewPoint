$(document).ready ->
  $("#viewpoints_col .list-group-item").click ->
    #$("#viewpoints_col .list-group-item.active").removeClass "active"
    $(this).parent().children().removeClass "active"
    $(this).addClass "active"

  $("#viewpoints_col .list-group-item").on "click", (e) ->
    if $("[href=" + location.hash + "]").selector != "[href=#map]" && $("[href=" + location.hash + "]").selector != "[href=#gallery]" && $("[href=" + location.hash + "]").selector != "[href=#created_views]" && $("[href=" + location.hash + "]").selector != "[href=#pending_views]" && $("[href=" + location.hash + "]").selector != "[href=#completed_views]"
      history.pushState null, null, '#'+$(this).attr("href").split('/')[2]

  window.addEventListener "popstate", (e) ->
    activeTab = undefined
    activeTab = $("[href=" + location.hash + "]")
    if activeTab.selector.toString().split('#')[1] != undefined
      loc_id = activeTab.selector.toString().split('#')[1].replace(']', '')
      $("#viewpoints_col .list-group-item.active").removeClass "active"
      $("#"+loc_id).click()
    else
      $("#viewpoints_col .default").click()
      $("#viewpoints_col .default").addClass "active"

    if $("[href=" + location.hash + "]").selector == "[href=#map]" || $("[href=" + location.hash + "]").selector == "[href=#gallery]" || $("[href=" + location.hash + "]").selector == "[href=#created_views]" || $("[href=" + location.hash + "]").selector == "[href=#pending_views]" || $("[href=" + location.hash + "]").selector == "[href=#completed_views]"
      $("#viewpoints_col .default").click()
      $("#viewpoints_col .default").addClass "active"

  $("#other_photos_col img").click ->
    $("#location_pic").hide().attr("src", $(this).attr("full_img")).fadeIn 800;
    $("#comments_data").html($(this).attr("comments"));
