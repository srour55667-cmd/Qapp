import 'package:flutter/material.dart';
import 'package:qapp/data/azkar/azkar_data.dart';

class AzkarListPage extends StatelessWidget {
  final String title;
  final List<AzkarItem> items;

  const AzkarListPage({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final azkar = items[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // الذكر
                Text(
                  azkar.content,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: "Amiri",
                    fontSize: 22,
                    height: 1.6,
                    color: onSurface,
                  ),
                ),

                const SizedBox(height: 10),

                // الوصف
                if (azkar.description.isNotEmpty)
                  Text(
                    azkar.description,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15,
                      color: onSurface.withOpacity(0.6),
                    ),
                  ),

                const SizedBox(height: 6),

                // المرجع
                if (azkar.reference.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      azkar.reference,
                      style: TextStyle(
                        fontSize: 13,
                        color: primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                const Divider(),

                // التكرار
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "التكرار: ${azkar.count}",
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const Icon(Icons.repeat, size: 20),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
