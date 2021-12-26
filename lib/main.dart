import 'dart:ui';

import 'package:devkitflutter/bloc/example/bloc.dart';
import 'package:devkitflutter/bloc/product_grid/bloc.dart';
import 'package:devkitflutter/bloc/product_listview/bloc.dart';
import 'package:devkitflutter/bloc/student/bloc.dart';
import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/cubit/firestore/firestore_cubit.dart';
import 'package:devkitflutter/cubit/language/language_cubit.dart';
import 'package:devkitflutter/cubit/theme/theme_cubit.dart';
import 'package:devkitflutter/ui/feature/multi_language/app_localizations.dart';
import 'package:devkitflutter/ui/feature/multi_language/initial_language.dart';
import 'package:devkitflutter/ui/feature/multi_language/tk_localizations.dart';
import 'package:devkitflutter/ui/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'bloc/authentication/login/login_bloc.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['assets/google_fonts'], license);
  });

  // this function makes application always run in portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    _initializeFirebase();
    runApp(MyApp());
  });
}

void _initializeFirebase() async{
  await Firebase.initializeApp();
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

/*InitialLanguage and BlocBuilder is used for language feature, if you don't want to use multiple language, you can skip
  InitialLanguage and BlocBuilder and just used MaterialApp without supportedLocales, localizationsDelegates and locale
  check the example without language feature at the bottom of this page*/
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Initialize all bloc provider used on this entire application here
    return MultiBlocProvider(
      providers: [
        // this bloc used for feature - change language
        BlocProvider<LanguageCubit>(
          create: (BuildContext context) => LanguageCubit(),
        ),
        // this bloc used to change theme on feature list
        BlocProvider<ThemeCubit>(
          create: (BuildContext context) => ThemeCubit(),
        ),
        BlocProvider<FirestoreCubit>(
          create: (BuildContext context) => FirestoreCubit(),
        ),
        // this bloc used for integration - api
        BlocProvider<ExampleBloc>(
          create: (BuildContext context) => ExampleBloc(),
        ),
        // this bloc used for integration - api
        BlocProvider<StudentBloc>(
          create: (BuildContext context) => StudentBloc(),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
        BlocProvider<ProductGridBloc>(
          create: (BuildContext context) => ProductGridBloc(),
        ),
        BlocProvider<ProductListviewBloc>(
          create: (BuildContext context) => ProductListviewBloc(),
        ),
      ],
      // if you want to change default language, go to lib/ui/feature/multi_language/initial_language.dart and change en US to your default language
      child: InitialLanguage(
        child: BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, state) {
            return MaterialApp(
              scrollBehavior: MyCustomScrollBehavior(),
              title: APP_NAME,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  /*
                  Below is the example to change MaterialPageRoute default transition in iOS and Android :
                   FadeUpwardsPageTransitionsBuilder() <= Default MaterialPageRoute Transition
                   OpenUpwardsPageTransitionsBuilder()
                   ZoomPageTransitionsBuilder()
                   CupertinoPageTransitionsBuilder()
                  */
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                }),
              ),
              // below is used for language feature
              supportedLocales: [
                Locale('en', 'US'),
                Locale('id', 'ID'),
                Locale('ar', 'DZ'),
                Locale('zh', 'HK'),
                Locale('hi', 'IN'),
                Locale('th', 'TH'),
                Locale('tk', 'TK'),
              ],
              // These delegates make sure that the localization data for the proper language is loaded
              localizationsDelegates: [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                MaterialLocalizationTkDelegate() // Add for custom localizations, if not use custom localization, remove this line
              ],
              // Returns a locale which will be used by the app
              locale: (state is ChangeLanguageSuccess)?state.locale:Locale('en', 'US'),
              home: SplashScreenPage(),
            );
          }
        ),
      ),
    );
  }
}

// This is the example without multi language, uncomment to use it
/*
class MyApps extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Initialize all bloc provider used on this entire application here
    return MaterialApp(
      title: APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          */
/*
          Below is the example to change MaterialPageRoute default transition in iOS and Android :
           FadeUpwardsPageTransitionsBuilder() <= Default MaterialPageRoute Transition
           OpenUpwardsPageTransitionsBuilder()
           ZoomPageTransitionsBuilder()
           CupertinoPageTransitionsBuilder()
          *//*

          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
      ),
      home: SplashScreenPage(),
    );
  }
}*/
