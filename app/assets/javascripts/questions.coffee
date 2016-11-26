App.questions = App.cable.subscriptions.create 'QuestionsChannel',
  connected: ->
    @installPageChangeCallback()
    @followQuestionsStream()
    return
  received: (data) ->
    $('#questions-list > tbody:last-child').append data
    return

  followQuestionsStream: ->
    if $('#questions-list').length
      @perform 'follow_questions_stream'
    else
      @perform 'unfollow_questions_stream'
      
  installPageChangeCallback: -> 
    $(document).on('turbolinks:load', -> App.questions.followQuestionsStream())
return  
