# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = -> 
  # $('.edit-answer-link').click (e) ->
  #   e.preventDefault()
  #   answer_id = $(this).data('answerId')
  #   $(this).hide()
  #   $('form#edit-answer-form-' + answer_id).show()
  
  $('body').on 'click', '.cancel', (e) ->
    e.preventDefault()
    $(this).parent().remove()
    $('#errors-field').html('')
  $('#edit-question-link').click (event) ->
    event.preventDefault()
    $('#edit-question-form').show()
  $('.question-rating > a').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#errors-field').html('')
    $('#question-' + response.id + '-rating').html(response.rating)
  .bind 'ajax:error', (e, xhr, status, error) -> 
    button = '<button type="button" class="close" data-dismiss="alert">×</button>'
    response = $.parseJSON(xhr.responseText)
    $('#errors-field').html('<div class="alert fade in alert-danger">' + button + response + '</div>' )
  $(document).on 'ajax:success', '#answers', (e, xhr, status, error) ->
    $('#errors-field').html('')
    $('#answer-' + xhr.id + '-rating').html(xhr.rating)    
  .bind 'ajax:error', (e, xhr, status, error) ->
    button = '<button type="button" class="close" data-dismiss="alert">×</button>'
    response = $.parseJSON(xhr.responseText)
    $('#errors-field').html('<div class="alert fade in alert-danger">' + button + response + '</div>' )

fileName = (url) -> 
  return url.replace(/^.*[\\\/]/, '')
window.fileName = fileName

$(document).on("turbolinks:load", ready)
$(document).change(ready)
