import 'package:flutter/material.dart';

class SebhaPage extends StatefulWidget {
  const SebhaPage({super.key});

  @override
  State<SebhaPage> createState() => _SebhaPageState();
}

class _SebhaPageState extends State<SebhaPage>
    with SingleTickerProviderStateMixin {
  int counter = 0;

  final List<String> azkarList = [
    "سُبْحَانَ اللَّه",
    "الْحَمْدُ لِلَّه",
    "اللَّهُ أَكْبَر",
    "لا إِلَهَ إِلَّا اللَّه",
    "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
    "أستغفر الله",
  ];

  int currentZikr = 0;

  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_anim);
  }

  void increment() {
    setState(() => counter++);
    _anim.forward().then((_) => _anim.reverse());
  }

  void reset() => setState(() => counter = 0);

  void nextZikr() => setState(() {
    currentZikr = (currentZikr + 1) % azkarList.length;
    counter = 0;
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: const Text("السبحة"), centerTitle: true),

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary.withOpacity(0.08), primary.withOpacity(0.02)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔹 الذكر الحالي
                Text(
                  azkarList[currentZikr],
                  style: TextStyle(
                    fontSize: 32,
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // 🔹 العدّاد
                Text(
                  "$counter",
                  style: TextStyle(
                    fontSize: 54,
                    color: onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                // 🔹 زرار التسبيح (دائري Modern)
                ScaleTransition(
                  scale: _scale,
                  child: InkWell(
                    onTap: increment,
                    borderRadius: BorderRadius.circular(200),
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary,
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "سَبِّح",
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 🔹 أزرار التحكم
                Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: nextZikr,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(
                        "تغيير الذكر",
                        style: TextStyle(
                          fontSize: 18,
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: reset,
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: Text(
                        "إعادة التصفير",
                        style: TextStyle(
                          fontSize: 16,
                          color: onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
