import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/pages/homepage.dart';

class DasboardCubitCubit extends Cubit<int> {
  DasboardCubitCubit() : super(0);

  change(int i) => emit(i);

  final List tabs = [
    ['Home', Icons.home, const Homepage()],
    ['Near', Icons.search, const Center(child: Text('Near'))],
    ['Favorite', Icons.notifications, const Center(child: Text('Favorite'))],
    ['Profile', Icons.person, const Center(child: Text('Profile'))],
  ];

  Widget get page => tabs[state][2];
}
