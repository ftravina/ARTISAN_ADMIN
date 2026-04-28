import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/craft.dart';
import '../../providers/craft_provider.dart';
import '../../providers/artisan_provider.dart';

class CraftDetailScreen extends StatefulWidget {
  final Craft? craft;

  const CraftDetailScreen({super.key, this.craft});

  @override
  State<CraftDetailScreen> createState() => _CraftDetailScreenState();
}

class _CraftDetailScreenState extends State<CraftDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _materialController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late String _selectedArtisanId;
  late String _status;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.craft?.name ?? '');
    _materialController =
        TextEditingController(text: widget.craft?.material ?? '');
    _priceController =
        TextEditingController(text: widget.craft?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.craft?.description ?? '');
    _imageUrlController =
        TextEditingController(text: widget.craft?.imageUrl ?? '');

    _selectedArtisanId = widget.craft?.artisanId ?? '';

    // ✅ SAFE + CLEAN STATUS
    _status = widget.craft?.status ?? 'pending';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _materialController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      final provider = context.read<CraftProvider>();
      final price = double.tryParse(_priceController.text) ?? 0.0;

      if (widget.craft == null) {
        await provider.createCraft(
          artisanId: _selectedArtisanId,
          name: _nameController.text,
          material: _materialController.text,
          price: price,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
        );
      } else {
        await provider.updateCraft(
          id: widget.craft!.id,
          name: _nameController.text,
          material: _materialController.text,
          price: price,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          status: _status, // ✅ consistent
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Craft saved successfully')),
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
    final artisans = context.watch<ArtisanProvider>().artisans;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.craft == null ? 'New Craft' : 'Edit Craft'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFAB432D),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.craft == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Artisan'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue:
                        _selectedArtisanId.isEmpty ? null : _selectedArtisanId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: artisans
                        .map((artisan) => DropdownMenuItem(
                              value: artisan.id,
                              child: Text(artisan.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedArtisanId = value ?? '');
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Craft Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _materialController,
              decoration: InputDecoration(
                labelText: 'Material',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price (₱)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            if (widget.craft != null) ...[
              const SizedBox(height: 16),
              const Text('Status'),
              const SizedBox(height: 8),

              // ✅ CLEAN DROPDOWN
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: <String>['pending', 'available'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _status = value ?? 'pending');
                },
              ),
            ],
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
