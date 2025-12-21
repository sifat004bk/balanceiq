import 'product_tour_state.dart';

abstract class ProductTourService {
  Future<void> saveTourStep(TourStep step);
  TourStep? getSavedTourStep();
  Future<bool> markTourCompleted();
  Future<bool> markTourSkipped();
  Future<bool> resetTour();
  Future<bool> openMailApp();
}
