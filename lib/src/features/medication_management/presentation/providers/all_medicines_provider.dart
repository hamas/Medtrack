import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/medication_repository.dart';
import '../../data/repositories/medication_repository_impl.dart';
import '../../domain/entities/medicine.dart';
import '../../../../services/local_db_service.dart';

final Provider<MedicationRepository> medicationRepositoryProvider =
    Provider<MedicationRepository>((Ref ref) {
      return MedicationRepositoryImpl(LocalDbService());
    });

final StreamProvider<List<Medicine>> allMedicinesProvider =
    StreamProvider<List<Medicine>>((Ref ref) {
      // For now using the hardcoded user ID as seen in add_medicine_screen
      // or logic from existing code.
      const String userId = 'hamas_lead_dev';

      final MedicationRepository repository = ref.watch(
        medicationRepositoryProvider,
      );
      return repository.streamMedicines(userId);
    });
