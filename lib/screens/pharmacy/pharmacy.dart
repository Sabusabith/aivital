import 'package:ai_vital/screens/pharmacy/controller/pharmacy_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Pharmacy extends StatelessWidget {
  Pharmacy({super.key});

  final PharmacyController controller = Get.find<PharmacyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        centerTitle: true,
        toolbarHeight: 70,
        backgroundColor: Colors.purple.shade600,
        title: Text(
          "Nearest Pharmacies",
          style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),

        elevation: 3,
      ),
      body: Obx(() {
        return RefreshIndicator(
          color: Colors.purple.shade400,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await controller.fetchNearbyPharmacies();
          },
          child: controller.isLoading.value
              ? Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.purple.shade500,
                    size: 60,
                  ),
                )
              : controller.pharmacies.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 100,
                  ),
                  child: Center(
                    child: Text(
                      "No pharmacies found nearby.",
                      style: GoogleFonts.publicSans(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.pharmacies.length,
                  itemBuilder: (context, index) {
                    final pharmacy = controller.pharmacies[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        title: Text(
                          pharmacy['name'] ?? 'Unnamed Pharmacy',
                          style: GoogleFonts.publicSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              pharmacy['address'] ?? '',
                              style: GoogleFonts.publicSans(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.purple.shade400,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${pharmacy['distance']} km away",
                                  style: GoogleFonts.publicSans(
                                    fontSize: 13,
                                    color: Colors.purple.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            controller.openInMaps(
                              pharmacy['lat'],
                              pharmacy['lon'],
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.directions,
                              color: Colors.purple.shade500,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      }),
    );
  }
}
