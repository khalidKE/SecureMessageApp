import 'package:algorithm/info_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class CipherHomePage extends StatefulWidget {
  const CipherHomePage({super.key});

  @override
  _CipherHomePageState createState() => _CipherHomePageState();
}

class _CipherHomePageState extends State<CipherHomePage> {
  final TextEditingController _messageController = TextEditingController();
  String _selectedCipher = 'Caesar Cipher';
  String _result = '';
  final String _keyword = 'KEYWORD';
  int _shift = 0;

  String encrypt(String input, String cipher) {
    switch (cipher) {
      case 'Caesar Cipher':
        return _caesarEncrypt(input, _shift);
      case 'Monoalphabetic Cipher':
        return _monoalphabeticEncrypt(input);
      case 'Hill Cipher':
        return _hillCipherEncrypt(input);
      case 'Row-Column Transposition Cipher':
        return _rowColumnEncrypt(input, 3);
      case 'One-Time Pad':
        return _oneTimePadEncrypt(input);
      case 'Polyalphabetic Cipher':
        return _vigenereEncrypt(input, _keyword);
      case 'Playfair Cipher':
        return _playfairEncrypt(input, _keyword);
      case 'Rail Fence Cipher':
        return _railFenceEncrypt(input, 3);
      default:
        return input;
    }
  }

  String decrypt(String input, String cipher) {
    switch (cipher) {
      case 'Caesar Cipher':
        return _caesarDecrypt(input, _shift);
      case 'Monoalphabetic Cipher':
        return _monoalphabeticDecrypt(input);
      case 'Hill Cipher':
        return _hillCipherDecrypt(input);
      case 'Row-Column Transposition Cipher':
        return _rowColumnDecrypt(input, 3);
      case 'One-Time Pad':
        return _oneTimePadDecrypt(input);
      case 'Polyalphabetic Cipher':
        return _vigenereDecrypt(input, _keyword);
      case 'Playfair Cipher':
        return _playfairDecrypt(input, _keyword);
      case 'Rail Fence Cipher':
        return _railFenceDecrypt(input, 3);
      default:
        return input;
    }
  }

  String _hillCipherEncrypt(String plaintext) {
    List<List<int>> keyMatrix = [
      [3, 3],
      [2, 5]
    ];

    plaintext = plaintext.replaceAll(' ', '').toUpperCase();

    if (plaintext.length % 2 != 0) {
      plaintext += 'X';
    }

    String ciphertext = '';
    for (int i = 0; i < plaintext.length; i += 2) {
      List<int> block = [
        plaintext.codeUnitAt(i) - 65,
        plaintext.codeUnitAt(i + 1) - 65
      ];
      List<int> encryptedBlock = [
        (keyMatrix[0][0] * block[0] + keyMatrix[0][1] * block[1]) % 26,
        (keyMatrix[1][0] * block[0] + keyMatrix[1][1] * block[1]) % 26
      ];
      ciphertext += String.fromCharCode(encryptedBlock[0] + 65);
      ciphertext += String.fromCharCode(encryptedBlock[1] + 65);
    }

    return ciphertext;
  }

  String _hillCipherDecrypt(String ciphertext) {
    List<List<int>> keyMatrix = [
      [3, 3],
      [2, 5]
    ];

    ciphertext = ciphertext.replaceAll(' ', '').toUpperCase();

    int det = (keyMatrix[0][0] * keyMatrix[1][1] -
            keyMatrix[0][1] * keyMatrix[1][0]) %
        26;
    int detInv = _modInverse(det, 26);
    List<List<int>> adjugate = [
      [keyMatrix[1][1], -keyMatrix[0][1]],
      [-keyMatrix[1][0], keyMatrix[0][0]]
    ];
    List<List<int>> inverseMatrix = [
      [(detInv * adjugate[0][0]) % 26, (detInv * adjugate[0][1]) % 26],
      [(detInv * adjugate[1][0]) % 26, (detInv * adjugate[1][1]) % 26]
    ];

    String plaintext = '';
    for (int i = 0; i < ciphertext.length; i += 2) {
      List<int> block = [
        ciphertext.codeUnitAt(i) - 65,
        ciphertext.codeUnitAt(i + 1) - 65
      ];
      List<int> decryptedBlock = [
        (inverseMatrix[0][0] * block[0] + inverseMatrix[0][1] * block[1]) % 26,
        (inverseMatrix[1][0] * block[0] + inverseMatrix[1][1] * block[1]) % 26
      ];
      plaintext += String.fromCharCode(decryptedBlock[0] + 65);
      plaintext += String.fromCharCode(decryptedBlock[1] + 65);
    }

    return plaintext;
  }

