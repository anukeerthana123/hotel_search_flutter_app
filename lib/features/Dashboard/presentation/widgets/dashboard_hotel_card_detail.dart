import 'package:flutter/material.dart';
import 'package:mytravaly/features/Dashboard/domain/entities/dasboard_hotel_list_entity.dart';

class HotelDetailPage extends StatelessWidget {
  final HotelEntity hotel;
  const HotelDetailPage({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final teal = Colors.teal;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // --- Collapsing image app bar ---
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12, top: 6),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              stretchModes: const [StretchMode.zoomBackground],
              background: Hero(
                tag: hotel.propertyCode + hotel.propertyImage,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      hotel.propertyImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 80),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 16,
                      right: 16,
                      child: Text(
                        hotel.propertyName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              color: Colors.black38,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- Details content ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating + Price
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[600], size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${hotel.googleReview.overallRating?.toStringAsFixed(1) ?? '-'} (${hotel.googleReview.totalUserRating ?? 0} reviews)',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        hotel.staticPrice.displayAmount,
                        style: TextStyle(
                          color: teal.shade700,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${hotel.propertyAddress.street}, ${hotel.propertyAddress.city}',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(thickness: 1.2, color: Colors.grey[300]),
                  const SizedBox(height: 16),

                  // Amenities section
                  const Text('Amenities & Policies',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),

                  _buildAmenityRow(Icons.wifi, 'Free WiFi',
                      hotel.propertyPoliciesAndAmenities.data!.freeWifi),
                  _buildAmenityRow(Icons.pets, 'Pets Allowed',
                      hotel.propertyPoliciesAndAmenities.data!.petsAllowed),
                  _buildAmenityRow(Icons.favorite, 'Couple Friendly',
                      hotel.propertyPoliciesAndAmenities.data!.coupleFriendly),
                  _buildAmenityRow(
                      Icons.child_care,
                      'Child Friendly',
                      hotel.propertyPoliciesAndAmenities.data!
                          .suitableForChildren),
                  _buildAmenityRow(Icons.payments, 'Pay at Hotel',
                      hotel.propertyPoliciesAndAmenities.data!.payAtHotel),
                  _buildAmenityRow(
                      Icons.cancel,
                      'Free Cancellation',
                      hotel
                          .propertyPoliciesAndAmenities.data!.freeCancellation),

                  const SizedBox(height: 20),
                  Divider(thickness: 1.2, color: Colors.grey[300]),
                  const SizedBox(height: 16),

                  // Policies
                  const Text('Policies',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  _policyTile('Cancellation Policy',
                      hotel.propertyPoliciesAndAmenities.data!.cancelPolicy),
                  _policyTile('Refund Policy',
                      hotel.propertyPoliciesAndAmenities.data!.refundPolicy),
                  _policyTile('Child Policy',
                      hotel.propertyPoliciesAndAmenities.data!.childPolicy),
                  _policyTile('Damage Policy',
                      hotel.propertyPoliciesAndAmenities.data!.damagePolicy),
                  _policyTile(
                      'Property Restriction',
                      hotel.propertyPoliciesAndAmenities.data!
                          .propertyRestriction),

                  const SizedBox(height: 30),

                  // Book Now Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // open property URL
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Redirecting to booking page: ${hotel.propertyUrl}')),
                        );
                      },
                      icon: const Icon(Icons.hotel),
                      label: const Text(
                        'Book Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal.shade700,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityRow(IconData icon, String label, bool available) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: available ? Colors.teal : Colors.grey),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: available ? Colors.black87 : Colors.black38,
              fontSize: 15,
            ),
          ),
          const Spacer(),
          Icon(
            available ? Icons.check_circle : Icons.cancel,
            color: available ? Colors.teal : Colors.redAccent,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _policyTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 6),
            Text(
              value.isNotEmpty ? value : 'Not available',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
