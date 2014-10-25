$(function() {
  function Game(view) {

    // Setup
    var self = this;
    this.view = view;
    this.enemies = 0;
    this.currentLocation = 0;
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
      self.enemies = newGame.towers[self.currentLocation].enemies;
    }
    function attack() {
      var newAttack = { "attack": 1 }
      self.connection.send(JSON.stringify(newAttack));
    }

    this.updateLocation = function(location) {
      self.currentLocation = location;
      if (location == 0) {
        view.find('#current-location h2').text('Base');
      } else {
        view.find('#current-location h2').text('Tower: '+ location);
        view.find('#enemies').text(self.enemies);
      }
      var newLocation = { "location": location }
      self.connection.send(JSON.stringify(newLocation));
    }
  }

  window.game = new Game($('body'));
  window.test = function(string) { $('#test').text(string); }
});

