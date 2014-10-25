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
    this.ammo = 0;

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
        self.ammo = parsedData.config.ammo;
      }
    }
    view.find('#action').click(function() {
      if (self.currentLocation == 1) {
        reload();
      } else {
        attack();
      }
    });
    view.find('#start').click(function() {
      start();
    });

    function updateGame(newGame) {
      console.log(newGame);
      self.gameStarted = this.active;
      updateGameActive();
      if(newGame.health > 0) {
        view.find('#base-status h2').text(newGame.health);
      } else {
        view.find('#base-status h2').text("Game over!");
      }
      showAmmunition(self.ammo);
      if (self.currentLocation > 1) {
        self.enemies = newGame.towers[self.currentLocation - 2].enemies;
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
    function showAmmunition(count) {
      ammoContainer = view.find("#ammunition");
      ammoContainer.empty();
      for (i = 0 ; i < count ; i++) {
        ammoContainer.append("<span class='bullet'>Bullet<span>"); 
      }
    }
    function attack() {
      if (self.ammo > 0) {
        window.navigator.vibrate(200);
        var newAttack = { "action": "user", "location": self.currentLocation }
        self.connection.send(JSON.stringify(newAttack));
        self.ammo -= 1;
        showAmmunition(self.ammo);
      }
    }
    function start() {
      var newAction = { "action": "start" }
      updateGameActive();
      self.connection.send(JSON.stringify(newAction));
    }
    function reload() {
      var newAction = { "action": "user", "location": self.currentLocation }
      self.connection.send(JSON.stringify(newAction));
      self.ammo += 1;
      showAmmunition(self.ammo);
    }

    function updateGameActive() {
      if (self.gameStarted == true) {
        view.find('#start').hide();
      }
      else {
        view.find('#start').show();
      }
    }

    this.updateLocation = function(location) {
      self.currentLocation = location;
      if (location == 1) {
        view.find('#current-location h2').text('Base');
        view.find('#action').html('Reload');
      } else {
        view.find('#current-location h2').text('Tower: '+ location);
        view.find('#enemies').text(self.enemies);
        view.find('#action').html('Attack!!!!!');
      }
      var newLocation = { "location": location }
      self.connection.send(JSON.stringify(newLocation));
    }
  }

  window.game = new Game($('body'));
  window.test = function(string) { $('#test').text(string); }
});
