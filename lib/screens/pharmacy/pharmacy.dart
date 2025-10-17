import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Pharmacy extends StatelessWidget {
  const Pharmacy({super.key});

  final List<Map<String, String>> pharmacies = const [
    {"name": "Health Plus Pharmacy", "address": "123 Main Street"},
    {"name": "CityCare Pharmacy", "address": "456 Oak Avenue"},
    {"name": "Wellness Pharmacy", "address": "789 Pine Road"},
    {"name": "Medicure Pharmacy", "address": "321 Maple Lane"},
    {"name": "QuickMed Pharmacy", "address": "654 Elm Street"},
    {"name": "CityCare Pharmacy", "address": "456 Oak Avenue"},
    {"name": "Medicure Pharmacy", "address": "321 Maple Lane"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        toolbarHeight: 70,
        title: Text(
          "Nearest Pharmacies",
          style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.purple,

        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Pharmacies near your location",
                style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: pharmacies.length,
                itemBuilder: (context, index) {
                  final pharmacy = pharmacies[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      title: Text(
                        pharmacy["name"]!,
                        style: GoogleFonts.publicSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Text(
                        pharmacy["address"]!,
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // TODO: Open map or directions
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.purple.shade400,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
