import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:frontend/sections/chat.dart';
import 'package:frontend/sections/chat_stream.dart';
import 'package:frontend/sections/embed_batch_contents.dart';
import 'package:frontend/sections/embed_content.dart';
import 'package:frontend/sections/response_widget_stream.dart';
import 'package:frontend/sections/stream.dart';
import 'package:frontend/sections/text_and_image.dart';
import 'package:frontend/sections/text_only.dart';

class SectionItem {
  final int index;
  final String title;
  final Widget widget;

  SectionItem(this.index, this.title, this.widget);
}

class GeminiChat extends StatefulWidget {
  const GeminiChat({super.key});

  @override
  State<GeminiChat> createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {
  int _selectedItem = 0;

  final _sections = <SectionItem>[
    SectionItem(0, 'chat', const SectionChat()),
    SectionItem(1, 'Stream text', const SectionTextStreamInput()),
    SectionItem(2, 'textAndImage', const SectionTextAndImageInput()),
    SectionItem(3, 'Stream chat', const SectionStreamChat()),
    SectionItem(4, 'text', const SectionTextInput()),
    SectionItem(5, 'embedContent', const SectionEmbedContent()),
    SectionItem(6, 'batchEmbedContents', const SectionBatchEmbedContents()),
    SectionItem(
        7, 'response without setState()', const ResponseWidgetSection()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_selectedItem == 0
            ? 'Flutter Gemini'
            : _sections[_selectedItem].title),
        actions: [
          PopupMenuButton<int>(
            initialValue: _selectedItem,
            onSelected: (value) => setState(() => _selectedItem = value),
            itemBuilder: (context) => _sections.map((e) {
              return PopupMenuItem<int>(value: e.index, child: Text(e.title));
            }).toList(),
            child: const Icon(Icons.more_vert_rounded),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedItem,
        children: _sections.map((e) => e.widget).toList(),
      ),
    );
  }
}
