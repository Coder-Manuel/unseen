import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RemoteMissionsDatasource {
  Future<Map<String, dynamic>> postMission(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getNearbyScouts(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getMyMissions();
}

class RemoteMissionsDatasourceImpl extends RemoteMissionsDatasource {
  final SupabaseClient client;

  RemoteMissionsDatasourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> postMission(Map<String, dynamic> data) {
    // client_id is NOT sent — the DB trigger set_mission_client_id() assigns
    // it automatically from auth.uid() and also enforces the client-role guard.
    return client.from('missions').insert(data).select().single();
  }

  @override
  Future<List<Map<String, dynamic>>> getNearbyScouts(
    Map<String, dynamic> data,
  ) async {
    final result = await client.rpc('get_nearby_scouts', params: data);
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
