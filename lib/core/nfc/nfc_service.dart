import 'package:nfc_manager/nfc_manager.dart';

/// Service to handle NFC reading for UID registration and verification.
class NfcService {
  /// Reads the UID of an NFC tag. Returns null if unavailable or cancelled.
  Future<String?> readUid() async {
    if (!await NfcManager.instance.isAvailable()) {
      return null;
    }
    String? uid;
    await NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
      onDiscovered: (tag) async {
        try {
          if (tag.data is Map) {
            final data = tag.data as Map;
            uid = data['id']?.toString() ?? data.toString();
          } else {
            uid = tag.data.toString();
          }
        } finally {
          await NfcManager.instance.stopSession();
        }
      },
    );
    return uid;
  }
}