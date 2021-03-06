
/*
  CfiClient listener that logs incoming and outgoing messages 
  into the console textarea. 
*/

var ConsoleListener = function( filterArr ) {

    this.filters = filterArr ? filterArr : [];

    this.filterMessage = function(message) {
	var filter = false;
	_.each(this.filters, function(f) {
	    // no regular expressions yet!
	    if (message.indexOf(f) == 0) {
		filter = true;
	    }
	});
	return filter;
    };
    
    this.writeMessage = function(message, incoming) {
	if( !this.filterMessage(message)) {
	    gameConsole.write( (incoming ? '< ' : '> ') + message);
	}
    };

};

ConsoleListener.prototype.onOpen = function(evt) {
    this.writeMessage('Connected', true);
 };

ConsoleListener.prototype.onClose = function(evt) {
    this.writeMessage('DISCONNECTED', true);
}

ConsoleListener.prototype.onMessage = function(evt) {
    this.writeMessage(evt.data, true);
}

ConsoleListener.prototype.onError = function(evt) {
    this.writeMessage('ERROR: ' + evt.data, true);
}

ConsoleListener.prototype.doSend = function(message) {
    this.writeMessage(message, false);
}
