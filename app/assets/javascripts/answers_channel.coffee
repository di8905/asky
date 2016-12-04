App.questionAnswers = App.cable.subscriptions.create {channel: 'AnswersChannel', id: $('#question').data('id')},
  connected: ->
    @followCurrenQuestion()
    @installQuestionPageChangeCallback()
    return

  received: (data) ->
    if data.type == "answer"
      $('#answers').append(JST["templates/answer"]({data: data}))
    if data.type == "comment"
      targetDiv = '#' + data.comment.commentable_type + '-' + data.comment.commentable_id + '-comments'
      $('form#new_comment').remove()
      $('#errors-field').html('')
      $(targetDiv).append(JST["templates/comment"]({comment: data.comment}))
    return

  
  followCurrenQuestion: ->
    if $('#question').data('id') != undefined
      @perform 'subscribe_question_stream', id: $('#question').data('id')
    else
      @perform 'unsubscribe_question_stream'
  
  installQuestionPageChangeCallback: ->
    $(document).on('turbolinks:load', -> App.questionAnswers.followCurrenQuestion() )    
  
