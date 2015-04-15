var express = require('express');
var app = express();

app.get('/', function(req, res){
	  res.send('Hello world from tsuru');
});

var server = app.listen(process.env.PORT || 5000);
