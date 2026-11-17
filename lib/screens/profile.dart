import 'package:flutter/material.dart';

import '../core/contact.dart';
import '../core/net_image.dart';
import '../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final photo = unsplash('1544005313-94ddf0286df2', w: 600);
    Widget tile(IconData icon, String title, String feature) => ListTile(
          leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: brand.withValues(alpha: .1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: brand)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Contact.show(context, appName, feature),
        );

    return ListView(padding: const EdgeInsets.all(20), children: [
      Center(
        child: Stack(children: [
          SizedBox(
            width: 140, height: 140,
            child: CircularProgressIndicator(value: .8, strokeWidth: 6, backgroundColor: Colors.black12, valueColor: const AlwaysStoppedAnimation(brand)),
          ),
          Positioned.fill(child: Padding(padding: const EdgeInsets.all(10), child: ClipOval(child: NetImage(photo)))),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(20)), child: const Text('80% complete', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))),
          ),
        ]),
      ),
      const SizedBox(height: 14),
      const Center(child: Text('Priya, 26', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800))),
      const Center(child: Text('UX Writer · Bengaluru', style: TextStyle(color: Colors.black54))),
      const SizedBox(height: 20),
      Row(children: [
        for (final (n, l) in [('128', 'Likes'), ('36', 'Matches'), ('12', 'Super likes')])
          Expanded(child: Card(elevation: 0, color: Colors.white, child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [Text(n, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), Text(l, style: const TextStyle(color: Colors.black54, fontSize: 12))])))),
      ]),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF111827), borderRadius: BorderRadius.circular(24)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.workspace_premium, color: Color(0xFFFBBF24)), SizedBox(width: 8), Text('SparkMatch Platinum', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18))]),
          const SizedBox(height: 8),
          const Text('Unlimited likes · See who likes you · 5 Super Likes a week · Priority profile', style: TextStyle(color: Colors.white70, height: 1.4)),
          const SizedBox(height: 14),
          FilledButton(onPressed: () => Contact.show(context, appName, 'In-app Purchases & Subscriptions'), child: const Text('Get Platinum')),
        ]),
      ),
      const SizedBox(height: 12),
      Card(
        elevation: 0,
        color: Colors.white,
        child: Column(children: [
          tile(Icons.photo_library_outlined, 'Edit photos & prompts', 'Profile Editor & Photo Verification'),
          tile(Icons.location_on_outlined, 'Discovery settings', 'Location-based Discovery'),
          tile(Icons.verified_user_outlined, 'Verify my profile', 'Selfie Verification (AI)'),
          tile(Icons.lock_outline, 'Privacy & safety', 'Privacy Controls & Moderation'),
        ]),
      ),
    ]);
  }
}