  int _modInverse(int a, int m) {
    a = a % m;
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) {
        return x;
      }
    }
    return 1;
  }

  String _caesarEncrypt(String input, int shift) {
    return String.fromCharCodes(input.runes.map((int rune) {
      var character = String.fromCharCode(rune);
      if (character.contains(RegExp(r'[a-zA-Z]'))) {
        var base = character.codeUnitAt(0) < 91 ? 65 : 97;
        return ((rune - base + shift) % 26 + base);
      }
      return rune;
    }));
  }

  String _caesarDecrypt(String input, int shift) {
    return _caesarEncrypt(input, 26 - (shift % 26));
  }

  String _monoalphabeticEncrypt(String input) {
    const String alphabet = 'abcdefghijklmnopqrstuvwxyz';
    const String key = 'qwertyuiopasdfghjklzxcvbnm';
    String result = '';
    for (var char in input.toLowerCase().runes) {
      if (alphabet.contains(String.fromCharCode(char))) {
        result += key[alphabet.indexOf(String.fromCharCode(char))];
      } else {
        result += String.fromCharCode(char);
      }
    }
    return result;
  }

  String _monoalphabeticDecrypt(String input) {
    const String alphabet = 'abcdefghijklmnopqrstuvwxyz';
    const String key = 'qwertyuiopasdfghjklzxcvbnm';
    String result = '';
    for (var char in input.toLowerCase().runes) {
      if (key.contains(String.fromCharCode(char))) {
        result += alphabet[key.indexOf(String.fromCharCode(char))];
      } else {
        result += String.fromCharCode(char);
      }
    }
    return result;
  }

  String _rowColumnEncrypt(String text, int row) {
    int col = (text.length / row).ceil();
    List<List<String>> matrix = List.generate(row, (i) => List.filled(col, ''));
    int index = 0;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (index < text.length) {
          matrix[i][j] = text[index];
          index++;
        }
      }
    }
    StringBuffer result = StringBuffer();
    for (int j = 0; j < col; j++) {
      for (int i = 0; i < row; i++) {
        if (matrix[i][j] != '') {
          result.write(matrix[i][j]);
        }
      }
    }
    return result.toString();
  }

  String _rowColumnDecrypt(String text, int row) {
    int col = (text.length / row).ceil();
    List<List<String>> matrix = List.generate(row, (i) => List.filled(col, ''));
    int index = 0;

    for (int j = 0; j < col; j++) {
      for (int i = 0; i < row; i++) {
        if (index < text.length) {
          matrix[i][j] = text[index];
          index++;
        }
      }
    }

    StringBuffer result = StringBuffer();
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        result.write(matrix[i][j]);
      }
    }
    return result.toString();
  }

  String _oneTimePadEncrypt(String input) {
    final random = Random();
    String key = List.generate(
            input.length, (index) => String.fromCharCode(random.nextInt(256)))
        .join();
    String result = _xorEncrypt(input, key);
    return '$result|$key';
  }

  String _oneTimePadDecrypt(String input) {
    var parts = input.split('|');
    if (parts.length != 2) return 'Invalid format';
    String encrypted = parts[0];
    String key = parts[1];
    return _xorDecrypt(encrypted, key);
  }

  String _vigenereEncrypt(String text, String key) {
    String result = '';
    for (int i = 0, j = 0; i < text.length; i++) {
      var char = text[i];
      if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
        var base =
            char.toUpperCase() == char ? 'A'.codeUnitAt(0) : 'a'.codeUnitAt(0);
        result += String.fromCharCode(
          (char.codeUnitAt(0) + key[j % key.length].codeUnitAt(0) - 2 * base) %
                  26 +
              base,
        );
        j++;
      } else {
        result += char;
      }
    }
    return result;
  }

  String _vigenereDecrypt(String text, String key) {
    String result = '';
    for (int i = 0, j = 0; i < text.length; i++) {
      var char = text[i];
      if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
        var base =
            char.toUpperCase() == char ? 'A'.codeUnitAt(0) : 'a'.codeUnitAt(0);
        result += String.fromCharCode(
          (char.codeUnitAt(0) - key[j % key.length].codeUnitAt(0) + 26) % 26 +
              base,
        );
        j++;
      } else {
        result += char;
      }
    }
    return result;
  }

  String _railFenceEncrypt(String text, int key) {
    if (key <= 1) return text;
    List<StringBuffer> rows = List.generate(key, (_) => StringBuffer());
    bool down = false;
    int row = 0;

    for (int i = 0; i < text.length; i++) {
      rows[row].write(text[i]);
      if (row == 0 || row == key - 1) down = !down;
      row += down ? 1 : -1;
    }

    return rows.map((sb) => sb.toString()).join();
  }

  String _railFenceDecrypt(String text, int key) {
    if (key <= 1) return text;

    List<int> rowLengths = List.filled(key, 0);
    bool down = false;
    int row = 0;

    for (int i = 0; i < text.length; i++) {
      rowLengths[row]++;
      if (row == 0 || row == key - 1) down = !down;
      row += down ? 1 : -1;
    }

    List<String> rows = [];
    int currentIndex = 0;
    for (int i = 0; i < key; i++) {
      rows.add(text.substring(currentIndex, currentIndex + rowLengths[i]));
      currentIndex += rowLengths[i];
    }

    StringBuffer result = StringBuffer();
    row = 0;
    down = false;
    List<int> rowIndices = List.filled(key, 0);

    for (int i = 0; i < text.length; i++) {
      result.write(rows[row][rowIndices[row]]);
      rowIndices[row]++;
      if (row == 0 || row == key - 1) down = !down;
      row += down ? 1 : -1;
    }

    return result.toString();
  }

  String _playfairEncrypt(String input, String key) {
    key = _prepareKey(key);
    input = _prepareText(input);
    StringBuffer result = StringBuffer();

    for (int i = 0; i < input.length; i += 2) {
      String a = input[i];
      String b = (i + 1 < input.length) ? input[i + 1] : 'X';

      if (a == b) {
        b = 'X';
        i--;
      }

      int row1 = key.indexOf(a) ~/ 5;
      int col1 = key.indexOf(a) % 5;
      int row2 = key.indexOf(b) ~/ 5;
      int col2 = key.indexOf(b) % 5;

      if (row1 == row2) {
        result.write(key[row1 * 5 + (col1 + 1) % 5]);
        result.write(key[row2 * 5 + (col2 + 1) % 5]);
      } else if (col1 == col2) {
        result.write(key[((row1 + 1) % 5) * 5 + col1]);
        result.write(key[((row2 + 1) % 5) * 5 + col2]);
      } else {
        result.write(key[row1 * 5 + col2]);
        result.write(key[row2 * 5 + col1]);
      }
    }

    return result.toString();
  }

  String _playfairDecrypt(String input, String key) {
    key = _prepareKey(key);
    input = _prepareText(input);
    StringBuffer result = StringBuffer();

    for (int i = 0; i < input.length; i += 2) {
      String a = input[i];
      String b = (i + 1 < input.length) ? input[i + 1] : 'X';

      int row1 = key.indexOf(a) ~/ 5;
      int col1 = key.indexOf(a) % 5;
      int row2 = key.indexOf(b) ~/ 5;
      int col2 = key.indexOf(b) % 5;

      if (row1 == row2) {
        result.write(key[row1 * 5 + (col1 + 4) % 5]);
        result.write(key[row2 * 5 + (col2 + 4) % 5]);
      } else if (col1 == col2) {
        result.write(key[((row1 + 4) % 5) * 5 + col1]);
        result.write(key[((row2 + 4) % 5) * 5 + col2]);
      } else {
        result.write(key[row1 * 5 + col2]);
        result.write(key[row2 * 5 + col1]);
      }
    }

    return result.toString();
  }

  String _prepareKey(String key) {
    String alphabet = 'ABCDEFGHIKLMNOPQRSTUVWXYZ';
    key = key
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z]'), '')
        .split('')
        .toSet()
        .toList()
        .join();
    String result = key;

    for (var char in alphabet.split('')) {
      if (!result.contains(char)) {
        result += char;
      }
    }

    return result;
  }

  String _prepareText(String text) {
    text = text.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    return text;
  }

  String _xorEncrypt(String input, String key) {
    StringBuffer output = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      output
          .writeCharCode(input.codeUnitAt(i) ^ key.codeUnitAt(i % key.length));
    }
    return output.toString();
  }

  String _xorDecrypt(String input, String key) {
    return _xorEncrypt(input, key);
  }

  void _processMessage(bool isEncrypt) {
    setState(() {
      if (isEncrypt) {
        _result = encrypt(_messageController.text, _selectedCipher);
      } else {
        _result = decrypt(_messageController.text, _selectedCipher);
      }
    });
  }

  void _navigateToInfoScreen() {
    String description;
    String videoUrl;
    switch (_selectedCipher) {
      case 'Caesar Cipher':
        description =
            'The Caesar Cipher is a type of substitution cipher in which each letter in the plaintext is shifted a certain number of places down the alphabet. It is one of the simplest and most widely known encryption techniques.';
        videoUrl = 'https://www.youtube.com/watch?v=sMOZf4GN3oc';
        break;
      case 'Monoalphabetic Cipher':
        description =
            'A monoalphabetic cipher uses a fixed substitution over the entire message. Each letter of the plaintext is mapped to a corresponding letter of the ciphertext alphabet.';
        videoUrl = 'https://www.youtube.com/watch?v=XjJcbS3Vbpg';
        break;
      case 'Hill Cipher':
        description =
            'The Hill cipher is a polygraphic substitution cipher based on linear algebra. It uses matrix multiplication to transform blocks of plaintext letters into ciphertext.';
        videoUrl = 'https://www.youtube.com/watch?v=-EQ8UomTrAQ';
        break;
      case 'Row-Column Transposition Cipher':
        description =
            'A transposition cipher that rearranges the characters of the plaintext into columns and then reads them off row by row. It is a simple yet effective method of encryption.';
        videoUrl = 'https://www.youtube.com/watch?v=3S-dEoxW1kk';
        break;
      case 'One-Time Pad':
        description =
            'The One-Time Pad is an encryption technique that cannot be cracked if used correctly. It uses a random key that is as long as the message itself, making it theoretically unbreakable.';
        videoUrl = 'https://www.youtube.com/watch?v=FlIG3TvQCBQ';
        break;
      case 'Polyalphabetic Cipher':
        description =
            'A polyalphabetic cipher uses multiple substitution alphabets to encrypt the data. The Vigenère cipher is a well-known example of a polyalphabetic cipher.';
        videoUrl = 'https://www.youtube.com/watch?v=BgFJD7oCmDE';
        break;
      case 'Playfair Cipher':
        description =
            'The Playfair cipher is a digraph substitution cipher that encrypts pairs of letters. It was invented by Charles Wheatstone in 1854 and was used by the British during World War I and World War II.';
        videoUrl = 'https://www.youtube.com/watch?v=quKhvu2tPy8';
        break;
      case 'Rail Fence Cipher':
        description =
            'The Rail Fence Cipher is a form of transposition cipher that gets its name from the way in which it is encoded. The plaintext is written in a zigzag pattern on an imaginary fence, and then read off row by row.';
        videoUrl = 'https://www.youtube.com/watch?v=2oqe6jSAxog';
        break;
      default:
        description = '';
        videoUrl = '';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoScreen(
          algorithmName: _selectedCipher,
          description: description,
          videoUrl: videoUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _selectedCipher,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Message:',
                    style: TextStyle(fontSize: 18, color: Colors.white70)),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _messageController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Write your message',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: _messageController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _messageController.clear();
                                _result = '';
                              });
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Cipher:',
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCipher,
                      hint: const Text(
                        'Select a cipher',
                        style: TextStyle(color: Colors.white),
                      ),
                      items: [
                        'Caesar Cipher',
                        'Monoalphabetic Cipher',
                        'Hill Cipher',
                        'Row-Column Transposition Cipher',
                        'One-Time Pad',
                        'Polyalphabetic Cipher',
                        'Playfair Cipher',
                        'Rail Fence Cipher',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: 300,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCipher = value!;
                        });
                      },
                      dropdownColor: Colors.black,
                      iconEnabledColor: Colors.white,
                      style: const TextStyle(fontSize: 20),
                      isExpanded: true,
                      menuMaxHeight: 200,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedCipher == 'Caesar Cipher') ...[
                  const Text(
                    'Shift / a:',
                    style: TextStyle(color: Color.fromARGB(190, 255, 255, 255)),
                  ),
                  DropdownButton<int>(
                    value: _shift,
                    items: List.generate(26, (index) => index).map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: TextStyle(
                            color: value == _shift
                                ? const Color.fromARGB(255, 73, 133, 163)
                                : Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _shift = value!;
                      });
                    },
                    dropdownColor: Colors.black,
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    isExpanded: true,
                    menuMaxHeight: 200,
                  ),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _processMessage(true),
                  child: const Text(
                    'Encrypt',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _processMessage(false),
                  child: const Text('Decrypt',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _navigateToInfoScreen,
                  child: const Text('Info',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
                const SizedBox(height: 16),
                const Text('Result:',
                    style: TextStyle(fontSize: 18, color: Colors.white70)),
                if (_result.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SelectableText(
                          _result,
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.copy,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _result));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied!')),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
