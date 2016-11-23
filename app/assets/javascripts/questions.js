$(function() {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('connected');
      this.perform('follow');
    },
    
    received: function(data) {
      $('#questions-list > tbody:last-child').append(data);
    }
  });
});
