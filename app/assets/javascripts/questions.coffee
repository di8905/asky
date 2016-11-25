App.questions = App.cable.subscriptions.create 'QuestionsChannel',
  connected: ->
    console.log 'subscribed to questions channel'
    @installPageChangeCallback()
    @followQuestionsStream()
    return
  received: (data) ->
    $('#questions-list > tbody:last-child').append data
    return

  followQuestionsStream: ->
    if $('#questions-list').length
      @perform 'follow_questions_stream'
      console.log('following questions stream')
    else
      @perform 'unfollow_questions_stream'
      console.log('unfollowing questions stream')
      
  installPageChangeCallback: -> 
    $(document).on('turbolinks:load', -> App.questions.followQuestionsStream())
return  
