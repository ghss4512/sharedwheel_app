import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/city_model.dart';
import '../../services/city_service.dart';
import '../../utils/functions.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';

class AddEditCityScreen extends StatefulWidget {
  final CityModel? city;

  const AddEditCityScreen({super.key, this.city});

  @override
  State<AddEditCityScreen> createState() => _AddEditCityScreenState();
}

class _AddEditCityScreenState extends State<AddEditCityScreen> {
  final _formKey = GlobalKey<FormState>();

  final CityService cityService = CityService();

  final cityController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  bool isActive = true;
  bool isSaving = false;

  String selectedProvince = 'Punjab';

  final List<String> provinces = [
    'Punjab',
    'Sindh',
    'Khyber Pakhtunkhwa',
    'Balochistan',
    'Islamabad Capital Territory',
    'Azad Jammu & Kashmir',
    'Gilgit Baltistan',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.city != null) {
      cityController.text = widget.city!.cityName;
      selectedProvince = widget.city!.province;
      latitudeController.text = widget.city!.latitude?.toString() ?? '';
      longitudeController.text = widget.city!.longitude?.toString() ?? '';
      isActive = widget.city!.isActive;
    }
  }

  @override
  void dispose() {
    cityController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  Future<void> saveCity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isSaving = true);

    final result = await cityService.saveCity(
      id: widget.city?.id,
      cityName: cityController.text.trim(),
      province: selectedProvince,
      latitude: latitudeController.text.trim().isEmpty
          ? null
          : double.tryParse(latitudeController.text.trim()),
      longitude: longitudeController.text.trim().isEmpty
          ? null
          : double.tryParse(longitudeController.text.trim()),
      isActive: isActive,
    );

    if (!mounted) return;

    setState(() => isSaving = false);

    if (result['success'] == true) {
      Functions.success(context, result['message']);
      Navigator.pop(context, true);
    } else {
      Functions.error(context, result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,

      appBar: AppBar(
        title: Text(widget.city == null ? 'Add City' : 'Edit City'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: isSaving
          ? const LoadingWidget()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: cityController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'City Name',
                                prefixIcon: Icon(Icons.location_city),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter city name';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            DropdownButtonFormField<String>(
                              value: selectedProvince,
                              decoration: const InputDecoration(
                                labelText: 'Province',
                                prefixIcon: Icon(Icons.map),
                              ),
                              items: provinces
                                  .map(
                                    (province) => DropdownMenuItem(
                                      value: province,
                                      child: Text(province),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedProvince = value!;
                                });
                              },
                            ),

                            const SizedBox(height: 16),

                            TextFormField(
                              controller: latitudeController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Latitude (Optional)',
                                prefixIcon: Icon(Icons.my_location),
                              ),
                            ),

                            const SizedBox(height: 16),

                            TextFormField(
                              controller: longitudeController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Longitude (Optional)',
                                prefixIcon: Icon(Icons.explore),
                              ),
                            ),

                            const SizedBox(height: 20),

                            SwitchListTile(
                              value: isActive,
                              activeColor: AppColors.primary,
                              title: const Text('Active'),
                              subtitle: const Text(
                                'Enable this city for ride booking',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  isActive = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    PrimaryButton(
                      text: widget.city == null ? 'Save City' : 'Update City',
                      onPressed: saveCity,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
