$(document).on('turbolinks:load', ->
  question_id = $("#question").data("id")
  App.questionAnswers = App.cable.subscriptions.create {channel: 'AnswersChannel', id: question_id},
    connected: ->
      setTimeout => 
        @followCurrenQuestion()
        @installQuestionPageChangeCallback()
      , 1000  
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
      if question_id != undefined
        @perform 'subscribe_question_stream', id: question_id
      else
        @perform 'unsubscribe_question_stream'
    
    installQuestionPageChangeCallback: ->
      unless @installedPageChangeCallback
        @installedPageChangeCallback = true
        $(document).on('turbolinks:load', -> App.questionAnswers.followCurrenQuestion() )    
      
  )
