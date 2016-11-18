# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = -> 
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    $(this).hide()
    $('form#edit-answer-form-' + answer_id).show()
    
  $('#edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form#edit-question-form').show()
    
  $('.question-rating > a').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#errors').html('')
    $('#question-' + response.id + '-rating').html(response.rating)
  .bind 'ajax:error', (e, xhr, status, error) -> 
    button = '<button type="button" class="close" data-dismiss="alert">×</button>'
    response = $.parseJSON(xhr.responseText)
    $('#errors').html('<div class="alert fade in alert-danger">' + button + response + '</div>' )
  $('.answer-rating > a').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#errors').html('')
    $('#answer-' + response.id + '-rating').html(response.rating)
  .bind 'ajax:error', (e, xhr, status, error) ->
    button = '<button type="button" class="close" data-dismiss="alert">×</button>'
    response = $.parseJSON(xhr.responseText)
    $('#errors').html('<div class="alert fade in alert-danger">' + button + response + '</div>' )
    
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on("turbolinks:load", ready)
$(document).on('page:update', ready)
