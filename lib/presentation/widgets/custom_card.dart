import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String data;
  final String title;

  const CustomCard({
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
          Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Text(
            data,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ),
          ),
           Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.0,
              color: Color.fromARGB(255, 182, 182, 182),
            ),
          ),
        ],
      ),
    );
  }
}
