class PostMissionInput {
  /// Human-readable address shown in the UI banner.
  final String address;

  final double latitude;
  final double longitude;

  /// Free-text instructions for the scout.
  final String description;

  /// ISO 4217 currency code, e.g. "KES", "USD".
  final String currency;

  final double price;

  /// Requested duration in seconds.
  final int durationInSec;

  PostMissionInput({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.currency,
    required this.price,
    required this.durationInSec,
  });

  Map<String, dynamic> toMap() => {
    'address': address,
    // PostGIS POINT — Supabase accepts WKT for geography columns.
    'location': 'POINT($longitude $latitude)',
    'description': description,
    'currency': currency,
    'price': price,
    'duration_in_sec': durationInSec,
    'status': 'pending',
  };
}
