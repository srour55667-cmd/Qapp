import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/home_cubit.dart';
import 'package:qapp/data/cubit/state_cubit.dart';
import 'package:qapp/screen/surah/listview_category_suwar.dart';
import 'package:qapp/widget/Listviwer_category_reciters.dart';
import 'package:qapp/widget/listview_category_radio.dart';

class FeatchSurahapi extends StatefulWidget {
  const FeatchSurahapi({super.key});

  @override
  State<FeatchSurahapi> createState() => _FeatchSurahapiState();
}

class _FeatchSurahapiState extends State<FeatchSurahapi> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, Homestate>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorState) {
          return Center(child: Text(state.errorMessage));
        } else if (state is SrahSuccessState) {
          return listview_category_suwar(surahList: state.surahList);
        } else if (state is RadioSuccessState) {
          return ListviewCategoryRadio(surahList: state.radiosList);
        } else if (state is RecitersSuccessState) {
          return listviwerRecivers(reciters: state.reciters);
        }
        return const Center(child: Text("No data available"));
      },
    );
  }
}
