import 'package:flutter/services.dart';

class HashtagInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final regex = RegExp(r'^[#A-Za-z0-9\s]+$');
    if (!regex.hasMatch(newValue.text)) {
      return oldValue;
    }

    List<String> words = newValue.text.split(' ').map((word) {
      if (word.isNotEmpty && !word.startsWith('#')) {
        return '#$word';
      }
      return word;
    }).toList();

    String formattedText = words.join(' ');

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
