import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/contact.dart';
import '../core/net_image.dart';
import '../data.dart';
import '../main.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Likes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      const Text('24 people liked your profile this week', style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: brandGradient, borderRadius: BorderRadius.circular(24)),
        child: Row(children: [
          const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 40),
          const SizedBox(width: 14),
          const Expanded(child: Text('See who likes you with SparkMatch Gold', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: brand),
            onPressed: () => Contact.show(context, appName, 'Premium Subscriptions (Gold / Platinum)'),
            child: const Text('Upgrade'),
          ),
        ]),
      ),
      const SizedBox(height: 20),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: profiles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: .72),
        itemBuilder: (_, i) {
          final p = profiles[i];
          final locked = i > 1;
          return GestureDetector(
            onTap: () => locked ? Contact.show(context, appName, 'See Who Liked You') : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(fit: StackFit.expand, children: [
                locked ? ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 14, sigmaY: 14), child: NetImage(p.photo)) : NetImage(p.photo),
                const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.center, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87]))),
                if (locked) const Center(child: Icon(Icons.lock_rounded, color: Colors.white, size: 34)),
                Positioned(
                  left: 12, bottom: 12,
                  child: Text(locked ? 'Someone special' : '${p.name}, ${p.age}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ]),
            ),
          );
        },
      ),
    ]);
  }
}
