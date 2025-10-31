import 'package:mytravaly/features/Dashboard/domain/entities/dasboard_hotel_list_entity.dart';
import 'package:mytravaly/features/Dashboard/domain/repositories/dasboard_hotel_list_repo.dart';

class GetHotelsUseCase {
  final DashboardRepository repository;
  GetHotelsUseCase(this.repository);

  Future<List<HotelEntity>> getHotelList({required String visitorToken}) {
    return repository.getHotels(visitorToken: visitorToken);
  }
}
