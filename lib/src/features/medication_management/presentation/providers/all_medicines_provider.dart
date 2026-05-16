import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/medication_repository.dart';
import '../../data/repositories/medication_repository_impl.dart';
import '../../domain/entities/medicine.dart';
import '../../../../core/services/local_db_service.dart';

final Provider<MedicationRepository> medicationRepositoryProvider =
    Provider<MedicationRepository>((Ref ref) {
      return MedicationRepositoryImpl(LocalDbService());
    });

final StreamProvider<List<Medicine>> allMedicinesProvider =
    StreamProvider<List<Medicine>>((Ref ref) {
      if (Firebase.apps.isEmpty) {
        return Stream<List<Medicine>>.value(<Medicine>[]);
      }

      final User? user = FirebaseAuth.instance.currentUser;
      final String userId = user?.uid ?? 'guest_user';

      final MedicationRepository repository = ref.watch(
        medicationRepositoryProvider,
      );
      return repository.streamMedicines(userId);
    });

final Provider<List<Medicine>> lowStockMedicinesProvider =
    Provider<List<Medicine>>((Ref ref) {
      final AsyncValue<List<Medicine>> allMedsAsync = ref.watch(
        allMedicinesProvider,
      );
      return allMedsAsync.when(
        data: (List<Medicine> meds) => meds
            .where((Medicine m) => m.remainingQuantity <= m.lowStockThreshold)
            .toList(),
        loading: () => <Medicine>[],
        error: (Object error, StackTrace stack) => <Medicine>[],
      );
    });
