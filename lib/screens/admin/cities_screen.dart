import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/provinces.dart';
import '../../models/city_model.dart';
import '../../services/city_service.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';
import 'add_edit_city_screen.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  String selectedProvince = Provinces.all;

  final CityService cityService = CityService();

  final TextEditingController searchController = TextEditingController();

  List<CityModel> cities = [];
  List<CityModel> filteredCities = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCities();

    searchController.addListener(filterCities);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadCities() async {
    setState(() => isLoading = true);

    cities = await cityService.getCities();
    filteredCities = List.from(cities);

    if (!mounted) return;

    setState(() => isLoading = false);
  }

  void filterCities() {
    final keyword = searchController.text.trim().toLowerCase();

    setState(() {
      filteredCities = cities.where((city) {
        final matchesSearch =
            city.cityName.toLowerCase().contains(keyword) ||
            city.province.toLowerCase().contains(keyword);

        final matchesProvince =
            selectedProvince == Provinces.all  ||
            city.province == selectedProvince;

        return matchesSearch && matchesProvince;
      }).toList();
    });
  }

  Future<void> openCity({CityModel? city}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditCityScreen(city: city)),
    );

    if (result == true) {
      loadCities();
    }
  }

  Future<void> deleteCity(CityModel city) async {
    final confirm = await Functions.confirm(
      context,
      'Delete ${city.cityName}?',
    );

    if (confirm != true) return;

    final result = await cityService.deleteCity(id: city.id);

    if (!mounted) return;

    if (result['success'] == true) {
      Functions.success(context, result['message']);
      loadCities();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Future<void> toggleStatus(CityModel city) async {
    final result = await cityService.toggleCityStatus(id: city.id);

    if (!mounted) return;

    if (result['success'] == true) {
      loadCities();
    } else {
      Functions.error(context, result['message']);
    }
  }

  Widget cityCard(CityModel city) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => openCity(city: city),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withAlpha(20),
                    child: const Icon(
                      Icons.location_city,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.cityName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          city.province,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: city.isActive
                          ? Colors.green.withAlpha(30)
                          : Colors.red.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      city.isActive ? 'ACTIVE' : 'INACTIVE',
                      style: TextStyle(
                        color: city.isActive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(height: 20),

              Row(
                children: [
                  const Icon(Icons.my_location, size: 18, color: Colors.blue),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          city.latitude.toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          city.longitude.toString(),
                          style: const TextStyle(fontSize: 15),
                        ),

                        Row(
                          children: [
                            IconButton(
                              onPressed: () => openCity(city: city),
                              icon: Icon(Icons.edit, color: Colors.green,),
                            ),

                            IconButton(
                              onPressed: () => deleteCity(city),
                              icon: Icon(Icons.delete, color: Colors.red,),
                            ),
                          ],
                        ),

                      ],
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

  Widget buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search City',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            initialValue: selectedProvince,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: Provinces.list
                .map(
                  (province) =>
                      DropdownMenuItem(value: province, child: Text(province)),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                selectedProvince = value;
              });
              filterCities();
            },
          ),
        ],
      ),
    );
  }

  Widget buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_city, size: 70, color: Colors.grey),

          SizedBox(height: 10),

          Text(
            'No cities found',
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
        title: const Text('Cities'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => openCity(),
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const LoadingWidget()
          : RefreshIndicator(
              onRefresh: loadCities,
              child: Column(
                children: [
                  buildSearchBox(),

                  Expanded(
                    child: filteredCities.isEmpty
                        ? buildEmpty()
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: filteredCities.length,
                            itemBuilder: (_, index) =>
                                cityCard(filteredCities[index]),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
