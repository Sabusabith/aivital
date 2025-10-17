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

              return RefreshIndicator(
                color: Colors.redAccent,
                backgroundColor: Colors.white,
                onRefresh: () async {
                  await controller.fetchNearbyHospitals();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: controller.hospitals.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: const Center(
                            child: Text(
                              "No hospitals found nearby",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: controller.hospitals.map((hospital) {
                            final distance = hospital['distance'] ?? '—';
                            final address =
                                hospital['address'] ?? 'Address not available';
                            final bool isOpen =
                                hospital['isOpen'] as bool? ?? false;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: InkWell(
                                onTap: () => Get.to(
                                  () => HospitalDetailsPage(hospital: hospital),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 8),
                                      ),
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.local_hospital_rounded,
                                          color: Colors.red.shade700,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    hospital['name'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.publicSans(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors
                                                              .grey
                                                              .shade900,
                                                        ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: isOpen
                                                        ? Colors
                                                              .greenAccent
                                                              .shade700
                                                        : Colors
                                                              .redAccent
                                                              .shade700,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    isOpen ? "Open" : "Closed",
                                                    style:
                                                        GoogleFonts.publicSans(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
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
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_rounded,
                                                  color: Colors.green.shade700,
                                                  size: 15,
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  "$distance km away",
                                                  style: GoogleFonts.publicSans(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.green.shade700,
                                                  ),
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
                          }).toList(),
                        ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
