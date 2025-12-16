import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/home/data/datasource/remote_datasource/dashboard_remote_datasource.dart';
import 'product_tour_state.dart';

/// Service class for managing product tour utilities.
/// 
/// Previously used SharedPreferences for persistence, now uses API:
/// - GET /api/finance-guru/v1/dashboard returns `onboarded` field
/// - PATCH /api/finance-guru/v1/dashboard/onboarded to mark as onboarded
class ProductTourService {
  final DashboardRemoteDataSource _dashboardDataSource;
  
  // Local state for current tour step (not persisted)
  TourStep? _currentStep;
  
  ProductTourService({required DashboardRemoteDataSource dashboardDataSource})
      : _dashboardDataSource = dashboardDataSource;
  
  /// Check if the tour should be shown based on the user's onboarded status.
  /// This should be called after DashboardSummary is loaded.
  bool shouldShowTour(bool isOnboarded) {
    return !isOnboarded;
  }
  
  /// Get the current tour step (kept in memory only)
  TourStep? getSavedTourStep() {
    return _currentStep;
  }
  
  /// Save the current tour step (in memory only)
  Future<void> saveTourStep(TourStep step) async {
    _currentStep = step;
  }
  
  /// Mark the tour as completed via API
  Future<bool> markTourCompleted() async {
    _currentStep = null;
    return await _dashboardDataSource.updateOnboarded(true);
  }
  
  /// Mark the tour as skipped (also marks as onboarded via API)
  Future<bool> markTourSkipped() async {
    _currentStep = null;
    return await _dashboardDataSource.updateOnboarded(true);
  }
  
  /// Reset tour state (for testing - marks as not onboarded)
  Future<bool> resetTour() async {
    _currentStep = null;
    return await _dashboardDataSource.updateOnboarded(false);
  }
  
  /// Open the default mail app
  /// Returns true if successful, false otherwise
  Future<bool> openMailApp() async {
    try {
      // 1. Android: Try to launch specific mail apps directly (Inbox view)
      if (defaultTargetPlatform == TargetPlatform.android) {
        final List<String> androidIntents = [
          // Gmail - Explicitly launch the main activity
          'intent:#Intent;package=com.google.android.gm;action=android.intent.action.MAIN;category=android.intent.category.LAUNCHER;end',
          // Outlook
          'intent:#Intent;package=com.microsoft.office.outlook;action=android.intent.action.MAIN;category=android.intent.category.LAUNCHER;end',
          // Yahoo
          'intent:#Intent;package=com.yahoo.mobile.client.android.mail;action=android.intent.action.MAIN;category=android.intent.category.LAUNCHER;end',
           // Samsung Email
          'intent:#Intent;package=com.samsung.android.email.provider;action=android.intent.action.MAIN;category=android.intent.category.LAUNCHER;end',
        ];

        for (final intentStr in androidIntents) {
           try {
             final uri = Uri.parse(intentStr);
             // Try to launch directly. valid launch returns true.
             if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
               return true;
             }
           } catch (e) {
             debugPrint('Intent launch failed for $intentStr: $e');
           }
        }
      }

      // 2. iOS/General: Try specific schemes (Gmail, Outlook, Yahoo)
      // These custom schemes on iOS often open the app directly
      final List<String> appSchemes = [
        'googlegmail://', // Gmail
        'ms-outlook://',  // Outlook
        'ymail://',       // Yahoo Mail
      ];

      for (final scheme in appSchemes) {
        final uri = Uri.parse(scheme);
        if (await canLaunchUrl(uri)) {
          if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            return true;
          }
        }
      }

      // 3. Fallback: Try generic mailto: scheme (standard but often opens compose)
      final Uri mailUri = Uri.parse('mailto:');
      
      if (await canLaunchUrl(mailUri)) {
        // Try launching in external application mode first
        final result = await launchUrl(
          mailUri,
          mode: LaunchMode.externalApplication,
        );
        if (result) return true;
        
        // Fallback to default mode
        return await launchUrl(mailUri);
      } else {
         // Force try launching anyway
         try {
           return await launchUrl(mailUri, mode: LaunchMode.externalApplication);
         } catch (e) {
           debugPrint('Force launch failed: $e');
         }
      }
      
      return false;
    } catch (e) {
      debugPrint('Error opening mail app: $e');
      return false;
    }
  }
}
