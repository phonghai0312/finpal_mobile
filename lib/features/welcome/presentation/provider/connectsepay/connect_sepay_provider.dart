import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finpal/features/welcome/presentation/provider/connectsepay/connect_sepay_notifier.dart';

final connectSepayProvider =
    StateNotifierProvider<ConnectSepayNotifier, ConnectSepayState>(
      (ref) => ConnectSepayNotifier(),
    );
