import 'package:dolfin_core/tour/product_tour_service.dart';
import 'package:dolfin_core/tour/product_tour_state.dart';

/// Simplified tour service for test app (no tour functionality)
class TestProductTourService implements ProductTourService {
  @override
  Future<void> saveTourStep(TourStep step) async {}

  @override
  TourStep? getSavedTourStep() => null;

  @override
  Future<bool> markTourCompleted() async => true;

  @override
  Future<bool> markTourSkipped() async => true;

  @override
  Future<bool> resetTour() async => true;

  @override
  Future<bool> openMailApp() async => true;
}
