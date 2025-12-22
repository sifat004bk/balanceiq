import 'package:dolfin_core/constants/core_strings.dart';

class CoreStringsImpl implements CoreStrings {
  const CoreStringsImpl();

  @override
  String get appName => 'Dolfin AI';

  @override
  final CommonStrings common = const CommonStringsImpl();
  @override
  final ErrorStrings errors = const ErrorStringsImpl();
  @override
  final AccessibilityStrings accessibility = const AccessibilityStringsImpl();
  @override
  final SyncStrings sync =
      const SyncStringsImpl(); // End of CoreStrings properties
  @override
  final TransactionsStrings transactions = const TransactionsStringsImpl();
  @override
  final AccountStrings accounts = const AccountStringsImpl();
}

class CommonStringsImpl implements CommonStrings {
  const CommonStringsImpl();

  @override
  String get save => 'Save';
  @override
  String get saveChanges => 'Save Changes';
  @override
  String get cancel => 'Cancel';
  @override
  String get delete => 'Delete';
  @override
  String get edit => 'Edit';
  @override
  String get confirm => 'Confirm';
  @override
  String get close => 'Close';
  @override
  String get done => 'Done';
  @override
  String get next => 'Next';
  @override
  String get back => 'Back';
  @override
  String get skip => 'Skip';
  @override
  String get retry => 'Retry';
  @override
  String get refresh => 'Refresh';
  @override
  String get viewAll => 'View All';
  @override
  String get learnMore => 'Learn More';
  @override
  String get getStarted => 'Get Started';
  @override
  String get gotIt => 'Got It';
  @override
  String get okay => 'Okay';
  @override
  String get understand => 'I Understand';

  @override
  String get loading => 'Loading';
  @override
  String get loadingContent => 'Loading content, please wait';
  @override
  String get success => 'Success';
  @override
  String get error => 'Error';
  @override
  String get warning => 'Warning';
  @override
  String get info => 'Info';
  @override
  String get processing => 'Processing...';
  @override
  String get processingRequest => 'Processing your request';
  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get required => 'Required';
  @override
  String get invalidEmail => 'Invalid email address';
  @override
  String get invalidPassword => 'Invalid password';
  @override
  String get passwordTooShort => 'Password must be at least 8 characters';
  @override
  String get passwordMismatch => 'Passwords do not match';
  @override
  String get fieldRequired => 'This field is required';

  @override
  String get copied => 'Copied to clipboard';
  @override
  String get savedSuccessfully => 'Saved successfully!';
  @override
  String get deletedSuccessfully => 'Deleted successfully!';
  @override
  String get updatedSuccessfully => 'Updated successfully!';
  @override
  String get operationFailed => 'Unable to complete action. Please try again.';

  @override
  String get today => 'Today';
  @override
  String get yesterday => 'Yesterday';
  @override
  String get thisWeek => 'This Week';
  @override
  String get thisMonth => 'This Month';
  @override
  String get thisYear => 'This Year';
  @override
  String get custom => 'Custom';

  @override
  String get currencySymbol => '৳';
  @override
  String get currencyCode => 'BDT';
  @override
  String get currencyName => 'Bangladeshi Taka';
  @override
  String get takaShort => 'Tk';

  @override
  String get noData => 'No data available';
  @override
  String get noDataYet =>
      'No data available yet. Start tracking to see insights!';

  @override
  String get selectTextMode => 'Select text mode';
  @override
  String get comingSoon => 'Coming Soon';
  @override
  String get income => 'Income';
  @override
  String get expense => 'Expense';
}

class ErrorStringsImpl implements ErrorStrings {
  const ErrorStringsImpl();

  @override
  String get networkError => 'Network Error';
  @override
  String get noInternet =>
      'No internet connection. Connect to Wi-Fi or mobile data to continue.';
  @override
  String get serverError =>
      'Server error occurred. Our team has been notified. Please try again later.';
  @override
  String get timeoutError =>
      'Connection took too long. Please check your internet and try again.';
  @override
  String get connectionFailed =>
      'Couldn\'t connect to server. Check your internet connection and try again.';

