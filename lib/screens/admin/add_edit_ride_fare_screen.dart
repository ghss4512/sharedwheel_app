import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../models/admin/ride_fare_model.dart';
import '../../../models/city_model.dart';
import '../../../services/city_service.dart';
import '../../../services/ride_fare_service.dart';
import '../../../utils/functions.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/primary_button.dart';
import '../../widgets/searchable_city_dropdown.dart';

class AddEditRideFareScreen extends StatefulWidget {
  final RideFareModel? rideFare;

  const AddEditRideFareScreen({super.key, this.rideFare});

  @override
  State<AddEditRideFareScreen> createState() => _AddEditRideFareScreenState();
}

class _AddEditRideFareScreenState extends State<AddEditRideFareScreen> {
  final RideFareService rideFareService = RideFareService();
  final CityService cityService = CityService();
  final TextEditingController fareController = TextEditingController();
  List<CityModel> cities = [];
  CityModel? selectedFromCity;
  CityModel? selectedToCity;
  bool isActive = true;
  bool isLoading = true;
  bool isSaving = false;

  bool get isEdit => widget.rideFare != null;

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    cities = await cityService.getActiveCities();
    if (isEdit) {
      fareController.text = widget.rideFare!.farePerSeat.toStringAsFixed(0);
      isActive = widget.rideFare!.isActive;
      selectedFromCity = cities.firstWhere(
        (city) => city.id == widget.rideFare!.fromCityId,
        orElse: () => cities.first,
      );
      selectedToCity = cities.firstWhere(
        (city) => city.id == widget.rideFare!.toCityId,
        orElse: () => cities.first,
      );
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Widget buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SearchableCityDropdown(
            label: 'From City',
            icon: Icons.flag,
            cities: cities,
            selectedCity: selectedFromCity,
            onChanged: (city) {
              setState(() {
                selectedFromCity = city;
              });
            },
          ),
          SizedBox(height: 16,),
          SearchableCityDropdown(
            label: 'To City',
            icon: Icons.flag,
            cities: cities,
            selectedCity: selectedToCity,
            onChanged: (city) {
              setState(() {
                selectedToCity = city;
              });
            },
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: fareController,
            label: 'Fare Per Seat',
            keyboardType: TextInputType.number,
            icon: Icons.currency_exchange,
          ),

          const SizedBox(height: 16),

          SwitchListTile(
            value: isActive,
            activeThumbColor: AppColors.primary,
            title: const Text('Active'),
            subtitle: const Text('Passengers can book rides using this fare.'),
            onChanged: (value) {
              setState(() {
                isActive = value;
              });
            },
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: isSaving
                  ? 'Saving...'
                  : isEdit
                  ? 'Update Ride Fare'
                  : 'Save Ride Fare',
              onPressed: isSaving ? null : saveRideFare,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveRideFare() async {
    if (selectedFromCity == null) {
      Functions.error(context, 'Please select From City.');
      return;
    }

    if (selectedToCity == null) {
      Functions.error(context, 'Please select To City.');
      return;
    }

    if (selectedFromCity!.id == selectedToCity!.id) {
      Functions.error(context, 'From City and To City cannot be the same.');
      return;
    }

    if (fareController.text.trim().isEmpty) {
      Functions.error(context, 'Please enter fare per seat.');
      return;
    }

    final fare = double.tryParse(fareController.text.trim());
    if (fare == null || fare <= 0) {
      Functions.error(context, 'Please enter a valid fare.');
      return;
    }
    setState(() {
      isSaving = true;
    });
    // try {

    debugPrint('===== saveRideFare() called =====');

    final result = await rideFareService.saveRideFare(
      id: isEdit ? widget.rideFare!.id : null,
      fromCityId: selectedFromCity!.id,
      toCityId: selectedToCity!.id,
      farePerSeat: fare,
      isActive: isActive,
    );

    debugPrint(result.toString());

    if (!mounted) return;

    // Safely extract the message as a String, fallback to a default if it's null
    final responseMessage = result['message']?.toString() ?? 'Unknown error';

    if (result['success'] == true) {
      Functions.success(context, responseMessage);
      Navigator.pop(context, true);
    } else {
      Functions.error(context, responseMessage);
    }
    // } catch (e) {
    //   if (!mounted) return;
    //
    //   Functions.error(context, 'Unable to save ride fare. Error: $e');
    // }

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });
  }

  @override
  void dispose() {
    fareController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Ride Fare' : 'Add Ride Fare'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading ? const LoadingWidget() : buildBody(),
    );
  }
}
