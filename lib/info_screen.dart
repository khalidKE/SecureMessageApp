import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  final String algorithmName;
  final String description;
  final String videoUrl;

  const InfoScreen({
    required this.algorithmName,
    required this.description,
    required this.videoUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          algorithmName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  //logic
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://img.youtube.com/vi/${Uri.parse(videoUrl).queryParameters['v']}/hqdefault.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_circle_filled,
                      size: 60,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    //logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 60, 94, 110),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Watch Video",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
