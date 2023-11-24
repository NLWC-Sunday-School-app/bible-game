import 'package:get_storage/get_storage.dart';

class BaseUrlService {
   static var token = GetStorage().read('user_token');
   static var baseUrl = 'https://plankton-app-ikxuv.ondigitalocean.app';
   static var avatarBaseUrl = 'https://api.multiavatar.com';
   static var avatarApiKey = 'aUl0WdNmqyJus8';
   Map<String, String> headers = {'Content-Type': 'application/json','accept': 'application/json', 'Authorization': 'Bearer ${GetStorage().read('user_token')}'};

}