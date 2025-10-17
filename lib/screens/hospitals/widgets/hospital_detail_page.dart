import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_vital/screens/hospitals/controller/hospital_controller.dart';

class HospitalDetailsPage extends StatelessWidget {
  final Map<String, dynamic> hospital;
  final HospitalController controller = Get.find<HospitalController>();

  HospitalDetailsPage({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    final bool isOpen = hospital['isOpen'] as bool? ?? false;
    final Color statusColor = isOpen ? Colors.green : Colors.redAccent;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          hospital['name'] ?? "Hospital Details",
          style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header image placeholder
            const SizedBox(height: 20),

            // Status Badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    isOpen ? "Open Now" : "Closed",
                    style: GoogleFonts.publicSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  isOpen ? Icons.check_circle : Icons.cancel,
                  color: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Info Cards
            _infoCard(
              icon: Icons.local_hospital_rounded,
              title: "Hospital Name",
              content: hospital['name'] ?? "Unknown",
            ),
            const SizedBox(height: 12),
            _infoCard(
              icon: Icons.location_on_rounded,
              title: "Address",
              content: hospital['address'] ?? "Address not available",
            ),
            const SizedBox(height: 12),
            _infoCard(
              icon: Icons.map_rounded,
              title: "Distance",
              content: "${hospital['distance'] ?? '—'} km away",
            ),
            const SizedBox(height: 12),

            if (hospital['opening_hours'] != null) // optional opening hours
              _infoCard(
                icon: Icons.access_time_rounded,
                title: "Opening Hours",
                content: hospital['opening_hours'],
              ),

            const SizedBox(height: 30),

            // Open in Maps Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.openInMaps(hospital['lat'], hospital['lon']);
                },
                icon: const Icon(Icons.map_rounded),
                label: const Text(
                  "Open in Maps",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable info card
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: GoogleFonts.publicSans(
                    fontSize: 14,
                    color: Colors.grey.shade700,
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
