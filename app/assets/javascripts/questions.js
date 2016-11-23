$(function() {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('subscribed to questions channel');
      this.perform('follow');
    },
    
    received: function(data) {
      $('#questions-list > tbody:last-child').append(data);
    }
  });
});
