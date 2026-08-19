import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'di/injection_container.dart';
import 'features/products_search/presentation/screens/product_search_screen.dart';
import 'features/shopping_list/presentation/screens/shopping_list_screen.dart';
import 'features/archive/presentation/screens/archive_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RemediatedMarketApp());
}

class RemediatedMarketApp extends StatelessWidget {
  const RemediatedMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: InjectionContainer.buildProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Akıllı Market Listem (Remediated)',
        theme: AppTheme.lightTheme,
        home: const MainTabNavigator(),
      ),
    );
  }
}

class MainTabNavigator extends StatefulWidget {
  const MainTabNavigator({super.key});

  @override
  State<MainTabNavigator> createState() => _MainTabNavigatorState();
}

class _MainTabNavigatorState extends State<MainTabNavigator> {
  int _currentIndex = 1;

  final List<Widget> _screens = const [
    ProductSearchScreen(),
    ShoppingListScreen(),
    ArchiveScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Поиск',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Список',
          ),
          NavigationDestination(
            icon: Icon(Icons.archive_outlined),
            selectedIcon: Icon(Icons.archive),
            label: 'Архив',
          ),
        ],
      ),
    );
  }
}
