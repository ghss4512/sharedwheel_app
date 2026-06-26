import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../models/city_model.dart';

class SearchableCityDropdown extends StatelessWidget {
  final String label;
  final List<CityModel> cities;
  final CityModel? selectedCity;
  final ValueChanged<CityModel?> onChanged;
  final IconData? icon;
  final bool enabled;

  const SearchableCityDropdown({
    super.key,
    required this.label,
    required this.cities,
    required this.selectedCity,
    required this.onChanged,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<CityModel>(
      enabled: enabled,

      items: (filter, infiniteScrollProps) => cities,

      selectedItem: selectedCity,

      compareFn: (a, b) => a.id == b.id,

      itemAsString: (city) => city.cityName,

      onChanged: onChanged,

      popupProps: PopupProps.menu(
        showSearchBox: true,

        fit: FlexFit.loose,

        searchFieldProps: const TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Search City',
            prefixIcon: Icon(Icons.search),
          ),
        ),

        emptyBuilder: (context, searchEntry) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text('No city found'),
            ),
          );
        },
      ),

      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon ?? Icons.location_city),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}