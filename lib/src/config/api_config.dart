Map environmentList = {
  'local': 'http://192.168.29.50:4020/',
  'develop': 'https://api-musiq.applogiq.org/',
  'production': 'http://192.168.29.50:4020/'
};
String environment = "develop";

var hostConfig = {"api_url": environmentList[environment]};
