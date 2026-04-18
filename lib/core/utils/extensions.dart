import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  /// Returns a human-readable relative time string, e.g. "just now", "3m ago",
  /// "2h ago", "Yesterday", "3d ago", or an absolute date like "Jan 5".
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 365) return DateFormat('MMM d').format(this);
    return DateFormat('MMM d, yyyy').format(this);
  }
}

extension NullableDateTimeExt on DateTime? {
  /// Safe [timeAgo] — returns `''` when null.
  String get timeAgo => this?.timeAgo ?? '';
}

extension StringExt on String? {
  String get inital {
    if (this == null) return '--';

    if (this!.isEmpty) return '--';

    final words = this!.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';

    String initials = '';
    for (final word in words) {
      if (word.isNotEmpty) {
        initials += word[0].toUpperCase();
      }
    }

    return initials;
  }

  bool get isStrongPassword {
    if (this == null) return false;
    if (this!.isEmpty) return false;
    final regExp = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9])\S{8,}$',
    );
    return regExp.hasMatch(this!);
  }
}

extension NumExt on num {
  bool get isApiSuccess {
    return this == 200 || this == 201;
  }

  String get asCurrency {
    final oCcy = NumberFormat("#,##0", "en_US");
    return oCcy.format(this);
  }

  String get formatDistance {
    if (this > 999) {
      return '${(this / 1000).toPrecision(2)}km';
    }
    return '${round()}m';
  }
}
