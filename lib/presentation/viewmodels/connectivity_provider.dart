import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityState extends StateNotifier<bool> {
  ConnectivityState() : super(true);

  void updateConnectionStatus(bool status) {
    state = status;
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityState, bool>((ref) {
  return ConnectivityState();
});
