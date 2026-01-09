import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'send_request_notifier.dart';

final sendRequestNotifierProvider =
    StateNotifierProvider<SendRequestNotifier, SendRequestState>(
      (ref) => SendRequestNotifier(),
    );
