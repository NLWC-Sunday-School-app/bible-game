import 'package:get_storage/get_storage.dart';

class BaseUrlService {
   var token = GetStorage().read('user_token');
   var baseUrl = 'https://plankton-app-ikxuv.ondigitalocean.app';
   var avatarApiKey = 'aUl0WdNmqyJus8';
   Map<String, String> headers = {'Content-Type': 'application/json','accept': 'application/json', 'Authorization': 'Bearer ${GetStorage().read('user_token')}'};

}