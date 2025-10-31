import 'package:mytravaly/features/Dashboard/data/datasources/dasboard_data_source.dart';
import 'package:mytravaly/features/Dashboard/data/models/dasboard_hotel_list_model.dart';
import 'package:mytravaly/features/Dashboard/domain/repositories/dasboard_hotel_list_repo.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardHotelRemoteDataSource dataSource;

  DashboardRepositoryImpl(this.dataSource);

  @override
  Future<List<HotelModel>> getHotels({required String visitorToken}) async {
    try {
      final hotels =
          await dataSource.getPopularStay(visitorToken: visitorToken);
      return hotels;
    } catch (e) {
      rethrow;
    }
  }
}
