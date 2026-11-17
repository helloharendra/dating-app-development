// SparkMatch – Dating app UI demo by Naya Prayog Technologies (https://nayaprayog.com)
// Run: flutter pub get && flutter run   (Android, iOS or Chrome)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/chats.dart';
import 'screens/discover.dart';
import 'screens/matches.dart';
import 'screens/profile.dart';

const appName = 'SparkMatch';
const brand = Color(0xFFF43F5E);
const brandGradient = LinearGradient(colors: [Color(0xFFFF5F6D), Color(0xFFF43F5E), Color(0xFFC026D3)]);

void main() => runApp(const SparkMatchApp());

class SparkMatchApp extends StatelessWidget {
  const SparkMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: brand, primary: brand, tertiary: const Color(0xFFC026D3)));
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        scaffoldBackgroundColor: const Color(0xFFFFF7F8),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;
  static const pages = [DiscoverScreen(), MatchesScreen(), ChatsScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: index, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        backgroundColor: Colors.white,
        indicatorColor: brand.withValues(alpha: .12),
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.local_fire_department_outlined), selectedIcon: Icon(Icons.local_fire_department, color: brand), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite, color: brand), label: 'Likes'),
          NavigationDestination(icon: Badge(label: Text('3'), child: Icon(Icons.chat_bubble_outline)), selectedIcon: Icon(Icons.chat_bubble, color: brand), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: brand), label: 'Profile'),
        ],
      ),
    );
  }
}
