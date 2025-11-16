import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/welcome/presentation/provider/connectsepay/connect_sepay_notifier.dart';

final connectSepayProvider =
    StateNotifierProvider<ConnectSepayNotifier, ConnectSepayState>(
      (ref) => ConnectSepayNotifier(),
    );
