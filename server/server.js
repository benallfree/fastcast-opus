var crypto = require('crypto');

var host = "127.0.0.1", port = 33333;

var dgram = require( "dgram" );

var server = dgram.createSocket( "udp4" );

server.on( "message", function( msg, rinfo ) {
  console.log(crypto.createHash('sha512').update(msg).digest('hex'));
  server.send( msg, 0, msg.length, rinfo.port, rinfo.address ); 
});
server.bind( port, host );
