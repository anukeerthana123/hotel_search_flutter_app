import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mytravaly/features/Dashboard/data/datasources/dasboard_data_source.dart';
import 'package:mytravaly/features/Dashboard/data/repositories/dasboard_hotel_list_repo_impl.dart';
import 'package:mytravaly/features/Dashboard/domain/usecases/dasboard_hotel_list_usecase.dart';
import 'package:mytravaly/features/Dashboard/presentation/bloc/dasboard_hotel_list_bloc.dart';
import 'package:mytravaly/features/google_signIn_signUp/data/datasources/auth_data_source.dart';
import 'package:mytravaly/features/google_signIn_signUp/data/repositories/auth_repo_impl.dart';
import 'package:mytravaly/features/google_signIn_signUp/domain/usecases/auth_usecase.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/bloc/auth_bloc.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/screens/google_signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await Hive.openBox('tokenBox'); // Open a box for tokens
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthDataSource = AuthLocalDataSourceImpl();
    final AuthRepository = AuthRepositoryImpl(AuthDataSource);
    final AuthUseCaseBloc = AuthUseCase(AuthRepository);
    final DashboardHotelListDataSource = DashboardHotelRemoteDataSourceImpl();
    final DashboardHotelListRepository =
        DashboardRepositoryImpl(DashboardHotelListDataSource);
    final DashboardHotelListUsecase =
        GetHotelsUseCase(DashboardHotelListRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthUseCaseBloc),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => DashboardBloc(
              DashboardHotelListUsecase, DashboardHotelListDataSource),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Auth Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: GoogleSigninScreen(),
      ),
    );
  }
}
