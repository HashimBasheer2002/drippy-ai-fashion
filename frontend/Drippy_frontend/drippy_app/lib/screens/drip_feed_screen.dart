import 'package:flutter/material.dart';

class DripFeedScreen extends StatelessWidget {
  const DripFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Drippy"),
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
      ),

      body: ListView.builder(

        itemCount: 10,

        itemBuilder: (context,index){

          return Container(

            margin: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Column(

              children: [

                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Drip Score: 8.5",
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

              ],
            ),

          );

        },

      ),

    );
  }
}