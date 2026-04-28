import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'providers/artisan_provider.dart';
import 'providers/craft_provider.dart';
import 'providers/inquiry_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseClient>(
          create: (_) => Supabase.instance.client,
        ),
        ChangeNotifierProxyProvider<SupabaseClient, ArtisanProvider>(
          create: (context) => ArtisanProvider(context.read<SupabaseClient>()),
          update: (context, supabase, provider) =>
              provider ?? ArtisanProvider(supabase),
        ),
        ChangeNotifierProxyProvider<SupabaseClient, CraftProvider>(
          create: (context) => CraftProvider(context.read<SupabaseClient>()),
          update: (context, supabase, provider) =>
              provider ?? CraftProvider(supabase),
        ),
        ChangeNotifierProxyProvider<SupabaseClient, InquiryProvider>(
          create: (context) => InquiryProvider(context.read<SupabaseClient>()),
          update: (context, supabase, provider) =>
              provider ?? InquiryProvider(supabase),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Artisan Admin',
        theme: ThemeData(
          primaryColor: const Color(0xFFC0BBB4),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFC0BBB4),
            foregroundColor: Color(0xFFAB432D),
          ),
        ),

        // ✅ Register routes
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },

        // Optional: handle unknown routes
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        ),
      ),
    );
  }
}