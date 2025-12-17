import 'package:flutter/material.dart';
import 'package:meucarronafipe/core/constants/app_constants.dart';
import 'package:meucarronafipe/core/theme/app_theme.dart';
import 'package:meucarronafipe/presentation/providers/consulta_provider';
import 'package:meucarronafipe/presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class MeuCarroNaFipeApp extends StatelessWidget {
  const MeuCarroNaFipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConsultaProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
