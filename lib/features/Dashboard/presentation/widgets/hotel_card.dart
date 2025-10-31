// lib/features/Dashboard/presentation/widgets/hotel_card.dart

import 'package:flutter/material.dart';
import 'package:mytravaly/features/Dashboard/domain/entities/dasboard_hotel_list_entity.dart';

class HotelCard extends StatelessWidget {
  final HotelEntity hotel;
  final VoidCallback onTap;
  const HotelCard({super.key, required this.hotel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final teal = Colors.teal;
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: hotel.propertyCode + hotel.propertyImage,
        child: Material(
          color: Colors.transparent,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.96),
                  Colors.white.withOpacity(0.92)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                    color: teal.withOpacity(0.12),
                    blurRadius: 18,
                    spreadRadius: 1,
                    offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with subtle overlay & rounded corners
                Stack(
                  children: [
                    SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: Image.network(
                        hotel.propertyImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, size: 40)),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.amber[600], size: 14),
                            const SizedBox(width: 6),
                            Text(
                                '${hotel.googleReview.overallRating?.toStringAsFixed(1) ?? '-'}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // info
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hotel.propertyName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 14, color: teal.shade600),
                            const SizedBox(width: 6),
                            Expanded(
                                child: Text(
                                    '${hotel.propertyAddress.city}, ${hotel.propertyAddress.state}',
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 13))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(hotel.staticPrice.displayAmount,
                                style: TextStyle(
                                    color: teal.shade700,
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: teal.shade600.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(hotel.propertyType.capitalizeFirst(),
                                  style: TextStyle(
                                      color: teal.shade700, fontSize: 12)),
                            ),
                          ],
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// small helper extension
extension _Cap on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return substring(0, 1).toUpperCase() + substring(1);
  }
}
