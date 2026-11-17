import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/contact.dart';
import '../core/net_image.dart';
import '../data.dart';
import '../main.dart';

/// Swipe deck: drag a card left/right or use the buttons.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with SingleTickerProviderStateMixin {
  late List<Profile> deck = List.of(profiles);
  Offset drag = Offset.zero;
  late final AnimationController ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
  Animation<Offset>? fly;

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  void swipe(bool like) {
    if (deck.isEmpty) return;
    final width = MediaQuery.sizeOf(context).width;
    fly = Tween(begin: drag, end: Offset(like ? width * 1.5 : -width * 1.5, drag.dy)).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut));
    ctrl.forward(from: 0).then((_) {
      final p = deck.first;
      setState(() {
        deck.removeAt(0);
        drag = Offset.zero;
        fly = null;
      });
      if (like && p.verified) _match(p);
    });
  }

  void _match(Profile p) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(gradient: brandGradient, borderRadius: BorderRadius.circular(32)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text("It's a Match! 💘", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('You and ${p.name} liked each other', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            CircleAvatar(radius: 56, backgroundColor: Colors.white, child: ClipOval(child: NetImage(p.photo, width: 104, height: 104))),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: brand, padding: const EdgeInsets.all(16)),
                onPressed: () {
                  Navigator.pop(context);
                  Contact.show(context, appName, 'Real-time Chat & Video Calls');
                },
                child: const Text('Send a message', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Keep swiping', style: TextStyle(color: Colors.white))),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
        child: Row(children: [
          ShaderMask(
            shaderCallback: (r) => brandGradient.createShader(r),
            child: const Text('SparkMatch', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          const Spacer(),
          IconButton.filledTonal(onPressed: () => Contact.show(context, appName, 'Advanced Filters'), icon: const Icon(Icons.tune_rounded)),
        ]),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: deck.isEmpty
              ? _empty()
              : Stack(children: [
                  for (var i = math.min(deck.length, 3) - 1; i >= 0; i--)
                    i == 0 ? _topCard(deck[0]) : Positioned.fill(top: i * 10.0, child: Transform.scale(scale: 1 - i * .04, child: _card(deck[i], 0))),
                ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _roundBtn(Icons.replay_rounded, Colors.amber, 48, () => Contact.show(context, appName, 'Rewind (Premium)')),
          _roundBtn(Icons.close_rounded, Colors.redAccent, 64, () => swipe(false)),
          _roundBtn(Icons.star_rounded, Colors.lightBlue, 48, () => Contact.show(context, appName, 'Super Likes (Premium)')),
          _roundBtn(Icons.favorite_rounded, const Color(0xFF22C55E), 64, () => swipe(true)),
          _roundBtn(Icons.bolt_rounded, Colors.purple, 48, () => Contact.show(context, appName, 'Profile Boost')),
        ]),
      ),
    ]);
  }

  Widget _topCard(Profile p) => AnimatedBuilder(
        animation: ctrl,
        builder: (_, __) {
          final o = fly?.value ?? drag;
          return GestureDetector(
            onPanUpdate: (d) => setState(() => drag += d.delta),
            onPanEnd: (_) => drag.dx.abs() > 110 ? swipe(drag.dx > 0) : setState(() => drag = Offset.zero),
            child: Transform.translate(offset: o, child: Transform.rotate(angle: o.dx / 1200, child: _card(p, o.dx))),
          );
        },
      );

  Widget _card(Profile p, double dx) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .15), blurRadius: 30, offset: const Offset(0, 12))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(fit: StackFit.expand, children: [
          NetImage(p.photo),
          const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.transparent, Colors.black87]))),
          if (dx > 30) _stamp('LIKE', const Color(0xFF22C55E), -0.3, Alignment.topLeft, (dx / 150).clamp(0, 1)),
          if (dx < -30) _stamp('NOPE', Colors.redAccent, 0.3, Alignment.topRight, (-dx / 150).clamp(0, 1)),
          Positioned(
            left: 20, right: 20, bottom: 20,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('${p.name}, ${p.age}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                if (p.verified) const Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.verified, color: Colors.lightBlueAccent)),
              ]),
              const SizedBox(height: 4),
              Text('${p.job} · ${p.city} · ${p.km} km away', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(p.bio, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, height: 1.35)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: p.interests
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: .2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
                          child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                        ))
                    .toList(),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _stamp(String text, Color c, double angle, Alignment a, double opacity) => Align(
        alignment: a,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Opacity(
            opacity: opacity.toDouble(),
            child: Transform.rotate(
              angle: angle,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(border: Border.all(color: c, width: 4), borderRadius: BorderRadius.circular(10)),
                child: Text(text, style: TextStyle(color: c, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 2)),
              ),
            ),
          ),
        ),
      );

  Widget _roundBtn(IconData icon, Color c, double size, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 6,
          shadowColor: c.withValues(alpha: .35),
          child: InkWell(customBorder: const CircleBorder(), onTap: onTap, child: SizedBox(width: size, height: size, child: Icon(icon, color: c, size: size * .48))),
        ),
      );

  Widget _empty() => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.travel_explore_rounded, size: 72, color: brand),
          const SizedBox(height: 12),
          const Text("You've seen everyone nearby", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => setState(() => deck = List.of(profiles)), child: const Text('Start over')),
        ]),
      );
}
