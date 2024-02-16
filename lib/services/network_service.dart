import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voice_assistant/utils/secrets.dart';

// a global variable that has the instance of  the network service which you can replace the api key here easily and it works still
final networkService = NetworkService(apiKey: openAPIKey);

// creating a sealed class that would expose api the state and conceive the data based on the state.
// you can add more state based on the future scenerios , e.g NoInternetState and emit the state in Socket exception
sealed class NetworkState {}

class NetworkSuccess extends NetworkState {
  final dynamic data;
  final int? statusCode;
  NetworkSuccess({this.data, this.statusCode});
}

class NetworkError extends NetworkState {
  final String? errorMessage;
  NetworkError({this.errorMessage = ""});
}

class NetworkService {
  String? apiKey;
  NetworkService({this.apiKey});

  Future<NetworkState> postRequest({required String url, dynamic body}) async {
    final res = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(body ?? {}),
    );
    if (res.statusCode == 200) {
      return NetworkSuccess(
        data: jsonDecode(res.body),
        statusCode: res.statusCode,
      );
    } else {
      return NetworkError(errorMessage: "An internal error occured");
    }
  }
}
