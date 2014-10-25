$(function() {
  function Game(view) {

    // Setup
    this.view = view;
    this.connection = new WebSocket('ws://hackman.llamadigital.net:8080');
    this.connection.onmessage = function (e) {
      var parsedData = JSON.parse(e.data);
      updateGame(parsedData);
    }
    view.find('#attack').click(function() {
      attack();
    });


    function updateGame(newGame) {
      console.log(newGame);
      view.find('#base-status h2').text(newGame.health);
    }
    function attack() {
      connection.send('attack');
    }
  }

  var game = new Game($('body'));
  window.test = function(string) { console.log(string); }
});