  @override
  String get invalidInput => 'Invalid input';
  @override
  String get requiredField => 'This field is required';
  @override
  String get invalidEmail => 'Invalid email address';
  @override
  String get invalidAmount => 'Invalid amount';
  @override
  String get amountTooLarge => 'Amount is too large';
  @override
  String get amountTooSmall => 'Amount must be greater than 0';

  @override
  String get authFailed =>
      'Unable to sign in. Please check your email and password.';
  @override
  String get invalidCredentials => 'Invalid email or password';
  @override
  String get emailAlreadyExists => 'This email is already registered';
  @override
  String get weakPassword =>
      'Password is too weak. Use at least 8 characters with uppercase, lowercase, and numbers.';
  @override
  String get accountNotFound =>
      'Account not found. Please check your email or sign up.';
  @override
  String get emailNotVerified =>
      'Email not verified. Please check your inbox for verification link.';

  @override
  String get loadFailed =>
      'Couldn\'t load data. Pull down to refresh or check your connection.';
  @override
  String get saveFailed =>
      'Couldn\'t save changes. Check your internet connection and try again.';
  @override
  String get deleteFailed => 'Couldn\'t delete. Please try again.';
  @override
  String get updateFailed =>
      'Couldn\'t update. Check your connection and try again.';

  @override
  String get storageNearFull =>
      'Storage almost full. Consider archiving old transactions.';
  @override
  String get storageFull =>
      'Storage full. Please delete some data or upgrade your plan.';

  @override
  String get transactionLimitReached =>
      'Free plan limit: 50 transactions per month. Upgrade for unlimited.';
  @override
  String get exportLimitReached =>
      'Export limit reached. Upgrade for unlimited exports.';
  @override
  String get featureNotAvailable =>
      'This feature is not available on your current plan.';

  @override
  String get somethingWentWrong =>
      'We couldn\'t complete that action. Please try again.';
  @override
  String get genericError => 'An error occurred. Please try again.';
  @override
  String get tryAgainLater =>
      'Something went wrong. Please try again in a few moments.';
  @override
  String get contactSupport =>
      'If the problem persists, please contact our support team.';

  @override
  String get retry => 'Retry';
  @override
  String get goBack => 'Go Back';
  @override
  String get goHome => 'Go to Home';
  @override
  String get refresh => 'Refresh';
  @override
  String get cancel => 'Cancel';
}

class AccessibilityStringsImpl implements AccessibilityStrings {
  const AccessibilityStringsImpl();

  @override
  String get sendMessageButton => 'Send message';
  @override
  String get copyToClipboard => 'Copy message to clipboard';
  @override
  String get attachFileButton => 'Attach file or image';
  @override
  String get voiceInputButton => 'Record voice message';
  @override
  String get passwordVisibilityToggle => 'Toggle password visibility';
  @override
  String get showPassword => 'Show password';
  @override
  String get hidePassword => 'Hide password';
  @override
  String get refreshData => 'Pull down to refresh data';
  @override
  String get viewAllTransactions => 'View all transactions';
  @override
  String get retryLoadingData => 'Retry loading data';

  @override
  String get balanceCardDescription =>
      'Your current balance and financial summary';
  @override
  String get spendingChartDescription =>
      'Spending trend chart for selected period';
  @override
  String get categoryChartDescription => 'Spending breakdown by category';
  @override
  String get profileImageLabel => 'Profile picture. Tap to change.';
  @override
  String get botAvatarLabel => 'AI assistant avatar';
  @override
  String get transactionItemDescription =>
      'Transaction item. Tap to view details.';

