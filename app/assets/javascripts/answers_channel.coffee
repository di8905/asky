@question_id = $('#question').data("id")
if @question_id
  App.cable.subscriptions.create {channel: 'AnswersChannel', question_id: question_id},
    connected: ->
      console.log "subscribed to answers channel stream #{question_id}"
      @perform 'subscribe_question_stream', id: question_id

    received: (data) ->
      console.log(data)
  return
