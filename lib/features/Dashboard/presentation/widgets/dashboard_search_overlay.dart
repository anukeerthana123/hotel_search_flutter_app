import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mytravaly/features/Dashboard/data/models/dashboard_search_query_model.dart';
import 'package:mytravaly/features/Dashboard/presentation/bloc/dasboard_hotel_list.event.dart';
import 'package:mytravaly/features/Dashboard/presentation/bloc/dasboard_hotel_list_bloc.dart';

class SearchOverlay extends StatefulWidget {
  const SearchOverlay({super.key});

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  DateTime? checkIn;
  DateTime? checkOut;
  int rooms = 1;
  int adults = 2;
  int children = 0;
  String searchType = 'hotelIdSearch';
  final List<String> accommodation = ['all', 'hotel'];
  RangeValues priceRange = const RangeValues(500, 5000); // <-- made mutable
  int limit = 5;

  // Controllers
  final TextEditingController hotelIdController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final initialStart = checkIn ?? now;
    final initialEnd = checkOut ?? now.add(const Duration(days: 1));
    final res = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
    );
    if (res != null) {
      setState(() {
        checkIn = res.start;
        checkOut = res.end;
      });
    }
  }

  String _fmt(DateTime? d) =>
      d == null ? 'Select' : DateFormat('yyyy-MM-dd').format(d);

  void _toggleAccommodation(String acc) {
    setState(() {
      if (accommodation.contains(acc)) {
        accommodation.remove(acc);
      } else {
        accommodation.add(acc);
      }
      if (accommodation.isEmpty) accommodation.add('all');
    });
  }

  void _submit() {
    final searchCriteria = SearchCriteria(
        checkIn:
            checkIn != null ? DateFormat('yyyy-MM-dd').format(checkIn!) : null,
        checkOut: checkOut != null
            ? DateFormat('yyyy-MM-dd').format(checkOut!)
            : null,
        rooms: rooms,
        adults: adults,
        children: children,
        searchType: searchType,
        searchQuery: searchType == 'hotelIdSearch'
            ? [hotelIdController.text]
            : [
                streetController.text,
                cityController.text,
                stateController.text,
                countryController.text
              ].where((e) => e.isNotEmpty).toList(),
        accommodation: accommodation,
        arrayOfExcludedSearchType: ["street"],
        highPrice: (priceRange.end).toInt().toString(),
        lowPrice: (priceRange.start).toInt().toString(),
        limit: limit,
        preloaderList: [],
        currency: "INR",
        rid: 0);

    // final searchCriteria = SearchCriteria(
    //     checkIn: "2026-07-11",
    //     checkOut: "2026-07-12",
    //     rooms: 2,
    //     adults: 2,
    //     children: 0,
    //     searchType: "hotelIdSearch",
    //     searchQuery: ["qyhZqzVt"],
    //     accommodation: [
    //       "all",
    //       "hotel" //allowed "hotel","resort","Boat House","bedAndBreakfast","guestHouse","Holidayhome","cottage","apartment","Home Stay", "hostel","Guest House","Camp_sites/tent","co_living","Villa","Motel","Capsule Hotel","Dome Hotel","all"
    //     ],
    //     arrayOfExcludedSearchType: [
    //       "street" //allowed street, city, state, country
    //     ],
    //     highPrice: "3000000",
    //     lowPrice: "0",
    //     limit: 5,
    //     preloaderList: [],
    //     currency: "INR",
    //     rid: 0);

    final model = HotelSearchRequestModel(
      action: 'getSearchResultListOfHotels',
      getSearchResultListOfHotels:
          GetSearchResultListOfHotels(searchCriteria: searchCriteria),
    );

    Navigator.of(context).pop();
    context.read<DashboardBloc>().add(SearchHotels(model));
  }

  @override
  Widget build(BuildContext context) {
    final teal = Colors.teal;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Material(
          color: Colors.white.withOpacity(0.02),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 720),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Search Stays',
                            style: TextStyle(
                                color: teal,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: _pickDateRange,
                          child:
                              Text('Pick Dates', style: TextStyle(color: teal)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Dates
                    Row(
                      children: [
                        Expanded(
                            child: _buildField('Check-in', _fmt(checkIn),
                                onTap: _pickDateRange)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildField('Check-out', _fmt(checkOut),
                                onTap: _pickDateRange)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Rooms on first line
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildNumberBox(
                              'Rooms', rooms, (v) => setState(() => rooms = v)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Adults + Children
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildNumberBox('Adults', adults,
                            (v) => setState(() => adults = v)),
                        const SizedBox(width: 12),
                        _buildNumberBox('Children', children,
                            (v) => setState(() => children = v)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Search type + query
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: searchType,
                            items: const [
                              DropdownMenuItem(
                                  value: 'hotelIdSearch',
                                  child: Text('Hotel ID')),
                              DropdownMenuItem(
                                  value: 'streetSearch', child: Text('Street')),
                              DropdownMenuItem(
                                  value: 'citySearch', child: Text('City')),
                              DropdownMenuItem(
                                  value: 'stateSearch', child: Text('State')),
                              DropdownMenuItem(
                                  value: 'countrySearch',
                                  child: Text('Country')),
                            ],
                            onChanged: (v) {
                              setState(() {
                                searchType = v ?? searchType;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.04),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSearchFields()),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Accommodation
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Accommodation',
                          style: TextStyle(
                              color: teal.shade700,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _accomChip('all'),
                        _accomChip('hotel'),
                        _accomChip('resort'),
                        _accomChip('Home Stay'),
                        _accomChip('camp'),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Price Range
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Price Range (INR)',
                            style: TextStyle(color: teal.shade700))),
                    RangeSlider(
                      values: priceRange,
                      min: 0,
                      max: 3000000,
                      divisions: 100,
                      labels: RangeLabels(
                        '${priceRange.start.toInt()}',
                        '${priceRange.end.toInt()}',
                      ),
                      onChanged: (v) {
                        setState(() => priceRange = v);
                      },
                      activeColor: teal,
                      inactiveColor: Colors.teal.shade100,
                    ),

                    const SizedBox(height: 12),

                    // Limit + Currency
                    Row(
                      children: [
                        Expanded(
                            child:
                                _buildField('Limit', '$limit', onTap: () async {
                          final v = await _pickLimit();
                          if (v != null) setState(() => limit = v);
                        })),
                        const SizedBox(width: 12),
                        Expanded(child: _buildField('Currency', 'INR')),
                      ],
                    ),

                    const SizedBox(height: 18),

                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: const Text(
                        'Search',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFields() {
    if (searchType == 'hotelIdSearch') {
      return TextFormField(
        controller: hotelIdController,
        decoration: InputDecoration(
          hintText: 'Enter Hotel ID...',
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          _buildSmallTextField(streetController, 'Enter Street...'),
          const SizedBox(height: 8),
          _buildSmallTextField(cityController, 'Enter City...'),
          const SizedBox(height: 8),
          _buildSmallTextField(stateController, 'Enter State...'),
          const SizedBox(height: 8),
          _buildSmallTextField(countryController, 'Enter Country...'),
        ],
      );
    }
  }

  Widget _buildSmallTextField(TextEditingController c, String hint) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildField(String label, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
            color: Colors.teal, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(
                child:
                    Text(label, style: const TextStyle(color: Colors.white70))),
            Text(value, style: const TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _buildNumberBox(String title, int value, ValueChanged<int> onChanged) {
    return Flexible(
      child: Container(
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Colors.teal.shade300, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$title: $value",
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (value > 0) onChanged(value - 1);
                    },
                    child:
                        const Icon(Icons.remove, size: 15, color: Colors.teal),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => onChanged(value + 1),
                    child: const Icon(Icons.add, size: 15, color: Colors.teal),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accomChip(String label) {
    final selected = accommodation.contains(label);
    return ChoiceChip(
      label: Text(label,
          style: TextStyle(color: selected ? Colors.white : Colors.black87)),
      selectedColor: Colors.teal,
      backgroundColor: Colors.white.withOpacity(0.9),
      selected: selected,
      onSelected: (_) => _toggleAccommodation(label),
    );
  }

  Future<int?> _pickLimit() async {
    int temp = limit;
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set result limit'),
          content: StatefulBuilder(builder: (context, s) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Slider(
                value: temp.toDouble(),
                min: 1,
                max: 10,
                divisions: 49,
                label: '$temp',
                onChanged: (v) => s(() => temp = v.toInt()),
              ),
              Text('Limit: $temp'),
            ]);
          }),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.of(context).pop(temp),
                child: const Text('OK')),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    hotelIdController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    super.dispose();
  }
}
