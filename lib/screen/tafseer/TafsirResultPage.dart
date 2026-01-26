import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/home_cubit.dart';
import 'package:qapp/data/cubit/state_cubit.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TafsirResultPage extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final String tafsirCode;

  const TafsirResultPage({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.tafsirCode,
    this.initialAyahNumber,
  });

  final int? initialAyahNumber;

  @override
  State<TafsirResultPage> createState() => _TafsirResultPageState();
}

class _TafsirResultPageState extends State<TafsirResultPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getTafsir(widget.surahNumber);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: Text("تفسير سورة ${widget.surahName}"),
        centerTitle: true,
      ),

      body: BlocBuilder<HomeCubit, Homestate>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ErrorState) {
            return Center(
              child: Text(
                "خطأ: ${state.errorMessage}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is TafsirSuccessState) {
            final list = state.tafsirList;

            // Calculate initial index
            int initialIndex = 0;
            if (widget.initialAyahNumber != null) {
              // Ayah numbering usually starts at 1, list index at 0.
              // Assuming list is sorted by Ayah number.
              // Safe find:
              final foundIndex = list.indexWhere(
                (element) => element.aya == widget.initialAyahNumber.toString(),
              );
              if (foundIndex != -1) {
                initialIndex = foundIndex;
              }
            }

            return ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
              initialScrollIndex: initialIndex,
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final ayah = list[index];
                final isSelected =
                    widget.initialAyahNumber != null &&
                    ayah.aya == widget.initialAyahNumber.toString();

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isSelected ? primary.withOpacity(0.05) : cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: isSelected
                        ? Border.all(color: primary.withOpacity(0.5), width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.10),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "آية ${ayah.aya}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              ayah.arabicText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Amiri",
                                fontSize: 22,
                                height: 1.8,
                                color: onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        ayah.translation,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.7,
                          color: onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
