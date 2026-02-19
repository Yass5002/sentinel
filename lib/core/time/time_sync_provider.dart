import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeSyncNotifier extends StateNotifier<Duration> {
  TimeSyncNotifier() : super(Duration.zero);

  void syncWithServer(DateTime serverTime) {
    final clientTime = DateTime.now();
    final offset = serverTime.difference(clientTime);

    // Only update if the difference is significant (e.g., > 1 minute check logic if needed,
    // but here we just update to stay in sync).
    // We might want to smooth this out, but for now a direct set is fine for this bug.
    state = offset;
  }

  DateTime get now => DateTime.now().add(state);
}

final timeSyncProvider = StateNotifierProvider<TimeSyncNotifier, Duration>((
  ref,
) {
  return TimeSyncNotifier();
});
