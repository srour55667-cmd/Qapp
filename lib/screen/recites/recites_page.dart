import 'package:flutter/material.dart';
import 'package:qapp/model/Recitersmodel.dart';
import 'package:qapp/screen/recites/reciter_moshaf_page.dart';

class RecitersPage extends StatelessWidget {
  final List<Reciter> reciters;

  const RecitersPage({super.key, required this.reciters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("القراء"), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: reciters.length,
        itemBuilder: (context, index) {
          final r = reciters[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.shade100.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.purple.shade300,
                  child: Text(
                    r.name.characters.first,
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    r.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.purple,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReciterMoshafPage(reciter: r),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
