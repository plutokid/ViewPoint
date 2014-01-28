# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  
  # add a hash to the URL when the user clicks on a tab
  $("a[data-toggle=\"tab\"]").on "click", (e) ->
    history.pushState null, null, $(this).attr("href")

  # navigate to a tab when the history changes
  window.addEventListener "popstate", (e) ->
    activeTab = $("[href=" + location.hash + "]")
    if activeTab.length
      activeTab.tab "show"
    else
      $(".nav-tabs a:first").tab "show"
      