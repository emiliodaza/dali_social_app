import 'package:flutter/material.dart';
import 'package:untitled/screens/chat_screen.dart';
import 'package:untitled/screens/post_text_screen.dart';
import 'package:untitled/screens/profile_screen.dart';
import 'package:untitled/screens/register_screen.dart';
import 'package:untitled/screens/search_chat_screen.dart';
import 'package:untitled/screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.route,
      routes: {
        WelcomeScreen.route: (context) => WelcomeScreen(),
        RegisterScreen.route: (context) => RegisterScreen(),
        HomeScreen.route: (context) => HomeScreen(),
        SearchChatScreen.route: (context) => SearchChatScreen(),
        PostTextScreen.route: (context) => PostTextScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ProfileScreen.route) {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ProfileScreen(userId: userId),
          );
        }

        if (settings.name == ChatScreen.route) {
          final otherUid = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ChatScreen(otherUid: otherUid),
          );
        }
        return null;
      },
    );
  }
}
