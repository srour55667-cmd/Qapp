import 'package:flutter/material.dart';
import 'package:qapp/model/Recitersmodel.dart';
import 'package:qapp/widget/surah_listpage.dart';

class listviwerRecivers extends StatelessWidget {
  const listviwerRecivers({super.key, required this.reciters});
  final List<Reciter> reciters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reciters")),
      body: ListView.builder(
        itemCount: reciters.length,
        itemBuilder: (context, index) {
          final reciter = reciters[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(child: Text("${index + 1}")),
              title: Text(reciter.name),

              trailing: ElevatedButton(
                onPressed: () {
                  if (reciter.moshaf.isNotEmpty) {
                    final selectedMoshaf = reciter.moshaf.first;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurahListPage(
                          reciterName: reciter.name,
                          moshaf: selectedMoshaf,
                        ),
                      ),
                    );
                  }
                },
                child: const Text("Listen"),
              ),
            ),
          );
        },
      ),
    );
  }
}
