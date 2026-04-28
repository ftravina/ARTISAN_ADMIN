import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/account_page.dart';
import '../providers/artisan_provider.dart';
import '../providers/craft_provider.dart';
import '../providers/inquiry_provider.dart';
import '../widgets/custom_app_bar.dart';
import 'artisans/artisans_list.dart';
import 'crafts/crafts_list.dart';
import 'inquiries/inquiries_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _currentPage = 'dashboard';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArtisanProvider>().fetchArtisans();
      context.read<CraftProvider>().fetchCrafts();
      context.read<InquiryProvider>().fetchInquiries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Dashboard'),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getNavIndex(),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFAB432D),
        unselectedItemColor: const Color(0xFFC0BBB4),
        onTap: (index) {
          if (index == 4) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AccountPage(),
              ),
            );
          } else {
            setState(() {
              switch (index) {
                case 0:
                  _currentPage = 'dashboard';
                  break;
                case 1:
                  _currentPage = 'artisans';
                  break;
                case 2:
                  _currentPage = 'crafts';
                  break;
                case 3:
                  _currentPage = 'inquiries';
                  break;
              }
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Artisans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Crafts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Inquiries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  int _getNavIndex() {
    switch (_currentPage) {
      case 'artisans':
        return 1;
      case 'crafts':
        return 2;
      case 'inquiries':
        return 3;
      default:
        return 0;
    }
  }

  Widget _buildPage() {
    return switch (_currentPage) {
      'artisans' => const ArtisansListScreen(),
      'crafts' => const CraftsListScreen(),
      'inquiries' => const InquiriesListScreen(),
      _ => _buildDashboardPage(),
    };
  }

  Widget _buildDashboardPage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/bg_pattern.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.98),
            BlendMode.lighten,
          ),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard Overview',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFAB432D),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildStatCard(
                  'Artisans',
                  context.watch<ArtisanProvider>().artisans.length.toString(),
                  const Color(0xFFC0BBB4),
                  Icons.people,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Crafts',
                  context.watch<CraftProvider>().crafts.length.toString(),
                  const Color(0xFFD4CEBC),
                  Icons.card_giftcard,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Inquiries',
                  context.watch<InquiryProvider>().inquiries.length.toString(),
                  const Color(0xFFE0D5C0),
                  Icons.mail,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 12),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
