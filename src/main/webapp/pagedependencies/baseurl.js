
//var app_url = "http://localhost:8011/Blogtrackers/";
//var app_url = "http://localhost:8080/Blogtrackers/";

var app_url = "http://144.167.35.50:8011/Blogtrackers/";

//var app_url = "http://localhost:8011/Blogtrackers/";
//var app_url = "http://localhost:8080/Blogtrackers/";
//var app_url = "http://144.167.35.50:8080/Blogtrackers/";

//var app_url = "http://blogtrackers.host.ualr.edu/";
  
var baseurl =  app_url;

  String.prototype.replaceAll = function(search, replacement) {
      var target = this;
      return target.split(search).join(replacement);
  };