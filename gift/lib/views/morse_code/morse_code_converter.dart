import 'package:flutter/material.dart';

class MorseCodeConverter extends StatefulWidget {
  const MorseCodeConverter({Key? key}) : super(key: key);

  @override
  _MorseCodeConverterState createState() => _MorseCodeConverterState();
}

class _MorseCodeConverterState extends State<MorseCodeConverter> {
  final TextEditingController _inputController = TextEditingController();
  String _output = '';
  bool _isMorseToText = true;

  final Map<String, String> morseDict = {
    '.-': 'a', '--.': 'g', '--': 'm', '...': 's', '-.--': 'y',
    '-...': 'b', '....': 'h', '-.': 'n', '-': 't', '--..': 'z',
    '-.-.': 'c', '..': 'i', '---': 'o', '..-': 'u',
    '-..': 'd', '.---': 'j', '.--.': 'p', '...-': 'v',
    '.': 'e', '-.-': 'k', '--.-': 'q', '.--': 'w',
    '..-.': 'f', '.-..': 'l', '.-.': 'r', '-..-': 'x',
  };

  final Map<String, String> textDict = {
    'a': '.-', 'g': '--.', 'm': '--', 's': '...', 'y': '-.--',
    'b': '-...', 'h': '....', 'n': '-.', 't': '-', 'z': '--..',
    'c': '-.-.', 'i': '..', 'o': '---', 'u': '..-',
    'd': '-..', 'j': '.---', 'p': '.--.', 'v': '...-',
    'e': '.', 'k': '-.-', 'q': '--.-', 'w': '.--',
    'f': '..-.', 'l': '.-..', 'r': '.-.', 'x': '-..-',
  };

  void _convert() {
    String input = _inputController.text.trim();
    if (_isMorseToText) {
      setState(() {
        _output = convertMorseToText(input);
      });
    } else {
      setState(() {
        _output = textToMorseCode(input);
      });
    }
  }

  String convertMorseToText(String userInput) {
    String text = "";
    List<String> words = userInput.trim().split('/');
    for (String morseCodes in words) {
      if (morseCodes.isNotEmpty) {
        List<String> morseList = morseCodes.trim().split(' ');
        for (String morse in morseList) {
          text += morseDict[morse.replaceAll("_", "-")]!;
        }
        text += " ";
      }
    }
    return text.trim();
  }

  String textToMorseCode(String userInput) {
    String morseCode = "";
    for (String word in userInput.trim().split(' ')) {
      for (int i = 0; i < word.length; i++) {
        morseCode += textDict[word[i].toLowerCase()]! + " ";
      }
      morseCode += "/";
    }
    return morseCode.substring(0, morseCode.length - 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Morse Code Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Text to Morse'),
                Switch(
                  value: _isMorseToText,
                  onChanged: (value) {
                    setState(() {
                      _isMorseToText = value;
                      _inputController.clear();
                      _output = '';
                    });
                  },
                ),
                const Text('Morse to Text'),
              ],
            ),
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: 'Enter ${_isMorseToText ? 'Morse Code' : 'Text'}',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Output:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(_output),
          ],
        ),
      ),
    );
  }
}
