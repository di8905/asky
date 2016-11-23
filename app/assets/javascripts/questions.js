$(function() {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('connected');
    }
  });
});
