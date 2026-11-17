import 'package:flutter/material.dart';

import '../core/contact.dart';
import '../core/net_image.dart';
import '../data.dart';
import '../main.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.symmetric(vertical: 20), children: [
      const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Messages', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
      const SizedBox(height: 16),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('New matches', style: TextStyle(fontWeight: FontWeight.w700, color: brand))),
      const SizedBox(height: 12),
      SizedBox(
        height: 96,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: profiles.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, i) => Column(children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: brandGradient),
              child: CircleAvatar(radius: 30, backgroundColor: Colors.white, child: ClipOval(child: NetImage(profiles[i].photo, width: 56, height: 56))),
            ),
            const SizedBox(height: 6),
            Text(profiles[i].name, style: const TextStyle(fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
      const SizedBox(height: 8),
      ...chats.map((c) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetail(chat: c))),
            leading: Stack(children: [
              CircleAvatar(radius: 28, child: ClipOval(child: NetImage(c.profile.photo, width: 56, height: 56))),
              if (c.online) Positioned(right: 0, bottom: 0, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: const Color(0xFF22C55E), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
            ]),
            title: Text(c.profile.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(c.last, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(c.time, style: const TextStyle(fontSize: 12, color: Colors.black45)),
              if (c.unread > 0) ...[const SizedBox(height: 4), CircleAvatar(radius: 10, backgroundColor: brand, child: Text('${c.unread}', style: const TextStyle(fontSize: 11, color: Colors.white)))],
            ]),
          )),
    ]);
  }
}

class ChatDetail extends StatefulWidget {
  const ChatDetail({super.key, required this.chat});
  final Chat chat;
  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final ctrl = TextEditingController();
  late final messages = <(String, bool)>[
    ('Hey! Loved your travel photos 📸', true),
    ('Thank you! Your dog is adorable btw', false),
    ('Haha he runs the house. Where was that mountain shot?', true),
    (widget.chat.last, false),
  ];

  void send() {
    if (ctrl.text.trim().isEmpty) return;
    setState(() => messages.add((ctrl.text.trim(), true)));
    ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.chat.profile;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(children: [
          CircleAvatar(radius: 20, child: ClipOval(child: NetImage(p.photo, width: 40, height: 40))),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(widget.chat.online ? 'Online' : 'Active recently', style: const TextStyle(fontSize: 12, color: Colors.black45)),
          ]),
        ]),
        actions: [
          IconButton(onPressed: () => Contact.show(context, appName, 'Video Calls'), icon: const Icon(Icons.videocam_outlined)),
          IconButton(onPressed: () => Contact.show(context, appName, 'Report, Block & Safety Centre'), icon: const Icon(Icons.shield_outlined)),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: messages.map((m) {
              final mine = m.$2;
              return Align(
                alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  constraints: const BoxConstraints(maxWidth: 280),
                  decoration: BoxDecoration(
                    gradient: mine ? brandGradient : null,
                    color: mine ? null : Colors.white,
                    borderRadius: BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20), bottomLeft: Radius.circular(mine ? 20 : 4), bottomRight: Radius.circular(mine ? 4 : 20)),
                  ),
                  child: Text(m.$1, style: TextStyle(color: mine ? Colors.white : Colors.black87, height: 1.35)),
                ),
              );
            }).toList(),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Row(children: [
              IconButton(onPressed: () => Contact.show(context, appName, 'GIFs, Voice Notes & Media'), icon: const Icon(Icons.add_circle_outline, color: brand)),
              Expanded(
                child: TextField(
                  controller: ctrl,
                  onSubmitted: (_) => send(),
                  decoration: InputDecoration(hintText: 'Type a message…', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 20)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(onPressed: send, icon: const Icon(Icons.send_rounded)),
            ]),
          ),
        ),
      ]),
    );
  }
}
