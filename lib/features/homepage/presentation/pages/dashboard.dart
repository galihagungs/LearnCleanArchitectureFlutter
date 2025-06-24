import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app_clean_architecture/features/homepage/presentation/cubit/dasboard_cubit_cubit.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: context.watch<DasboardCubitCubit>().page,
      bottomNavigationBar: Material(
        elevation: 10,
        child: BlocBuilder<DasboardCubitCubit, int>(
          builder: (context, state) {
            return NavigationBar(
              height: 60,
              labelPadding: const EdgeInsets.symmetric(horizontal: 14),
              selectedIndex: state,
              onDestinationSelected: (value) {
                context.read<DasboardCubitCubit>().change(value);
              },
              backgroundColor: Colors.white,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations:
                  context.read<DasboardCubitCubit>().tabs.map((e) {
                    return NavigationDestination(
                      icon: Icon(e[1], color: Colors.grey[500]),
                      label: e[0],
                      selectedIcon: Icon(e[1], color: Colors.blue),
                    );
                  }).toList(),
            );
          },
        ),
      ),
    );
  }
}
