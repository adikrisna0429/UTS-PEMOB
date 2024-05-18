import 'dart:io';

import 'package:adikris_211510007/dto/cs.dart';
import 'package:adikris_211510007/dto/division.dart';
import 'package:adikris_211510007/dto/priorities.dart';
import 'package:adikris_211510007/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

// import 'package:sechandbook/screens/CS_Screen/customer_screen.dart';

class DataService {
  //API CS
  static Future<http.Response> getPriorityOptions() async {
    final url = 'https://simobile.singapoly.com/api/priority-issues';
    final response = await http.get(Uri.parse(url));
    return response;
  }

  static Future<http.Response> getDepartmentOptions() async {
    final url = 'https://simobile.singapoly.com/api/division-department';
    final response = await http.get(Uri.parse(url));
    return response;
  }

  static Future<List<CustomerService>> fetchCustomerService() async {
    final response = await http.get(Uri.parse(Endpoints.newscs));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => CustomerService.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Ketika data gagal diinput
      throw Exception('Failed to load data');
    }
  }

  static Future<List<Priority>> fetchPriority() async {
    final response = await http.get(Uri.parse(Endpoints.priority));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Priority.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Ketika data gagal diinput
      throw Exception('Failed to load data');
    }
  }

  static Future<List<Division>> fetchDivision() async {
    final response = await http.get(Uri.parse(Endpoints.division));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Division.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Ketika data gagal diinput
      throw Exception('Failed to load data');
    }
  }

  static Future<void> deleteCustomerService(
    int idCustomerService,
  ) async {
    final url =
        '${Endpoints.newscs}/$idCustomerService'; // URL untuk menghapus data dengan ID tertentu

    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Data');
    }
  }

  static Future<void> postDataWithImage(
    String title,
    String description,
    int rating,
    String priority,
    String division,
    File image,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse(Endpoints.newscs));
    request.fields['title_issues'] = title;
    request.fields['description_issues'] = description;
    request.fields['rating'] = rating.toString();
    request.fields['priority'] = priority;
    request.fields['division'] = division;

    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      image.path,
    );
    request.files.add(multipartFile);

    request.send().then((response) {
      if (response.statusCode == 201) {
        print('Data and image posted successfully!');
      } else {
        print('Error posting data: ${response.statusCode}');
      }
    });
  }

  static Future<void> editDataWithImage(
    int idCustomerService,
    String title,
    String description,
    int rating,
    String priority,
    String division,
    File image,
  ) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Endpoints.newscs}/$idCustomerService'));
    request.fields['title_issues'] = title;
    request.fields['description_issues'] = description;
    request.fields['rating'] = rating.toString();
    request.fields['priority'] = priority;
    request.fields['division'] = division;

    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      image.path,
    );
    request.files.add(multipartFile);

    request.send().then((response) {
      if (response.statusCode == 200) {
        print('Data and image updated successfully!');
      } else {
        print('Error updating data: ${response.statusCode}');
      }
    });
  }
}
