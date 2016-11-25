$(document).on('turbolinks:load', ->
  question_id = $("#question").data("id")
  console.log(question_id)

  App.questionAnswers = App.cable.subscriptions.create {channel: 'AnswersChannel', id: question_id},
    connected: ->
      @installQuestionPageChangeCallback()
    received: (data) ->
      console.log(data)
      return

    followCurrenQuestion: ->
      if question_id
        @perform 'subscribe_question_stream', id: @question_id
        console.log "following question_answers_stream_#{question_id}"
      else
        @perform 'unsubscribe_question_stream'
        console.log "unfollowing any question_answers stream"
      
    installQuestionPageChangeCallback: ->
      $(document).on('turbolinks:load', -> App.questionAnswers.followCurrenQuestion() )
)
