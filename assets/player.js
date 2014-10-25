$(function() {
  function Game(view) {

    // Setup
    var self = this;
    this.view = view;
    this.enemies = 0;
    this.currentLocation = 1;
    this.gameStarted = false;
    this.connected = false;
    this.playerId = 0;

    if (window.location.hostname == "hackman.llamadigital.net") {
      this.connection = new WebSocket('wss://hackman.llamadigital.net:8080');
    } else {
      this.connection = new WebSocket('ws://192.168.69.69:8080');
    }
    this.connection.onmessage = function (e) {
      var parsedData = JSON.parse(e.data);
      if (self.connected) {
        updateGame(parsedData);
      } else {
        self.connected = true;
        self.playerId = parsedData.config.id;
      }
    }
    view.find('#attack').click(function() {
      attack();
    });
    view.find('#start').click(function() {
      start();
    });


    function updateGame(newGame) {
      console.log(newGame);
      view.find('#base-status h2').text(newGame.health);
      if (self.currentLocation > 1) {
        self.enemies = newGame.towers[self.currentLocation - 1].enemies;
        // view.find('#enemies').text(self.enemies);
        showEnemies(self.enemies);
      } else {
        view.find('#enemies').text("");
      }
      if (newGame.state == "active") {
        view.find('#start').hide();
      }
    }
    function showEnemies(count) {
      enemyContainer = view.find("#enemies");
      enemyContainer.empty();
      for (i = 0 ; i < count ; i++) {
        enemyContainer.append("<span class='enemy'>Enemy<span>"); 
      }
    }
    function attack() {
      window.navigator.vibrate(200);
      var newAttack = { "action": "attack" }
      self.connection.send(JSON.stringify(newAttack));
    }
    function start() {
      var newAction = { "action": "start" }
      view.find('#start').hide();
      self.connection.send(JSON.stringify(newAction));
    }

    this.updateLocation = function(location) {
      self.currentLocation = location;
      if (location == 1) {
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