  @override
  String get loadingContentAnnouncement => 'Loading content, please wait';
  @override
  String get processingRequestAnnouncement => 'Processing your request';
  @override
  String get dataLoadedAnnouncement => 'Data loaded successfully';
  @override
  String get errorOccurredAnnouncement => 'An error occurred';
  @override
  String get transactionAddedAnnouncement => 'Transaction added successfully';
  @override
  String get messagesentAnnouncement => 'Message sent';
}

class SyncStringsImpl implements SyncStrings {
  const SyncStringsImpl();

  @override
  String get syncing => 'Syncing';
  @override
  String get syncingData => 'Syncing your data';
  @override
  String get syncComplete => 'All changes synced successfully';
  @override
  String get syncFailed =>
      'Some changes couldn\'t sync. Will retry automatically when online.';
  @override
  String get lastSynced => 'Last synced';
  @override
  String get neverSynced => 'Not yet synced';
  @override
  String lastSyncedAt(String time) => 'Last synced $time ago';

  @override
  String get offline => 'Offline';
  @override
  String get offlineMode =>
      'You\'re offline. Changes will sync when connected.';
  @override
  String get offlineMessage =>
      'No internet connection. You can continue working, and your changes will sync automatically when you\'re back online.';
  @override
  String get cachedData => 'Showing saved data. Pull down to refresh.';
  @override
  String get workingOffline => 'Working offline';

  @override
  String get syncNow => 'Sync Now';
  @override
  String get syncPending => 'Sync pending';
  @override
  String changesPending(int count) => '$count changes pending sync';
  @override
  String get retrySync => 'Retry Sync';
  @override
  String get syncSettings => 'Sync Settings';
  @override
  String get autoSync => 'Auto-sync';
  @override
  String get autoSyncDescription =>
      'Automatically sync when connected to internet';
  @override
  String get syncOnWifiOnly => 'Sync on Wi-Fi only';

  @override
  String get downloadingData => 'Downloading data';
  @override
  String get downloadComplete => 'Download complete';
  @override
  String get downloadFailed => 'Download failed. Check your connection.';

  @override
  String get exportingData => 'Exporting data';
  @override
  String get exportSuccess => 'Data exported successfully';
  @override
  String get exportFailed => 'Export failed. Please try again.';
  @override
  String get importingData => 'Importing data';
  @override
  String get importSuccess => 'Data imported successfully';
  @override
  String get importFailed => 'Import failed. Check file format.';
  @override
  String get noDataToExport => 'No data available to export';
}

class TransactionsStringsImpl implements TransactionsStrings {
  const TransactionsStringsImpl();

  @override
  String get title => 'Transactions';
  @override
  String get allTransactions => 'All Transactions';
  @override
  String get recentTransactions => 'Recent Transactions';
  @override
  String get filterTransactions => 'Filter';
  @override
  String get sortBy => 'Sort By';
  @override
  String get searchTransactions => 'Search transactions...';
  @override
  String get searchHint => 'Search transactions...';
  @override
  String get dateRange => 'Date Range';
  @override
  String get all => 'All';
  @override
  String get noTransactionsFound =>
      'No transactions found matching your criteria.';

  @override
  String get transactionDetails => 'Transaction Details';
  @override
  String get editTransaction => 'Edit Transaction';
  @override
  String get deleteTransaction => 'Delete Transaction';
  @override
  String get transactionId => 'ID';

  @override
  String get transactionType => 'Transaction Type';
  @override
  String get amount => 'Amount';
  @override
  String get description => 'Description';
  @override
  String get descriptionHint => 'Enter description...';
  @override
  String get category => 'Category';
  @override
  String get date => 'Date';
  @override
  String get selectDate => 'Select Date';

