$(document).on('turbolinks:load', ->
  question_id = $("#question").data("id")

  App.questionAnswers = App.cable.subscriptions.create {channel: 'AnswersChannel', id: question_id},
    connected: ->
      @installQuestionPageChangeCallback()
      @followCurrenQuestion()
    received: (data) ->
      $('#answers').append(JST["templates/answer"]({data: data}))
      return

    followCurrenQuestion: ->
      if question_id
        @perform 'subscribe_question_stream', id: question_id
      else
        @perform 'unsubscribe_question_stream'
      
    installQuestionPageChangeCallback: ->
      $(document).on('turbolinks:load', -> App.questionAnswers.followCurrenQuestion() )
)
