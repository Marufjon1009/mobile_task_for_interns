import 'package:flutter/material.dart';
import 'package:mobile_task_for_interns/pages/main_page/main_provider.dart';
import 'package:mobile_task_for_interns/pages/main_page/main_view.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainProvider>(
        lazy: false,
        create: (context) => MainProvider(context),
        child: Builder(
          builder: (context) {
            return const MainView();
          },
        ));
  }
}
