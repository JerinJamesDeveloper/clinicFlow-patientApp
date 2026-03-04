// /// Network Information Service
// /// 
// /// Provides network connectivity status checking.
// /// Used to determine if the device has an active internet connection.
// library;

// import 'package:connectivity_plus/connectivity_plus.dart';

// /// Abstract interface for network information
// abstract class NetworkInfo {
//   /// Check if device has internet connection
//   Future<bool> get isConnected;
  
//   /// Get current connection type
//   Future<ConnectivityResult> get connectionType;
  
//   /// Stream of connection status changes
//   Stream<ConnectivityResult> get onConnectivityChanged;
// }

// /// Implementation of NetworkInfo using connectivity_plus
// class NetworkInfoImpl implements NetworkInfo {
//   final Connectivity _connectivity;

//   NetworkInfoImpl({Connectivity? connectivity})
//       : _connectivity = connectivity ?? Connectivity();

//   @override
//   Future<bool> get isConnected async {
//     final result = await _connectivity.checkConnectivity();
//     return _isConnected(result);
//   }

//   @override
//   Future<ConnectivityResult> get connectionType async {
//     final results = await _connectivity.checkConnectivity();
//     return results.isNotEmpty ? results.first : ConnectivityResult.none;
//   }

//   @override
//   Stream<ConnectivityResult> get onConnectivityChanged {
//     return _connectivity.onConnectivityChanged.map((results) {
//       return results.isNotEmpty ? results.first : ConnectivityResult.none;
//     });
//   }

//   /// Check if any of the connectivity results indicate a connection
//   bool _isConnected(List<ConnectivityResult> results) {
//     if (results.isEmpty) return false;
    
//     // Check if any result is not "none"
//     return results.any((result) => result != ConnectivityResult.none);
//   }
// }

// /// Extension to add helpful methods to ConnectivityResult
// extension ConnectivityResultExtension on ConnectivityResult {
//   /// Check if connection is WiFi
//   bool get isWifi => this == ConnectivityResult.wifi;

//   /// Check if connection is Mobile Data
//   bool get isMobile => this == ConnectivityResult.mobile;

//   /// Check if connection is Ethernet
//   bool get isEthernet => this == ConnectivityResult.ethernet;

//   /// Check if connection is VPN
//   bool get isVpn => this == ConnectivityResult.vpn;

//   /// Check if connection is Bluetooth
//   bool get isBluetooth => this == ConnectivityResult.bluetooth;

//   /// Check if there is no connection
//   bool get isNone => this == ConnectivityResult.none;

//   /// Check if there is any connection
//   bool get hasConnection => this != ConnectivityResult.none;

//   /// Get human readable name
//   String get displayName {
//     switch (this) {
//       case ConnectivityResult.wifi:
//         return 'WiFi';
//       case ConnectivityResult.mobile:
//         return 'Mobile Data';
//       case ConnectivityResult.ethernet:
//         return 'Ethernet';
//       case ConnectivityResult.vpn:
//         return 'VPN';
//       case ConnectivityResult.bluetooth:
//         return 'Bluetooth';
//       case ConnectivityResult.other:
//         return 'Other';
//       case ConnectivityResult.none:
//         return 'No Connection';
//     }
//   }
// }


/// Network Info Service
/// 
/// Checks network connectivity status.
/// Used to determine if the device has internet access.
library;

import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract interface for network information
abstract class NetworkInfo {
  /// Checks if device is connected to the internet
  Future<bool> get isConnected;

  /// Gets the current connectivity status
  Future<ConnectivityResult> get connectivityResult;

  /// Stream of connectivity changes
  Stream<ConnectivityResult> get onConnectivityChanged;
}

/// Implementation of NetworkInfo using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<ConnectivityResult> get connectivityResult async {
    return await _connectivity.checkConnectivity();
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}