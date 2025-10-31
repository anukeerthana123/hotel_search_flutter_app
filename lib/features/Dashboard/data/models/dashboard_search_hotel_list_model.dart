import 'package:mytravaly/features/Dashboard/domain/entities/dashboard_search_hotel_list_entity.dart';

class SearchHotelModel extends SearchHotelEntity {
  const SearchHotelModel({
    required super.propertyName,
    required super.propertyStar,
    required super.propertyImage,
    required super.propertyCode,
    required super.propertyType,
    required super.propertyPoliciesAndAmenities,
    required super.markedPrice,
    required super.staticPrice,
    required super.googleReview,
    required super.propertyUrl,
    required super.propertyAddress,
  });

  factory SearchHotelModel.fromJson(Map<String, dynamic> json) {
    return SearchHotelModel(
      propertyName: json['propertyName'] ?? '',
      propertyStar: json['propertyStar'] ?? 0,
      propertyImage: json['propertyImage'] != null
          ? PropertyImageModel.fromJson(
              (json['propertyImage'] as Map<String, dynamic>))
          : const PropertyImageModel(fullUrl: '', location: '', imageName: ''),
      propertyCode: json['propertyCode'] ?? '',
      propertyType: json['propertytype'] ?? '',
      propertyPoliciesAndAmenities: json['propertyPoliciesAndAmmenities'] !=
              null
          ? PropertyPoliciesAndAmenitiesModel.fromJson(
              (json['propertyPoliciesAndAmmenities'] as Map<String, dynamic>))
          : const PropertyPoliciesAndAmenitiesModel(
              present: false,
              data: null,
            ),
      markedPrice: json['markedPrice'] != null
          ? PriceModel.fromJson(json['markedPrice'])
          : const PriceModel(
              amount: 0,
              displayAmount: '',
              currencyAmount: '',
              currencySymbol: '',
            ),
      staticPrice: json['staticPrice'] != null
          ? PriceModel.fromJson(json['staticPrice'])
          : const PriceModel(
              amount: 0,
              displayAmount: '',
              currencyAmount: '',
              currencySymbol: '',
            ),
      googleReview: json['googleReview'] != null
          ? GoogleReviewModel.fromJson(json['googleReview'])
          : const GoogleReviewModel(reviewPresent: false),
      propertyUrl: json['propertyUrl'] ?? '',
      propertyAddress: json['propertyAddress'] != null
          ? PropertyAddressModel.fromJson(json['propertyAddress'])
          : const PropertyAddressModel(
              street: '',
              city: '',
              state: '',
              country: '',
              zipcode: '',
              mapAddress: '',
              latitude: 0.0,
              longitude: 0.0,
            ),
    );
  }
}

class PropertyImageModel extends PropertyImageModelEntity {
  const PropertyImageModel({
    required super.fullUrl,
    required super.location,
    required super.imageName,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageModel(
      fullUrl: json['fullUrl'] ?? '',
      location: json['location'] ?? '',
      imageName: json['imageName'] ?? '',
    );
  }
}

class PriceModel extends PriceEntity {
  const PriceModel({
    required super.amount,
    required super.displayAmount,
    required super.currencyAmount,
    required super.currencySymbol,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      amount: (json['amount'] ?? 0).toDouble(),
      displayAmount: json['displayAmount'] ?? '',
      currencyAmount: json['currencyAmount'] ?? '',
      currencySymbol: json['currencySymbol'] ?? '',
    );
  }
}

class PropertyPoliciesAndAmenitiesModel
    extends PropertyPoliciesAndAmenitiesEntity {
  const PropertyPoliciesAndAmenitiesModel({
    required super.present,
    required super.data,
  });

  factory PropertyPoliciesAndAmenitiesModel.fromJson(
      Map<String, dynamic> json) {
    return PropertyPoliciesAndAmenitiesModel(
      present: json['present'] ?? false,
      data: json['data'] != null
          ? PropertyPolicyDataModel.fromJson(json['data'])
          : null,
    );
  }
}

class PropertyPolicyDataModel extends PropertyPolicyDataEntity {
  const PropertyPolicyDataModel({
    required super.cancelPolicy,
    required super.refundPolicy,
    required super.childPolicy,
    required super.damagePolicy,
    required super.propertyRestriction,
    required super.petsAllowed,
    required super.coupleFriendly,
    required super.suitableForChildren,
    required super.bachularsAllowed,
    required super.freeWifi,
    required super.freeCancellation,
    required super.payAtHotel,
    required super.payNow,
  });

  factory PropertyPolicyDataModel.fromJson(Map<String, dynamic> json) {
    return PropertyPolicyDataModel(
      cancelPolicy: json['cancelPolicy'] ?? '',
      refundPolicy: json['refundPolicy'] ?? '',
      childPolicy: json['childPolicy'] ?? '',
      damagePolicy: json['damagePolicy'] ?? '',
      propertyRestriction: json['propertyRestriction'] ?? '',
      petsAllowed: json['petsAllowed'] ?? false,
      coupleFriendly: json['coupleFriendly'] ?? false,
      suitableForChildren: json['suitableForChildren'] ?? false,
      bachularsAllowed: json['bachularsAllowed'] ?? false,
      freeWifi: json['freeWifi'] ?? false,
      freeCancellation: json['freeCancellation'] ?? false,
      payAtHotel: json['payAtHotel'] ?? false,
      payNow: json['payNow'] ?? false,
    );
  }
}

class GoogleReviewModel extends GoogleReviewEntity {
  const GoogleReviewModel({
    required super.reviewPresent,
    super.overallRating,
    super.totalUserRating,
  });

  factory GoogleReviewModel.fromJson(Map<String, dynamic> json) {
    return GoogleReviewModel(
      reviewPresent: json['reviewPresent'] ?? false,
      overallRating: json['data']?['overallRating']?.toDouble(),
      totalUserRating: json['data']?['totalUserRating'],
    );
  }
}

class PropertyAddressModel extends PropertyAddressEntity {
  const PropertyAddressModel({
    required super.street,
    required super.city,
    required super.state,
    required super.country,
    required super.zipcode,
    required super.mapAddress,
    required super.latitude,
    required super.longitude,
  });

  factory PropertyAddressModel.fromJson(Map<String, dynamic> json) {
    return PropertyAddressModel(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipcode: json['zipcode'] ?? '',
      mapAddress: json['map_address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}
