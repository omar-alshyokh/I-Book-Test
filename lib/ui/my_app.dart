import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_structure/blocs/application/application_bloc.dart';
import 'package:my_structure/blocs/application/application_state.dart';
import 'package:my_structure/blocs/main/root_page_bloc.dart';
import 'package:my_structure/constants/app_theme.dart';
import 'package:my_structure/constants/strings.dart';
import 'package:my_structure/data/repo/repository.dart';
import 'package:my_structure/di/components/service_locator.dart';
import 'package:my_structure/ui/splash/splash.dart';
import 'package:my_structure/utils/routes/routes.dart';
import 'package:my_structure/stores/language/language_store.dart';
import 'package:my_structure/stores/theme/theme_store.dart';
import 'package:my_structure/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  final ThemeStore _themeStore = ThemeStore(getIt<Repository>());
  final LanguageStore _languageStore = LanguageStore(getIt<Repository>());


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),

      child: MultiProvider(
        providers: [
          BlocProvider<ApplicationBloc>.value(value: ApplicationBloc()),
          Provider<ThemeStore>(create: (_) => _themeStore),
          Provider<LanguageStore>(create: (_) => _languageStore),
          BlocProvider<RootPageBloc>(
            create: (context) => RootPageBloc(),
          ),

        ],
        child: Observer(
          name: 'global-observer',
          builder: (context) {
            return Builder(builder: (context) {
                return BlocBuilder<ApplicationBloc, ApplicationState>(
                    bloc: BlocProvider.of<ApplicationBloc>(context),

                    builder: (context, state)  {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: Strings.appName,
                      theme: _themeStore.darkMode ? themeDataDark : themeData,
                      routes: Routes.routes,
                      locale: Locale(_languageStore.locale),
                      supportedLocales: _languageStore.supportedLanguages
                          .map((language) => Locale(language.locale!, language.code))
                          .toList(),
                      localizationsDelegates: [
                        // A class which loads the translations from JSON files
                        AppLocalizations.delegate,
                        // Built-in localization of basic text for Material widgets
                        GlobalMaterialLocalizations.delegate,
                        // Built-in localization for text direction LTR/RTL
                        GlobalWidgetsLocalizations.delegate,
                        // Built-in localization of basic text for Cupertino widgets
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      home: SplashScreen(),
                    );
                  }
                );
              }
            );
          },
        ),
      ),
    );
  }
}