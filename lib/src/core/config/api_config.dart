Map environmentList = {
  'local': 'http://192.168.29.50:4020/', //Local base url
  'develop': 'https://api-musiq.applogiq.org/', //Develop base url
  'production': 'http://192.168.29.50:4020/' //Production base url
};

String environment = "develop";

var hostConfig = {"api_url": environmentList[environment]};
