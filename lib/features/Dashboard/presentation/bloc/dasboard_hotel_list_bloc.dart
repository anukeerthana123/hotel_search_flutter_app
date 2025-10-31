import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytravaly/features/Dashboard/data/datasources/dasboard_data_source.dart';
import 'package:mytravaly/features/Dashboard/domain/usecases/dasboard_hotel_list_usecase.dart';
import 'package:mytravaly/features/Dashboard/presentation/bloc/dasboard_hotel_list.event.dart';
import 'package:mytravaly/features/Dashboard/presentation/bloc/dasboard_hotel_list_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetHotelsUseCase useCase;
  final DashboardHotelRemoteDataSourceImpl dashboardHotelRemoteDataSourceImpl;

  DashboardBloc(this.useCase, this.dashboardHotelRemoteDataSourceImpl)
      : super(DashboardInitial()) {
    on<LoadHotelsEvent>((event, emit) async {
      emit(DashboardLoading());
      try {
        final hotels = await useCase.getHotelList(
          visitorToken: event.visitorToken,
        );
        emit(DashboardLoaded(hotels));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
    on<SearchHotels>((event, emit) async {
      emit(DashboardSearchListLoading());
      try {
        final hotels =
            await dashboardHotelRemoteDataSourceImpl.getSearchFilterHotel(
                hotelSearchRequestModel: event.hotelSearchRequestModel);
        emit(DashboardSearchListLoaded(hotels));
      } catch (e) {
        emit(DashboardSearchListError(e.toString()));
      }
    });
  }
}
