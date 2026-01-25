import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final Widget title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: title,
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      pinned: true,
      floating: true,
      snap: true,
      elevation: 0,
    );
  }
}
