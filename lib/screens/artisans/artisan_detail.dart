import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/artisan.dart';
import '../../providers/artisan_provider.dart';

class ArtisanDetailScreen extends StatefulWidget {
  final Artisan? artisan;

  const ArtisanDetailScreen({super.key, this.artisan});

  @override
  State<ArtisanDetailScreen> createState() => _ArtisanDetailScreenState();
}

class _ArtisanDetailScreenState extends State<ArtisanDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _communityController;
  late TextEditingController _regionController;
  late TextEditingController _storyController;
  late TextEditingController _photoUrlController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.artisan?.name ?? '');
    _communityController =
        TextEditingController(text: widget.artisan?.community ?? '');
    _regionController =
        TextEditingController(text: widget.artisan?.region ?? '');
    _storyController = TextEditingController(text: widget.artisan?.story ?? '');
    _photoUrlController =
        TextEditingController(text: widget.artisan?.photoUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _communityController.dispose();
    _regionController.dispose();
    _storyController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      final provider = context.read<ArtisanProvider>();

      if (widget.artisan == null) {
        await provider.createArtisan(
          name: _nameController.text,
          community: _communityController.text,
          region: _regionController.text,
          story: _storyController.text,
          photoUrl: _photoUrlController.text,
        );
      } else {
        await provider.updateArtisan(
          id: widget.artisan!.id,
          name: _nameController.text,
          community: _communityController.text,
          region: _regionController.text,
          story: _storyController.text,
          photoUrl: _photoUrlController.text,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artisan saved successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artisan == null ? 'New Artisan' : 'Edit Artisan'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFAB432D),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _communityController,
              decoration: InputDecoration(
                labelText: 'Community',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _regionController,
              decoration: InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _storyController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Story',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _photoUrlController,
              decoration: InputDecoration(
                labelText: 'Photo URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFAB432D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
