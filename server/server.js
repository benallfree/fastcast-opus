var host = "192.168.1.118", port = 33333;

var dgram = require( "dgram" );

var server = dgram.createSocket( "udp4" );

server.on( "message", function( msg, rinfo ) {
    console.log( rinfo.address + ':' + rinfo.port + ' - ' + msg.byteLength + ' bytes received. Echoing back.' );
    server.send( msg, 0, msg.length, rinfo.port, rinfo.address ); 
});
server.bind( port, host );
