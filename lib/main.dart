import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app_clean_architecture/common/app_route.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/bloc/all_destination/all_destination_bloc.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/bloc/search_destination/search_destination_bloc.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/bloc/top_destination/top_destination_bloc.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/cubit/dasboard_cubit_cubit.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/pages/dashboard.dart';
import 'package:travel_app_clean_architecture/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DasboardCubitCubit()),
        BlocProvider(create: (_) => locator<AllDestinationBloc>()),
        BlocProvider(create: (_) => locator<TopDestinationBloc>()),
        BlocProvider(create: (_) => locator<SearchDestinationBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Travel App',

        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: DashboardPage(),
        initialRoute: AppRoute.dashboard,
        onGenerateRoute: AppRoute.generateRoute,
      ),
    );
  }
}
