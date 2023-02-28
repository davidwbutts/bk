import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Books Demo',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade900),
      ),
      routerConfig: router,
    );
  }
}
final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/home/detail',
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      builder: (context,state,child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: const AppBottomNavigationBar(),
        );
      },
      routes: [
        GoRoute(
          path: 0.path,
          pageBuilder: (context,state) => const NoTransitionPage(child: HomeScreen()),
          routes: [
            GoRoute(
              name: 'detail',
              path: 'detail',
              pageBuilder: (context,state) => const NoTransitionPage(child: LibraryScreen()),
            ),
          ],
        ),
        GoRoute(
          path: 1.path,
          pageBuilder: (context,state) => const NoTransitionPage(child: LibraryScreen()),
        ),
        GoRoute(
          path: 2.path,
          pageBuilder: (context,state) => const NoTransitionPage(child: HottubScreen()),
        ),
      ],

    ),
  ],
);

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref,_) {
        ref.listen(bottomIndexProvider, (_, next) => context.go(next.path));
        return BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.local_library), label: 'Library'),
            BottomNavigationBarItem(icon: Icon(Icons.hot_tub), label: 'Hottub'),
          ],
          currentIndex: ref.watch(bottomIndexProvider),
          onTap: (value) => ref.read(bottomIndexProvider.notifier).update((_)=>value),
        );
      },

    );
  }
}

enum NavBarItem {
  home,
  library,
  hottub;
}

extension on int {
  String get path {
    switch(this){
      case 0: return '/home';
      case 1: return '/library';
      case 2: return '/hottub';
      default: throw StateError('Bottom nav selection not yet supported ($this)');
    }
  }
}

final bottomIndexProvider = StateProvider<int>((ref)=>0);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: ()=>context.goNamed('detail'),
          ),
        ],
      ),
      body: Center(child: Text('home screen', style: theme.textTheme.headlineSmall )),
    );
  }
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: Center(child: Text('library screen', style: theme.textTheme.headlineSmall )),
    );
  }
}


class HottubScreen extends StatelessWidget {
  const HottubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Hot tub')),
      body: Center(child: Text('hot tub screen', style: theme.textTheme.headlineSmall )),
    );
  }
}