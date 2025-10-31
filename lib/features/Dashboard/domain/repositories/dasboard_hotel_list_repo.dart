import 'package:mytravaly/features/Dashboard/data/models/dasboard_hotel_list_model.dart';

abstract class DashboardRepository {
  Future<List<HotelModel>> getHotels({required String visitorToken});
}
