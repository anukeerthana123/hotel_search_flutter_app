class SearchHotelEntity {
  final String propertyName;
  final int propertyStar;
  final PropertyImageModelEntity propertyImage;
  final String propertyCode;
  final String propertyType;
  final PropertyPoliciesAndAmenitiesEntity propertyPoliciesAndAmenities;
  final PriceEntity markedPrice;
  final PriceEntity staticPrice;
  final GoogleReviewEntity googleReview;
  final String propertyUrl;
  final PropertyAddressEntity propertyAddress;

  const SearchHotelEntity({
    required this.propertyName,
    required this.propertyStar,
    required this.propertyImage,
    required this.propertyCode,
    required this.propertyType,
    required this.propertyPoliciesAndAmenities,
    required this.markedPrice,
    required this.staticPrice,
    required this.googleReview,
    required this.propertyUrl,
    required this.propertyAddress,
  });
}

class PriceEntity {
  final double amount;
  final String displayAmount;
  final String currencyAmount;
  final String currencySymbol;

  const PriceEntity({
    required this.amount,
    required this.displayAmount,
    required this.currencyAmount,
    required this.currencySymbol,
  });
}

class PropertyPoliciesAndAmenitiesEntity {
  final bool present;
  final PropertyPolicyDataEntity? data;

  const PropertyPoliciesAndAmenitiesEntity({
    required this.present,
    required this.data,
  });
}

class PropertyPolicyDataEntity {
  final String cancelPolicy;
  final String refundPolicy;
  final String childPolicy;
  final String damagePolicy;
  final String propertyRestriction;
  final bool petsAllowed;
  final bool coupleFriendly;
  final bool suitableForChildren;
  final bool bachularsAllowed;
  final bool freeWifi;
  final bool freeCancellation;
  final bool payAtHotel;
  final bool payNow;

  const PropertyPolicyDataEntity({
    required this.cancelPolicy,
    required this.refundPolicy,
    required this.childPolicy,
    required this.damagePolicy,
    required this.propertyRestriction,
    required this.petsAllowed,
    required this.coupleFriendly,
    required this.suitableForChildren,
    required this.bachularsAllowed,
    required this.freeWifi,
    required this.freeCancellation,
    required this.payAtHotel,
    required this.payNow,
  });
}

class GoogleReviewEntity {
  final bool reviewPresent;
  final double? overallRating;
  final int? totalUserRating;

  const GoogleReviewEntity({
    required this.reviewPresent,
    this.overallRating,
    this.totalUserRating,
  });
}

class PropertyAddressEntity {
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipcode;
  final String mapAddress;
  final double latitude;
  final double longitude;

  const PropertyAddressEntity({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipcode,
    required this.mapAddress,
    required this.latitude,
    required this.longitude,
  });
}

class PropertyImageModelEntity {
  final String fullUrl;
  final String location;
  final String imageName;

  const PropertyImageModelEntity({
    required this.fullUrl,
    required this.location,
    required this.imageName,
  });
}
