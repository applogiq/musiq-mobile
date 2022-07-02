import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart'as http;
import 'package:musiq/src/helpers/constants/api.dart';
class APICall{
   var storage=FlutterSecureStorage();
 
  var header={ 'Content-type': 'application/json',
              'Accept': 'application/json',
              // "Authorization": "Bearer $token"
              };
  putRequestWithAuth(String endPoint,Map params)async{
     var token=await storage.read(key: "access_token");
     var user_id=await storage.read(key: "register_id");
     header["Authorization"]="Bearer $token";
     params["user_id"]= user_id;

    var url=Uri.parse(APIConstants.BASE_URL+endPoint);
     print(url);
     print(jsonEncode( params));

    var response=await http.put(url,headers: header,body:jsonEncode(params) );
    print(response.statusCode);
    return response;
   
    // var response=http.put();
  }
   getRequestWithAuth(String urlAddress,{Map? params})async{
     var token=await storage.read(key: "access_token");
     header["Authorization"]="Bearer $token";
  

    var url=Uri.parse(urlAddress);

    var response=await http.get(url,headers: header, );
    
    return response;
   
    // var response=http.put();
  }
  postRequestWithoutAuth(Uri url,Map params)async{
     
    
    print(params);
    
     print(url);
    
    var response=await http.post(url, body: jsonEncode(params), headers
    : header);
              return response;
  }
postRequestWithAuth(String url,Map params)async{
  var token=await storage.read(key: "access_token");
     var user_id=await storage.read(key: "id");
     header["Authorization"]="Bearer $token";
     params["user_id"]= int.parse(user_id!);
     print(url);
     print(jsonEncode( params));
      var response=await http.post(Uri.parse(url),headers: header,body: jsonEncode(params) );
    
    return response;
}
}