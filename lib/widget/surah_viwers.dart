import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qapp/widget/fetch_fillsurahapi.dart';

class SurahImagesView extends StatefulWidget {
  final int surahId;
  final int readId;
  final String surahName;

  const SurahImagesView({
    super.key,
    required this.surahId,
    this.readId = 5,
    required this.surahName,
  });

  @override
  State<SurahImagesView> createState() => _SurahImagesViewState();
}

class _SurahImagesViewState extends State<SurahImagesView> {
  late Future<List<String>> _pagesFuture;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pagesFuture = getSurahSvgPagesDio(widget.surahId);
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("سورة ${widget.surahName}"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: _pagesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final pages = snapshot.data!;

          return PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  child: RepaintBoundary(
                    child: SizedBox.expand(
                      child: SvgPicture.network(
                        pages[index],
                        fit: BoxFit.contain,
                        placeholderBuilder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                        cacheColorFilter: true,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
