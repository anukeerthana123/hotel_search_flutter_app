import 'package:mytravaly/features/Dashboard/domain/entities/dasboard_hotel_list_entity.dart';
import 'package:mytravaly/features/Dashboard/domain/entities/dashboard_search_hotel_list_entity.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<HotelEntity> hotels;
  DashboardLoaded(this.hotels);
}

class DashboardSearchListLoading extends DashboardState {}

class DashboardSearchListLoaded extends DashboardState {
  final List<SearchHotelEntity> hotels;
  DashboardSearchListLoaded(this.hotels);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

class DashboardSearchListError extends DashboardState {
  final String message;
  DashboardSearchListError(this.message);
}
