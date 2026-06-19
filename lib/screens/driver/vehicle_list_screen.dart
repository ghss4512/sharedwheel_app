import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/vehicle_model.dart';
import '../../services/vehicle_service.dart';
import '../../utils/functions.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import 'add_vehicle_screen.dart';
import 'edit_vehicle_screen.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => VehicleListScreenState();
}

class VehicleListScreenState extends State<VehicleListScreen> {
  final VehicleService service = VehicleService();

  List<VehicleModel> vehicles = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    try {
      vehicles = await service.getVehicles();
    } catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: const Text('My Vehicles'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddVehicleScreen()),
          );

          if (result == true) {
            await loadVehicles();

            if (mounted) {
              setState(() {});
            }
          }
        },
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: loadVehicles,

        child: isLoading
            ? const LoadingWidget()
            : vehicles.isEmpty
            ? const EmptyStateWidget(message: 'No vehicles added yet')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  return vehicleCard(vehicles[index]);
                },
              ),
      ),
    );
  }

  Widget vehicleCard(VehicleModel vehicle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.directions_car)),

        title: Row(
          children: [
            Expanded(child: Text(vehicle.vehicleName)),

            if (vehicle.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'DEFAULT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vehicle.vehicleNumber),

            Text('${vehicle.vehicleColor} • ${vehicle.seatingCapacity} Seats'),
          ],
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'default':
                setDefaultVehicle(vehicle);
                break;

              case 'edit':
                editVehicle(vehicle);
                break;

              case 'delete':
                deleteVehicle(vehicle);
                break;
            }
          },
          itemBuilder: (context) => [
            if (!vehicle.isDefault)
              const PopupMenuItem(
                value: 'default',
                child: Row(
                  children: [
                    Icon(Icons.star),
                    SizedBox(width: 8),
                    Text('Set Default'),
                  ],
                ),
              ),

            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
              ),
            ),

            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setDefaultVehicle(VehicleModel vehicle) async {
    try {
      final result = await service.setDefaultVehicle(vehicle.id);

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, result['message']);

        loadVehicles();
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      Functions.error(context, e.toString());
    }
  }

  Future<void> editVehicle(VehicleModel vehicle) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditVehicleScreen(vehicle: vehicle)),
    );

    if (result == true) {
      await loadVehicles();
    }
  }

  Future<void> deleteVehicle(VehicleModel vehicle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text(
          'Are you sure you want to delete "${vehicle.vehicleName}" (${vehicle.vehicleNumber})?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    try {
      final result = await service.deleteVehicle(vehicle.id);

      if (!mounted) return;

      if (result['success'] == true) {
        Functions.success(context, result['message']);

        await loadVehicles();
      } else {
        Functions.error(context, result['message']);
      }
    } catch (e) {
      if (!mounted) return;

      Functions.error(context, e.toString());
    }
  }
}
