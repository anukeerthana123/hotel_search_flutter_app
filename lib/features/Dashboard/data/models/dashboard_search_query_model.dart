import 'dart:convert';

class HotelSearchRequestModel {
  final String action;
  final GetSearchResultListOfHotels getSearchResultListOfHotels;

  HotelSearchRequestModel({
    required this.action,
    required this.getSearchResultListOfHotels,
  });

  factory HotelSearchRequestModel.fromJson(Map<String, dynamic> json) {
    return HotelSearchRequestModel(
      action: json['action'] ?? '',
      getSearchResultListOfHotels: GetSearchResultListOfHotels.fromJson(
        json['getSearchResultListOfHotels'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "action": action,
        "getSearchResultListOfHotels": getSearchResultListOfHotels.toJson(),
      };

  String toRawJson() => jsonEncode(toJson());

  factory HotelSearchRequestModel.fromRawJson(String str) =>
      HotelSearchRequestModel.fromJson(jsonDecode(str));
}

/// Wrapper containing searchCriteria
class GetSearchResultListOfHotels {
  final SearchCriteria searchCriteria;

  GetSearchResultListOfHotels({required this.searchCriteria});

  factory GetSearchResultListOfHotels.fromJson(Map<String, dynamic> json) {
    return GetSearchResultListOfHotels(
      searchCriteria: SearchCriteria.fromJson(json['searchCriteria'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        "searchCriteria": searchCriteria.toJson(),
      };
}

/// Actual user search details
class SearchCriteria {
  final String? checkIn;
  final String? checkOut;
  final int rooms;
  final int adults;
  final int children;
  final String searchType;
  final List<String> searchQuery;
  final List<String> accommodation;
  final List<String> arrayOfExcludedSearchType;
  final String highPrice;
  final String lowPrice;
  final int limit;
  final List<dynamic> preloaderList;
  final String currency;
  final int rid;

  SearchCriteria({
    this.checkIn,
    this.checkOut,
    required this.rooms,
    required this.adults,
    required this.children,
    required this.searchType,
    required this.searchQuery,
    required this.accommodation,
    required this.arrayOfExcludedSearchType,
    required this.highPrice,
    required this.lowPrice,
    required this.limit,
    required this.preloaderList,
    required this.currency,
    required this.rid,
  });

  factory SearchCriteria.fromJson(Map<String, dynamic> json) {
    return SearchCriteria(
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      rooms: json['rooms'] ?? 1,
      adults: json['adults'] ?? 1,
      children: json['children'] ?? 0,
      searchType: json['searchType'] ?? '',
      searchQuery: List<String>.from(json['searchQuery'] ?? []),
      accommodation: List<String>.from(json['accommodation'] ?? []),
      arrayOfExcludedSearchType:
          List<String>.from(json['arrayOfExcludedSearchType'] ?? []),
      highPrice: json['highPrice'] ?? '0',
      lowPrice: json['lowPrice'] ?? '0',
      limit: json['limit'] ?? 10,
      preloaderList: List<dynamic>.from(json['preloaderList'] ?? []),
      currency: json['currency'] ?? 'INR',
      rid: json['rid'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "checkIn": checkIn ?? "",
        "checkOut": checkOut ?? "",
        "rooms": rooms,
        "adults": adults,
        "children": children,
        "searchType": searchType,
        "searchQuery": searchQuery,
        "accommodation": accommodation,
        "arrayOfExcludedSearchType": arrayOfExcludedSearchType,
        "highPrice": highPrice,
        "lowPrice": lowPrice,
        "limit": limit,
        "preloaderList": preloaderList,
        "currency": currency,
        "rid": rid,
      };
}
