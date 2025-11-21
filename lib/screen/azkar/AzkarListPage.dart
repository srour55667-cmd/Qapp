import 'package:flutter/material.dart';
import 'package:qapp/data/azkar/azkar_data.dart';

class AzkarListPage extends StatelessWidget {
  final String title;
  final List<AzkarItem> items;

  const AzkarListPage({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final azkar = items[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  azkar.content,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 20, height: 1.6),
                ),
                const SizedBox(height: 10),

                if (azkar.description.isNotEmpty)
                  Text(
                    azkar.description,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),

                if (azkar.reference.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      azkar.reference,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 8),
                Text(
                  "التكرار: ${azkar.count}",
                  style: TextStyle(
                    color: Colors.purple.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
