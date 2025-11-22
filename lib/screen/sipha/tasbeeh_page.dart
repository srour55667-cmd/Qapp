// import 'package:flutter/material.dart';

// class SebhaPage extends StatefulWidget {
//   const SebhaPage({super.key});

//   @override
//   State<SebhaPage> createState() => _SebhaPageState();
// }

// class _SebhaPageState extends State<SebhaPage>
//     with SingleTickerProviderStateMixin {
//   int counter = 0;

//   final List<String> azkarList = [
//     "سُبْحَانَ اللَّه",
//     "الْحَمْدُ لِلَّه",
//     "اللَّهُ أَكْبَر",
//     "لا إِلَهَ إِلَّا اللَّه",
//     "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
//     "أستغفر الله",
//   ];

//   int currentZikr = 0;

//   late AnimationController _anim;
//   late Animation<double> _rotation;
//   late Animation<double> _scale;

//   @override
//   void initState() {
//     super.initState();

//     _anim = AnimationController(
//       duration: const Duration(milliseconds: 180),
//       vsync: this,
//     );

//     _rotation = Tween<double>(
//       begin: 0,
//       end: 0.07,
//     ).chain(CurveTween(curve: Curves.easeOut)).animate(_anim);

//     _scale = Tween<double>(
//       begin: 1.0,
//       end: 1.08,
//     ).chain(CurveTween(curve: Curves.easeOut)).animate(_anim);
//   }

//   void increment() {
//     setState(() => counter++);
//     _anim.forward().then((_) => _anim.reverse());
//   }

//   void reset() => setState(() => counter = 0);

//   void nextZikr() => setState(() {
//     currentZikr = (currentZikr + 1) % azkarList.length;
//     counter = 0;
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("السبحة"),
//         centerTitle: true,
//         backgroundColor: Colors.purple.shade400,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Column(
//             children: [
//               const SizedBox(height: 40),

//               /// 🔥 صورة السبحة + الأنيميشن الجديد
//               AnimatedBuilder(
//                 animation: _anim,
//                 builder: (context, child) {
//                   return Transform.rotate(
//                     angle: _rotation.value,
//                     child: Transform.scale(scale: _scale.value, child: child),
//                   );
//                 },
//                 child: SizedBox(
//                   height: 180,
//                   child: Image.asset("assets/images/siphaa.jpg"),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               Text(
//                 azkarList[currentZikr],
//                 style: const TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.purple,
//                 ),
//               ),

//               const SizedBox(height: 15),

//               /// العداد
//               Text(
//                 "$counter",
//                 style: TextStyle(
//                   fontSize: 52,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.purple.shade700,
//                 ),
//               ),

//               const SizedBox(height: 40),

//               ElevatedButton(
//                 onPressed: increment,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple.shade400,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 80,
//                     vertical: 16,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                 ),
//                 child: const Text(
//                   "سَبِّح",
//                   style: TextStyle(fontSize: 22, color: Colors.white),
//                 ),
//               ),

//               const SizedBox(height: 15),

//               TextButton(
//                 onPressed: nextZikr,
//                 child: Text(
//                   "تغيير الذكر",
//                   style: TextStyle(fontSize: 18, color: Colors.purple.shade600),
//                 ),
//               ),

//               TextButton(
//                 onPressed: reset,
//                 child: const Text(
//                   "إعادة التصفير",
//                   style: TextStyle(color: Colors.black54),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary.withOpacity(0.08), primary.withOpacity(0.02)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // 🔹 الذكر الحالي (بخط Amiri)
            Text(
              azkarList[currentZikr],
              style: TextStyle(
                fontFamily: "Amiri",
                fontSize: 32,
                color: primary,
                fontWeight: FontWeight.w600,
              ),
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

            const SizedBox(height: 30),

            // 🔹 تغيير الذكر
            TextButton(
              onPressed: nextZikr,
              child: Text(
                "تغيير الذكر",
                style: TextStyle(
                  fontSize: 20,
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // 🔹 إعادة التصفير
            TextButton(
              onPressed: reset,
              child: Text(
                "إعادة التصفير",
                style: TextStyle(
                  fontSize: 16,
                  color: onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
