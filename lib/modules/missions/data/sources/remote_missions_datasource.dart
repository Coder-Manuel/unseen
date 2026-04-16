import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';

abstract class RemoteMissionsDatasource {
  Future<Map<String, dynamic>> postMission(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getNearbyScouts(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getMyMissions();
  Stream<List<Map<String, dynamic>>> watchActiveMissions();
}

class RemoteMissionsDatasourceImpl extends RemoteMissionsDatasource {
  final SupabaseClient client;

  RemoteMissionsDatasourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> postMission(Map<String, dynamic> data) {
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
  Future<List<Map<String, dynamic>>> getMyMissions() {
    return client
        .from('missions')
        .select()
        .order('created_at', ascending: false);
  }

  @override
  Stream<List<Map<String, dynamic>>> watchActiveMissions() {
    final statuses = MissionStatus.values
        .where((s) => s != MissionStatus.completed)
        .map((s) => s.name)
        .toList();

    return client
        .from('missions')
        .stream(primaryKey: ['id'])
        .inFilter('status', statuses);
  }
}
