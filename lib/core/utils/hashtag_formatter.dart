import 'package:flutter/services.dart';

class HashtagInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow empty field (so users can clear input)
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Regex to allow only hashtags, alphanumeric characters, and spaces
    final regex = RegExp(r'^[#A-Za-z0-9\s]+$');
    if (!regex.hasMatch(newValue.text)) {
      return oldValue; // Reject input if it contains invalid characters
    }

    // Split the text by spaces and ensure each word starts with #
    List<String> words = newValue.text.split(' ').map((word) {
      if (word.isNotEmpty && !word.startsWith('#')) {
        return '#$word'; // Add # if not already present
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
