import 'package:spidclass/pages/class_members/class_members_arguments.dart';
import 'package:spidclass/pages/class_members/class_members_page.dart';
import 'package:spidclass/pages/classroom/classroom_arguments.dart';

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

      case AppRoute.classroom:
        final ClassroomArguments args =
            settings.arguments as ClassroomArguments;
        return buildRoute(ClassroomPage(arguments: args), settings: settings);

      case AppRoute.classMembers:
        final ClassMembersArguments args =
            settings.arguments as ClassMembersArguments;
        return buildRoute(ClassMembersPage(arguments: args),
            settings: settings);

      default:
        return buildRoute(ClassesPage(), settings: settings);
    }
  }

  MaterialPageRoute buildRoute(Widget child,
          {required RouteSettings settings}) =>
      MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => child,
      );
}
