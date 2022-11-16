import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Spidclass());
}

final navigatorKey = GlobalKey<NavigatorState>();

class Spidclass extends StatelessWidget {
  const Spidclass({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spidclass',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // initialRoute: AppRoute.classes,
        onGenerateRoute: (route) => getRoute(route),
      );

  Route getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.classes:
        return buildRoute(ClassesPage(), settings: settings);
      default:
       return buildRoute(ClassesPage(), settings: settings);
    }
  }

  MaterialPageRoute buildRoute(Widget child, {required RouteSettings settings}) =>
      MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => child,
      );
}
