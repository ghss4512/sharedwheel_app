import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'add_edit_ride_fare_screen.dart';
import '../../models/admin/ride_fare_model.dart';
import '../../services/ride_fare_service.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';

class RideFaresScreen extends StatefulWidget {
  const RideFaresScreen({super.key});

  @override
  State<RideFaresScreen> createState() => _RideFaresScreenState();
}

class _RideFaresScreenState extends State<RideFaresScreen> {
  final RideFareService rideFareService = RideFareService();
  final TextEditingController searchController = TextEditingController();
  List<RideFareModel> rideFares = [];
  List<RideFareModel> filteredRideFares = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRideFares();
    searchController.addListener(filterRideFares);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadRideFares() async {
    setState(() {
      isLoading = true;
    });

    rideFares = await rideFareService.getRideFares();
    filteredRideFares = List.from(rideFares);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  void filterRideFares() {
    final keyword = searchController.text.trim().toLowerCase();

    setState(() {
      filteredRideFares = rideFares.where((fare) {
        return fare.fromCity.toLowerCase().contains(keyword) ||
            fare.toCity.toLowerCase().contains(keyword);
      }).toList();
    });
  }

  Future<void> openRideFare({RideFareModel? rideFare}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditRideFareScreen(rideFare: rideFare),),
    );

    if (result == true) {
      loadRideFares();
    }
  }

  Widget buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(12),

      child: TextField(
        controller: searchController,

        decoration: InputDecoration(
          hintText: 'Search Route',

          prefixIcon: const Icon(Icons.search),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.route, size: 70, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'No Ride Fares Found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('Ride Fare Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => openRideFare(),
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const LoadingWidget()
          : RefreshIndicator(
              onRefresh: loadRideFares,
              child: Column(
                children: [
                  buildSearchBox(),
                  Expanded(
                    child: filteredRideFares.isEmpty
                        ? buildEmpty()
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: filteredRideFares.length,
                            itemBuilder: (_, index) {
                              return rideFareCard(filteredRideFares[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> deleteRideFare(RideFareModel rideFare) async {
    final confirm = await Functions.confirm(
      context,
      'Delete fare from ${rideFare.fromCity} to ${rideFare.toCity}?',
    );

    if (confirm != true) return;

    final result = await rideFareService.deleteRideFare(id: rideFare.id);

    if (!mounted) return;

    if (result['success'] == true) {
      Functions.success(context, result['message']);
      loadRideFares();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Future<void> toggleRideFareStatus(RideFareModel rideFare) async {
    final result = await rideFareService.toggleRideFareStatus(id: rideFare.id);

    if (!mounted) return;

    if (result['success'] == true) {
      loadRideFares();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Widget rideFareCard(RideFareModel rideFare) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => openRideFare(rideFare: rideFare),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              /// Route
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withAlpha(20),
                    child: const Icon(Icons.route, color: AppColors.primary),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${rideFare.fromCity} → ${rideFare.toCity}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          'Fare per Seat: Rs. ${rideFare.farePerSeat.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: rideFare.isActive
                          ? Colors.green.withAlpha(25)
                          : Colors.red.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      rideFare.isActive ? 'ACTIVE' : 'INACTIVE',
                      style: TextStyle(
                        color: rideFare.isActive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Switch(
                    value: rideFare.isActive,
                    activeThumbColor: AppColors.primary,
                    onChanged: (_) => toggleRideFareStatus(rideFare),
                  ),

                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit, color: Colors.blue,),
                      label: const Text('Edit'),
                      onPressed: () => openRideFare(rideFare: rideFare),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red,),
                      label: const Text('Delete'),
                      onPressed: () => deleteRideFare(rideFare),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
