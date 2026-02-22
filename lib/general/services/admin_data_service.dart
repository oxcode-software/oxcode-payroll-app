import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchCollection(
    String collection, {
    int limit = 50,
    String? orderBy,
    bool descending = true,
  }) async {
    Query<Map<String, dynamic>> q = _db.collection(collection);
    if (orderBy != null) {
      q = q.orderBy(orderBy, descending: descending);
    }
    q = q.limit(limit);
    final snapshot = await q.get();
    return snapshot.docs;
  }
}
