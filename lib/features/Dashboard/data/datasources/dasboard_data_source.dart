import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mytravaly/core/utils/shared_preference.dart';
import 'package:mytravaly/features/Dashboard/data/models/dasboard_hotel_list_model.dart';
import 'package:mytravaly/features/Dashboard/data/models/dashboard_search_hotel_list_model.dart';
import 'package:mytravaly/features/Dashboard/data/models/dashboard_search_query_model.dart';

abstract class DashboardHotelRemoteDataSource {
  Future<List<HotelModel>> getPopularStay({
    required String visitorToken,
  });

  Future<List<SearchHotelModel>> getSearchFilterHotel({
    required HotelSearchRequestModel hotelSearchRequestModel,
  });
}

class DashboardHotelRemoteDataSourceImpl
    implements DashboardHotelRemoteDataSource {
  final baseUrl = dotenv.env['BASE_URL'];
  final token = dotenv.env['AUTH_TOKEN'];

  @override
  Future<List<HotelModel>> getPopularStay({
    required String visitorToken,
  }) async {
    final body = {
      "action": "popularStay",
      "popularStay": {
        "limit": 10,
        "entityType": "Any",
        "filter": {
          "searchType": "byCity",
          "searchTypeInfo": {
            "country": "byCountry",
            "state": "byState",
            "city": "byCity"
          }
        },
        "currency": "INR"
      }
    };

    final response = await http.post(
      Uri.parse(baseUrl!),
      headers: {
        "Content-Type": "application/json",
        "authtoken": token!,
        "visitortoken": visitorToken,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      final list = parsed["data"] as List;
      return list.map((e) => HotelModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load hotel list");
    }
  }

  @override
  Future<List<SearchHotelModel>> getSearchFilterHotel({
    required HotelSearchRequestModel hotelSearchRequestModel,
  }) async {
    final visitorToken = await TokenHelper.getVisitorToken();
    final response = await http.post(
      Uri.parse(baseUrl!),
      headers: {
        "Content-Type": "application/json",
        "authtoken": token!,
        "visitortoken": visitorToken!,
      },
      body: jsonEncode(hotelSearchRequestModel.toJson()),
    );

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      final list = parsed["data"]["arrayOfHotelList"] as List;
      return list.map((e) => SearchHotelModel.fromJson(e)).toList();
    } else {
      throw Exception(
          "Failed to load hotel list (Status Code: ${response.statusCode})");
    }
  }
}
