import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/artisan_provider.dart';
import 'artisan_detail.dart';

class ArtisansListScreen extends StatelessWidget {
  const ArtisansListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: const Color(0xFFAB432D),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          'Manage Artisans',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      body: Consumer<ArtisanProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.artisans.isEmpty) {
            return const Center(child: Text('No artisans found'));
          }

          return Stack(
            children: [
              // Background
              Container(
                color: const Color(0xFFF5F3F0),
              ),

              // List
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.artisans.length,
                itemBuilder: (context, index) {
                  final artisan = provider.artisans[index];
                  return _buildArtisanItem(context, artisan, index);
                },
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ArtisanDetailScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFFAB432D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildArtisanItem(BuildContext context, dynamic artisan, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,

        // profile image code
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[200],
          backgroundImage:
              (artisan.photoUrl != null && artisan.photoUrl.isNotEmpty)
                  ? NetworkImage(artisan.photoUrl)
                  : null,
          child: (artisan.photoUrl == null || artisan.photoUrl.isEmpty)
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),

        title: Text(
          artisan.name ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFAB432D),
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              artisan.region ?? '',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              artisan.community ?? '',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArtisanDetailScreen(artisan: artisan),
                ),
              );
            } else if (value == 'delete') {
              _deleteArtisan(context, artisan.id.toString());
            }
          },
          itemBuilder: (BuildContext context) => const [
            PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  // delete function na code
  void _deleteArtisan(BuildContext context, String artisanId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Artisan'),
        content: const Text('Are you sure you want to delete this artisan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<ArtisanProvider>().deleteArtisan(artisanId);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
