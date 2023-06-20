import '../utils/utils.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String> getBranches() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.geoUsersEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print(e);
    }
    return "";
  }
}