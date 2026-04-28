import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/craft.dart'; // ✅ ADDED
import '../../providers/craft_provider.dart';
import 'craft_detail.dart';

class CraftsListScreen extends StatefulWidget {
  const CraftsListScreen({super.key});

  @override
  State<CraftsListScreen> createState() => _CraftsListScreenState();
}

class _CraftsListScreenState extends State<CraftsListScreen> {
  String _filterStatus = 'all';

  Widget _buildCraftsList(BuildContext context, CraftProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.crafts.length,
      itemBuilder: (context, index) {
        final craft = provider.crafts[index];
        return _buildCraftItem(context, craft);
      },
    );
  }

  // ✅ FIXED TYPE
  Widget _buildCraftItem(BuildContext context, Craft craft) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          print("Tapped: ${craft.name}");
          _showCraftDetails(context, craft);
        },
        child: Container(
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
          child: Row(
            children: [
              // IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (craft.imageUrl.isNotEmpty)
                    ? Image.network(
                        craft.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          );
                        },
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
              ),

              const SizedBox(width: 12),

              // TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      craft.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAB432D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      craft.material,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₱${craft.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(craft.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        craft.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(craft.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // MENU
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CraftDetailScreen(craft: craft),
                      ),
                    );
                  } else if (value == 'delete') {
                    _deleteCraft(context, craft.id.toString());
                  } else if (value == 'approve') {
                    _approveCraft(context, craft.id.toString());
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  if (craft.status == 'pending')
                    const PopupMenuItem(
                      value: 'approve',
                      child: Text('Approve'),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCraftDetails(BuildContext context, Craft craft) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (craft.imageUrl.isNotEmpty)
                      ? Image.network(
                          craft.imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 160,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 40),
                        ),
                ),
                const SizedBox(height: 12),
                Text(
                  craft.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAB432D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text('Material: ${craft.material}'),
                const SizedBox(height: 6),
                Text(
                  'Price: ₱${craft.price}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Status: ${craft.status.toUpperCase()}',
                  style: TextStyle(
                    color: _getStatusColor(craft.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAB432D),
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available': // ✅ FIXED
        return const Color.fromARGB(255, 192, 191, 191);
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAB432D),
        elevation: 0,
        title: const Text(
          'Manage Crafts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<CraftProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.crafts.isEmpty) {
            return const Center(child: Text('No crafts found'));
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    const Text(
                      'Filter by Status:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAB432D),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _filterStatus,
                        dropdownColor: const Color(0xFFAB432D),
                        items: <String>['all', 'pending', 'available']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _filterStatus = newValue!;
                            context.read<CraftProvider>().fetchCrafts(
                                  status: _filterStatus == 'all'
                                      ? null
                                      : _filterStatus,
                                );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildCraftsList(context, provider),
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
              builder: (_) => const CraftDetailScreen(),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _approveCraft(BuildContext context, String craftId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Craft'),
        content: const Text('Are you sure you want to approve this craft?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<CraftProvider>().approveCraft(craftId);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Available'),
          ),
        ],
      ),
    );
  }

  void _deleteCraft(BuildContext context, String craftId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Craft'),
        content: const Text('Are you sure you want to delete this craft?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<CraftProvider>().deleteCraft(craftId);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
