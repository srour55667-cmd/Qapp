import 'package:flutter/material.dart';
import 'package:qapp/model/Recitersmodel.dart';
import 'package:qapp/screen/recites/reciter_moshaf_page.dart';

class RecitersPage extends StatelessWidget {
  final List<Reciter> reciters;

  const RecitersPage({super.key, required this.reciters});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: const Text("القراء"), centerTitle: true),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reciters.length,
        itemBuilder: (context, index) {
          final r = reciters[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),

              leading: CircleAvatar(
                radius: 30,
                backgroundColor: primary.withOpacity(0.15),
                child: Text(
                  r.name.characters.first,
                  style: TextStyle(
                    fontSize: 26,
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              title: Text(
                r.name,
                style: TextStyle(
                  fontSize: 19,
                  color: onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),

              trailing: Icon(Icons.arrow_forward_ios_rounded, color: primary),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReciterMoshafPage(reciter: r),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
