$(function() {
  var DOTB = DOTB || {};
  DOTB.Game = {
    setup: function(gameScreen) {
      this.connection = new WebSocket('ws://192.168.69.69:8080');
      this.connection.onmessage = function (e) {
        updateGame(e.data);
      }
    },
    updateGame: function(newGame) {
      console.log(newGame);
    }
  }

  DOTB.Game.setup($('body'));
});
