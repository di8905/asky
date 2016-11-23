$(function() {
  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      console.log('subscribed to answers channel');
      this.perform('follow')
    }, 
    
    received: function(data) {
      $('#answers > tbody:last-child').append('new answer')
    }
  });
});
