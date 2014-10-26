$(function() {

  // Set up sounds
  var shotgunSound = new Howl({
    urls: ['audio/shotgun.mp3']
  });

  var deadSound = new Howl({
    urls: ['audio/dead.mp3']
  });

  var reloadSound = new Howl({
    urls: ['audio/reload.mp3']
  });

  var startSound = new Howl({
    urls: ['audio/start.mp3']
  });

  var hitSound = new Howl({
    urls: ['audio/hit.mp3']
  });

  function Game(view) {

    // Setup
    var self = this;
    this.view = view;
    this.enemies = 0;
    this.currentLocation = 1;
    this.gameState = 'ready';
    this.connected = false;
    this.playerId = 0;
    this.ammo = 0;
    updateGameActive();

    if (window.location.hostname == "hackman.llamadigital.net") {
      this.connection = new WebSocket('wss://hackman.llamadigital.net:8080');
    } else {
      this.connection = new WebSocket('ws://192.168.69.69:8080'); } this.connection.onmessage = function (e) {
      var parsedData = JSON.parse(e.data);
      console.log(e.data);
      if (parsedData.message) {
        // android.showMessage(message);
        console.log(parseData.message);
      } else if (self.connected) {
        updateGame(parsedData);
      } else {
        self.playerId = parsedData.config.id;
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

      // update state
      self.gameState = newGame.state

      // update ammo
      self.ammo = newGame.me.ammo;

      updateGameActive(newGame);

      if(newGame.health > 0) {
        view.find('#current-location').show();
        view.find('#base-status h3').show();
        view.find('#base-status h2').text('Base health: ' + newGame.health + '%');
        view.find('#base-status h3').text('Killed ' + newGame.me.score + ' enemies in ' + newGame.duration + ' seconds');
        view.find('#base-status .game-over').hide();
      } else {
        deadSound.play();
        view.find('#current-location').hide();
        view.find('#base-status h2').text("Game over!");
        view.find('#base-status .game-over').show();
      }
      showAmmunition(self.ammo);
      if (self.currentLocation > 1) {
        self.enemies = newGame.towers[self.currentLocation - 2].enemies;
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
        enemyContainer.append("<span class='enemy'><span>"); 
      }
    }
    function showAmmunition(count) {
      ammoContainer = view.find("#ammunition");
      ammoContainer.empty();
      for (i = 0 ; i < count ; i++) {
        ammoContainer.append("<span class='bullet'><span>"); 
      }
    }
    function attack() {
      if (self.ammo > 0) {
        shotgunSound.play();
        hitSound.play();
        window.navigator.vibrate(200);
        var newAttack = { "action": "user", "location": self.currentLocation }
        self.connection.send(JSON.stringify(newAttack));
        self.ammo -= 1;
        showAmmunition(self.ammo);
      }
    }
    function start() {
      view.find('#base-status .loading').hide();
      var newAction = { "action": "restart" }
      updateGameActive();
      self.connection.send(JSON.stringify(newAction));
      var newAction = { "action": "start" }
      startSound.play();
      updateGameActive();
      self.connection.send(JSON.stringify(newAction));
    }
    function reload() {
      reloadSound.play();
      var newAction = { "action": "user", "location": self.currentLocation }
      self.connection.send(JSON.stringify(newAction));
      showAmmunition(self.ammo);
    }

    function updateGameActive() {
      if (self.gameState == 'ready') {
        view.find('#start').show();
        view.find('#action').hide();
      }
      if (self.gameState == 'active') {
        view.find('#start').hide();
        view.find('#action').show();
      }
      if (self.gameState == 'game_over')  {
        view.find('#start').show();
        view.find('#action').hide();
      }
    }

    this.updateLocation = function(location) {
      self.currentLocation = location;
      if (location == 1) {
        view.find('#current-location h2').text('Base');
        view.find('#action').html('Reload');
      } else {
        view.find('#current-location h2').text('Tower: '+ location);
        view.find('#action').html('Attack!!!!!');
      }
      var newLocation = { "location": location }
      self.connection.send(JSON.stringify(newLocation));
    }
  }

  window.game = new Game($('body'));
  window.test = function(string) { $('#test').text(string); }
});
