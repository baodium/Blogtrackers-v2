//var app_url = "http://localhost:8080/Blogtrackers/";
var app_url = "http://blogtrackers.host.ualr.edu/Blogtrackers/";
  
var baseurl =  app_url;

  String.prototype.replaceAll = function(search, replacement) {
      var target = this;
      return target.split(search).join(replacement);
  };