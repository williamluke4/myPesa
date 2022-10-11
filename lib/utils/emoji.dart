import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji_picker;

String generateRandomEmoji() {
  final random = Random();
  final emojiSet = emoji_picker
      .defaultEmojiSet[random.nextInt(emoji_picker.defaultEmojiSet.length)];
  return emojiSet.emoji[random.nextInt(emojiSet.emoji.length)].emoji;
}
