import 'dart:ui';
import 'package:ai_vital/screens/hospitals/controller/hospital_controller.dart';
import 'package:ai_vital/screens/hospitals/widgets/hospital_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Hospitals extends StatelessWidget {
  Hospitals({super.key});
  final HospitalController controller = Get.find<HospitalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.red,
        elevation: 3,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(
          "Nearest Hospitals",
          style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          controller.isLoading.value
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Hospitals near your location",
                          style: GoogleFonts.publicSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          const SizedBox(height: 20),
          // Hospital List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.red,
                    size: 60,
                  ),
                );
              }

              if (controller.hospitals.isEmpty) {
                return const Center(
                  child: Text(
                    "No hospitals found nearby",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.hospitals.length,
                itemBuilder: (context, index) {
                  final hospital = controller.hospitals[index];
                  final distance = hospital['distance'] ?? '—';
                  final address =
                      hospital['address'] ?? 'Address not available';
                  final bool isOpen = hospital['isOpen'] as bool? ?? false;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => HospitalDetailsPage(hospital: hospital));
                        //       controller.openInMaps(
                        //   hospital['lat'],
                        //   hospital['lon'],
                        // ),
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            // Main shadow for elevation
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: const Offset(0, 8),
                            ),
                            // Subtle secondary shadow for depth
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hospital Icon
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.local_hospital_rounded,
                                color: Colors.red.shade700,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Hospital Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title + Badge
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          hospital['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.publicSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey.shade900,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isOpen
                                              ? Colors.greenAccent.shade700
                                              : Colors.redAccent.shade700,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          isOpen ? "Open" : "Closed",
                                          style: GoogleFonts.publicSans(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  // Address
                                  Text(
                                    address,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.publicSans(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Distance and Maps icon
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "$distance km away",
                                        style: GoogleFonts.publicSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                      Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.red.shade600,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