  @override
  String get categoryFood => 'Food & Dining';
  @override
  String get categoryTransport => 'Transportation';
  @override
  String get categoryShopping => 'Shopping';
  @override
  String get categoryEntertainment => 'Entertainment';
  @override
  String get categoryBills => 'Bills & Utilities';
  @override
  String get categoryHealthcare => 'Healthcare';
  @override
  String get categoryEducation => 'Education';
  @override
  String get categorySalary => 'Salary';
  @override
  String get categoryFreelance => 'Freelance Income';
  @override
  String get categoryRemittance => 'Remittance';
  @override
  String get categoryBusiness => 'Business Income';
  @override
  String get categoryInvestment => 'Investment';
  @override
  String get categoryGift => 'Gift';
  @override
  String get categoryMobileRecharge => 'Mobile Recharge';
  @override
  String get categoryInternetBill => 'Internet Bill';
  @override
  String get categoryRent => 'Rent';
  @override
  String get categoryOther => 'Other';

  @override
  String get addTransaction => 'Add Transaction';
  @override
  String get updateTransaction => 'Update';
  @override
  String get deleteConfirmTitle => 'Delete Transaction';
  @override
  String get deleteConfirmMessage =>
      'Are you sure you want to delete this transaction? This action cannot be undone.';
  @override
  String get deleting => 'Deleting transaction';
  @override
  String get noDescription => 'No description';

  @override
  String get largeTransactionTitle => 'Large Amount';
  @override
  String largeTransactionConfirm(String amount) =>
      'This is a large amount ($amount). Please confirm this transaction.';
  @override
  String get duplicateWarning => 'Possible Duplicate';
  @override
  String get duplicateMessage =>
      'This looks similar to a recent transaction. Add anyway?';
  @override
  String get addAnyway => 'Add Anyway';
  @override
  String get futureTransactionWarning => 'Future Date';
  @override
  String get futureTransactionMessage =>
      'This transaction is dated in the future';

  @override
  String get categoryNotSelected => 'Please select a category';
  @override
  String get invalidDate => 'Please select a valid date';
  @override
  String get invalidAmount => 'Please enter a valid amount';

  @override
  String get transactionAdded => 'Transaction added successfully!';
  @override
  String get transactionUpdated => 'Transaction updated successfully!';
  @override
  String get transactionDeleted => 'Transaction deleted successfully!';
  @override
  String expenseRecorded(String amount, String category) =>
      '$amount expense recorded in $category';
  @override
  String incomeAdded(String amount) => '$amount income added to your balance';
}

class AccountStringsImpl implements AccountStrings {
  const AccountStringsImpl();

  @override
  String get accountType => 'Account Type';
  @override
  String get accountTypeCash => 'Cash';
  @override
  String get accountTypeMobileBanking => 'Mobile Banking';
  @override
  String get accountTypeBank => 'Bank Account';
  @override
  String get accountTypeCard => 'Debit/Credit Card';

  @override
  String get mobileBanking => 'Mobile Banking';
  @override
  String get bKash => 'bKash';
  @override
  String get nagad => 'Nagad';
  @override
  String get rocket => 'Rocket';
  @override
  String get upay => 'Upay';
  @override
  String get mobileBankingNumber => 'Mobile Banking Number';
  @override
  String get mobileBankingBalance => 'Mobile Banking Balance';
  @override
  String get mobileMoneyTransfer => 'Mobile Money Transfer';
  @override
  String get cashInOut => 'Cash In/Out';

  @override
  String get cashInHand => 'Cash in Hand';
  @override
  String get bankBalance => 'Bank Balance';
  @override
  String get totalBalance => 'Total Balance';
  @override
  String get addAccount => 'Add Account';
  @override
  String get editAccount => 'Edit Account';
  @override
  String get deleteAccount => 'Delete Account';
  @override
  String get accountName => 'Account Name';
  @override
  String get accountBalance => 'Account Balance';
  @override
  String get setAsDefault => 'Set as Default';
  @override
  String get defaultAccount => 'Default Account';

  @override
  String get paymentMethod => 'Payment Method';
  @override
  String get paymentCash => 'Cash';
  @override
  String get paymentMobileBanking => 'Mobile Banking';
  @override
  String get paymentBankTransfer => 'Bank Transfer';
  @override
  String get paymentCard => 'Debit/Credit Card';
}
