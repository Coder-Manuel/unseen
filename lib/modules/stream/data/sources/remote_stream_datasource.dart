import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RemoteStreamDatasource {
  /// Invokes the `join-stream` edge function with [missionId].
  Future<FunctionResponse> joinStream({required String missionId});
}

class RemoteStreamDatasourceImpl implements RemoteStreamDatasource {
  final SupabaseClient client;

  RemoteStreamDatasourceImpl({required this.client});

  @override
  Future<FunctionResponse> joinStream({required String missionId}) {
    return client.functions.invoke(
      'join-stream',
      body: {'mission_id': missionId},
    );
  }
}
