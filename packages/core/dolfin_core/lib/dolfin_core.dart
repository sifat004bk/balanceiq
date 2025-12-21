/// Dolfin Core - Foundation layer for Dolfin AI apps
///
/// This package provides core utilities, error handling, network clients,
/// and storage services that are shared across all Dolfin applications.
library dolfin_core;

// Error handling
export 'error/app_exception.dart';
export 'error/error_handler.dart';
export 'error/failures.dart';

// Network
export 'network/logging_interceptor.dart';

// Storage
export 'storage/secure_storage_service.dart';

// Utils
export 'utils/app_logger.dart';
export 'utils/input_validator.dart';

// Constants
export 'constants/app_constants.dart';

// Config
export 'config/environment_config.dart';

// Mock
export 'mock/mock_data.dart';
