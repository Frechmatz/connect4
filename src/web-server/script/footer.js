
/*
  Controller of the footer.
 */

var Footer = function() {

    var footerId = "footer";
    var clickHereMsg = 'Click here to start a new game.';
    
    this.setHumanPlayersToken = function(token) {
	var f = document.getElementById(footerId);
	var c = f.querySelector('.human-players-token-indicator');
	c.setAttribute('data-human-players-token', token);
    };

    var indicateFinalStateImpl = function(state, message) {
	var f = document.getElementById(footerId);
	var c = f.querySelector('.final-state-click-to-continue');
	c.dataset.value =  state ? state : 'OFF';
	var p = c.querySelector('p');
	p.textContent = message ? message : '';
    };

    this.indicateComputerHasWon = function() {
	indicateFinalStateImpl('COMPUTER_HAS_WON', 'The computer has won. ' + clickHereMsg);
    };
    this.indicateHumanHasWon = function() {
	indicateFinalStateImpl('HUMAN_HAS_WON', 'You have won. ' + clickHereMsg);
    };
    this.indicateDraw = function() {
	indicateFinalStateImpl('DRAW', 'Draw. ' + clickHereMsg);
    };
    this.hideFinalGameStateIndicator = function() {
	indicateFinalStateImpl(null, '');
    };
    this.setFinalStateContinueHandler = function(handler) {
	var f = document.getElementById(footerId);
	var c = f.querySelector('.final-state-click-to-continue');
	c.onclick = function(event) {
	    event.preventDefault();
	    handler();
	}.bind(this);

    };
};
