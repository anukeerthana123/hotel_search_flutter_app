import 'package:mytravaly/features/Dashboard/data/models/dashboard_search_query_model.dart';

abstract class DashboardEvent {}

class LoadHotelsEvent extends DashboardEvent {
  final String visitorToken;
  LoadHotelsEvent(this.visitorToken);
}

class SearchHotels extends DashboardEvent {
  final HotelSearchRequestModel hotelSearchRequestModel;
  SearchHotels(this.hotelSearchRequestModel);

  @override
  List<Object?> get props => [hotelSearchRequestModel];
}
