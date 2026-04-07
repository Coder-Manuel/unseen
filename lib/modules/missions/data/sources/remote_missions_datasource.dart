import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RemoteMissionsDatasource {
  Future<Map<String, dynamic>> postMission(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getNearbyScouts({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });
  Future<List<Map<String, dynamic>>> getMyMissions();
}

class RemoteMissionsDatasourceImpl extends RemoteMissionsDatasource {
  final SupabaseClient client;

  RemoteMissionsDatasourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> postMission(Map<String, dynamic> data) {
    return client
        .from('missions')
        .insert({...data, 'client_id': client.auth.currentUser?.id})
        .select()
        .single();
  }

  @override
  Future<List<Map<String, dynamic>>> getNearbyScouts({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    final result = await client.rpc('get_nearby_scouts', params: {
      'lat': latitude,
      'lng': longitude,
      'radius_km': radiusKm,
    });
    return List<Map<String, dynamic>>.from(result as List);
  }

  @override
  Future<List<Map<String, dynamic>>> getMyMissions() async {
    final result = await client
        .from('missions')
        .select()
        .eq('client_id', client.auth.currentUser?.id ?? '')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(result);
  }
}
