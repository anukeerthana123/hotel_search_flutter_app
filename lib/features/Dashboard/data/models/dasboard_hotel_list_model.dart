import 'package:mytravaly/features/Dashboard/domain/entities/dasboard_hotel_list_entity.dart';

class HotelModel extends HotelEntity {
  const HotelModel({
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

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      propertyName: json['propertyName'] ?? '',
      propertyStar: json['propertyStar'] ?? 0,
      propertyImage: json['propertyImage'] ?? '',
      propertyCode: json['propertyCode'] ?? '',
      propertyType: json['propertyType'] ?? '',
      propertyPoliciesAndAmenities: PropertyPoliciesAndAmenitiesModel.fromJson(
          json['propertyPoliciesAndAmmenities']),
      markedPrice: PriceModel.fromJson(json['markedPrice']),
      staticPrice: PriceModel.fromJson(json['staticPrice']),
      googleReview: GoogleReviewModel.fromJson(json['googleReview']),
      propertyUrl: json['propertyUrl'] ?? '',
      propertyAddress: PropertyAddressModel.fromJson(json['propertyAddress']),
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
