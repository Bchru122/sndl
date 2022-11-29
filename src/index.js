var https = require('follow-redirects').https;
var qs = require('querystring');

var postData = qs.stringify({
  XXtask: 1,
  dlId: process.argv.slice(-3)[0],
  dob: process.argv.slice(-2)[0],
  last4ssn: process.argv.slice(-1)[0]
});

var options = {
  'method': 'POST',
  'hostname': 'txapps.texas.gov',
  'path': '/txapp/txdps/dleligibility/login.do',
  'headers': {
    'Content-Type': 'application/x-www-form-urlencoded'
  },
  'maxRedirects': 20
};

var req = https.request(options, function (res) {
  var chunks = [];

  res.on("data", function (chunk) {
    chunks.push(chunk);
  });

  res.on("end", function (chunk) {
    var data = Buffer.concat(chunks).toString();
    //console.log(data);
     if (data.includes('<h2>Error</h2>')) 
        console.log(postData, ": Fail")
     else if (data.includes('Logout')) 
        console.log(postData, ": Success")
     else
        console.log(postData, ": Unknown")
  });

  res.on("error", function (error) {
    console.error(error);
  });
});

req.write(postData);

req.end();