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

    this.updateLocation = function(location) {
      var newLocation = { "location": location }
      self.connection.send(JSON.stringify(newLocation));
    }
  }

  window.game = new Game($('body'));
  window.test = function(string) { $('#test').text(string); }
});

