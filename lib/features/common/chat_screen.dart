import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final List<_Msg> _messages = [
    _Msg('Hello, good morning!', false,
        DateTime.now().subtract(const Duration(hours: 2))),
    _Msg('Morning ma\'am. About tomorrow\'s homework...', true,
        DateTime.now().subtract(const Duration(hours: 2, minutes: -1))),
    _Msg('Yes, please complete exercises 4.1 to 4.5.', false,
        DateTime.now().subtract(const Duration(hours: 1, minutes: 55))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rajesh Kumar', style: TextStyle(fontSize: 16)),
            Text('Class Teacher',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return Align(
                  alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: m.mine ? Colors.blue.shade500 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(m.body,
                            style: TextStyle(
                                color: m.mine ? Colors.white : Colors.black87)),
                        const SizedBox(height: 2),
                        Text(DateFormat('h:mm a').format(m.at),
                            style: TextStyle(
                                fontSize: 10,
                                color: m.mine
                                    ? Colors.white70
                                    : Colors.grey.shade600)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {
                      if (_ctrl.text.trim().isEmpty) return;
                      setState(() {
                        _messages.add(_Msg(_ctrl.text.trim(), true, DateTime.now()));
                        _ctrl.clear();
                      });
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  final String body;
  final bool mine;
  final DateTime at;
  _Msg(this.body, this.mine, this.at);
}
