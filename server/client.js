// NOTE: the port is different
var host = "127.0.0.1", port = 33334;

var dgram = require( "dgram" );

var client = dgram.createSocket( "udp4" );

client.on( "message", function( msg, rinfo ) {
    console.log( "The packet came back" );
    console.log(msg.byteLength);
    console.log(msg.toString());
});

// client listens on a port as well in order to receive ping
client.bind( port, host );

// proper message sending
// NOTE: the host/port pair points at server
function send()
{
  var messages = [
    "My KungFu is Good!",
    "My Kenpo is much better",
    "Hapkido is my favorite",
    "I am Royce Gracie and you all will lose",
  ];
  var message = new Buffer(messages[Math.floor(Math.random()*messages.length)]);
  client.send(message, 0, message.length, 33333, "127.0.0.1" );
  setTimeout(send, 1000);
}
send();