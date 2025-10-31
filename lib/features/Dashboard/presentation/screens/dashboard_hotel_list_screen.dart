// lib/features/Dashboard/presentation/screens/dashboard_hotel_list_screen.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytravaly/core/utils/shared_preference.dart';
import 'package:mytravaly/features/Dashboard/presentation/bloc/dasboard_hotel_list.event.dart';
import 'package:mytravaly/features/Dashboard/presentation/bloc/dasboard_hotel_list_bloc.dart';
import 'package:mytravaly/features/Dashboard/presentation/bloc/dasboard_hotel_list_state.dart';
import 'package:mytravaly/features/Dashboard/presentation/widgets/dashboard_search_overlay.dart';
import 'package:mytravaly/features/Dashboard/presentation/widgets/hotel_search_card.dart';
import 'package:mytravaly/features/google_signIn_signUp/presentation/screens/google_signin_screen.dart';

import '../widgets/hotel_card.dart';

class DashboardPage extends StatefulWidget {
  final String visitorToken;
  const DashboardPage({super.key, required this.visitorToken});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  late final Animation<double> _fadeIn;
  String _lastQuerySummary = '';

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeIn =
        CurvedAnimation(parent: _staggerController, curve: Curves.easeOut);

    // Dispatch initial load once
    context.read<DashboardBloc>().add(LoadHotelsEvent(widget.visitorToken));

    // Start animations after a tiny delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await TokenHelper.clearVisitorToken();

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GoogleSigninScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have been logged out.')),
        );
      }
    }
  }

  Future<void> _openSearch() async {
    // show transparent full-screen search overlay and await result
    final result = await showGeneralDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Search',
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: const Align(
            alignment: Alignment.topCenter,
            child: SearchOverlay(),
          ),
        );
      },
      transitionBuilder: (context, a1, a2, child) {
        final curved = Curves.easeOut.transform(a1.value);
        return Transform.translate(
          offset: Offset(0, (1 - curved) * 40),
          child: Opacity(opacity: a1.value, child: child),
        );
      },
    );

    if (result != null) {
      // For now, show a compact summary and you can pass `result` to a search usecase
      final checkIn = result['checkIn'] ?? '-';
      final checkOut = result['checkOut'] ?? '-';
      final q = (result['searchQuery'] as List?)?.join(', ') ?? '';
      setState(() {
        _lastQuerySummary = 'From $checkIn → $checkOut • $q';
      });

      // TODO: convert `result` to your domain SearchCriteria and dispatch appropriate Bloc event
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search criteria submitted — $q')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final teal = Colors.teal;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // --- Top header with floating search pill ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // App title + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Discover stays',
                            style: TextStyle(
                                color: teal.shade800,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                            _lastQuerySummary.isEmpty
                                ? 'Best places curated for you'
                                : _lastQuerySummary,
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 13)),
                      ],
                    ),
                  ),

                  // Circular profile icon
                  GestureDetector(
                    onTap: () => _logout(context),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [teal.shade600, teal.shade400]),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: teal.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Floating search pill
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: _openSearch,
                child: ScaleTransition(
                  scale: Tween(begin: 0.95, end: 1.0).animate(CurvedAnimation(
                      parent: _staggerController,
                      curve: const Interval(0.0, 0.3, curve: Curves.easeOut))),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.94),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 6))
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        // round G icon-like search placeholder element
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: teal.shade700,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.search, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search city, hotel or place (tap to search)',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: _openSearch,
                          icon: Icon(Icons.tune, color: teal.shade700),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --- content area ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoading) {
                      // shimmer-like placeholders using animated containers
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: 6,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final delay = index * 80;
                          return FadeTransition(
                            opacity: Tween(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: _staggerController,
                                    curve: Interval(0.1 + index * 0.03, 0.7,
                                        curve: Curves.easeOut))),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              height: 220,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 12)
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is DashboardLoaded) {
                      final hotels = state.hotels;
                      return RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<DashboardBloc>()
                              .add(LoadHotelsEvent(widget.visitorToken));
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 20),
                          itemCount: hotels.length,
                          itemBuilder: (context, index) {
                            final hotel = hotels[index];
                            final entrance = Tween(begin: 0.95, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: _staggerController,
                                    curve: Interval(0.1 + index * 0.03, 0.6,
                                        curve: Curves.easeOut)));

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: ScaleTransition(
                                scale: entrance,
                                child: HotelCard(
                                  hotel: hotel,
                                  onTap: () {
                                    // hero transition handled inside HotelCard
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 600),
                                        reverseTransitionDuration:
                                            const Duration(milliseconds: 450),
                                        pageBuilder: (context, a1, a2) =>
                                            FadeTransition(
                                                opacity: a1,
                                                child: /* detail page */
                                                    Scaffold(
                                                  appBar: AppBar(
                                                      backgroundColor: teal,
                                                      title: Text(
                                                          hotel.propertyName)),
                                                  body: Center(
                                                      child: Text(
                                                          'Detail screen placeholder for ${hotel.propertyName}')),
                                                )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is DashboardSearchListLoaded) {
                      final hotels = state.hotels;
                      return RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<DashboardBloc>()
                              .add(LoadHotelsEvent(widget.visitorToken));
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 20),
                          itemCount: hotels.length,
                          itemBuilder: (context, index) {
                            final hotel = hotels[index];
                            final entrance = Tween(begin: 0.95, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: _staggerController,
                                    curve: Interval(0.1 + index * 0.03, 0.6,
                                        curve: Curves.easeOut)));

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: ScaleTransition(
                                scale: entrance,
                                child: HotelSearchCard(
                                  hotel: hotel,
                                  onTap: () {
                                    // hero transition handled inside HotelCard
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 600),
                                        reverseTransitionDuration:
                                            const Duration(milliseconds: 450),
                                        pageBuilder: (context, a1, a2) =>
                                            FadeTransition(
                                                opacity: a1,
                                                child: /* detail page */
                                                    Scaffold(
                                                  appBar: AppBar(
                                                      backgroundColor: teal,
                                                      title: Text(
                                                          hotel.propertyName)),
                                                  body: Center(
                                                      child: Text(
                                                          'Detail screen placeholder for ${hotel.propertyName}')),
                                                )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is DashboardError) {
                      return Center(
                          child: Text(state.message,
                              style: const TextStyle(color: Colors.red)));
                    } else if (state is DashboardSearchListError) {
                      return Center(
                          child: Text(state.message,
                              style: const TextStyle(color: Colors.red)));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
