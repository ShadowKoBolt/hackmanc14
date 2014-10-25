$(function() {
  function Game(view) {

    // Setup
    var self = this;
    this.view = view;
    this.connection = new WebSocket('wss://hackman.llamadigital.net:8080');
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
      self.connection.send('attack');
    }
  }

  var game = new Game($('body'));
});

test = function(string) { console.log(string); }
