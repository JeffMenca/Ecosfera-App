import 'package:flutter/material.dart';

class CustomCardSeparated extends StatelessWidget {
  final String icon;
  final String data;
  final String title;

  const CustomCardSeparated({
    Key? key,
    required this.icon,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF20232A),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Color.fromARGB(255, 182, 182, 182),
                  ),
                ),
                const SizedBox(height: 10),
                Image.network(
                  icon,
                  fit: BoxFit.contain,
                  width: 30.0,
                  height: 30.0,
                ),
                const SizedBox(height: 10), // Separación adicional
                Text(
                  data,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
