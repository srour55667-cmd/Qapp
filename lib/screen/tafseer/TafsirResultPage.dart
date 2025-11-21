import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/home_cubit.dart';
import 'package:qapp/data/cubit/state_cubit.dart';

class TafsirResultPage extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final String tafsirCode; // بس مش مستخدم الآن

  const TafsirResultPage({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.tafsirCode,
  });

  @override
  State<TafsirResultPage> createState() => _TafsirResultPageState();
}

class _TafsirResultPageState extends State<TafsirResultPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getTafsir(widget.surahNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تفسير سورة ${widget.surahName}"),
        centerTitle: true,
        backgroundColor: Colors.purple,
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

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final ayah = list[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// رقم الآية
                      Center(
                        child: Text(
                          "آية ${ayah.aya}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// نص الآية
                      Text(
                        ayah.arabicText,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 20,
                          height: 1.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// التفسير
                      Text(
                        ayah.translation,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.7,
                          color: Colors.black87,
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
