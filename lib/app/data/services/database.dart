import 'dart:async';

import 'package:listinhax/app/data/services/objectbox_database.dart';
import 'package:listinhax/app/domain/models/product.dart';
import 'package:pocketbase/pocketbase.dart';

class DatabaseObException implements Exception {
  String message;

  DatabaseObException(this.message);
}

class Database {
  final ObjectBoxDatabase objectBoxDatabase;

  // Single PocketBase instance reused across all operations.
  final PocketBase _pb = PocketBase('http://127.0.0.1:8090');

  Database({required this.objectBoxDatabase});

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  Future<void> createProduct(Product product) async {
    try {
      final body = <String, dynamic>{"name": product.name};
      await _pb.collection('products').create(body: body, files: []);
    } catch (_) {
      throw DatabaseObException('Erro ao Inserir os dados');
    }
  }

  // ---------------------------------------------------------------------------
  // Realtime stream
  // ---------------------------------------------------------------------------

  /// Returns a broadcast [Stream] that emits the full product list whenever
  /// the remote PocketBase collection changes (create / update / delete).
  ///
  /// The caller is responsible for cancelling the subscription (via the
  /// [StreamSubscription] returned by [Stream.listen]) when it is no longer
  /// needed.
  Stream<List<Product>> watchProducts() {
    // Use a broadcast controller so multiple listeners are allowed.
    final controller = StreamController<List<Product>>.broadcast();

    // Keep track of the unsubscribe function provided by the SDK.
    UnsubscribeFunc? unsubscribe;

    controller.onListen = () async {
      // 1. Push the current snapshot immediately so the UI isn't blank.
      try {
        final records = await _pb.collection('products').getFullList();
        if (!controller.isClosed) {
          controller.add(_mapRecords(records));
        }
      } catch (e) {
        if (!controller.isClosed) {
          controller.addError(DatabaseObException('Erro ao carregar os dados'));
        }
      }

      // 2. Subscribe to realtime events.
      try {
        unsubscribe = await _pb.collection('products').subscribe(
          '*',
          (event) async {
            // Re-fetch the full list on every event so we always have a
            // consistent, ordered snapshot (avoids manual merge logic).
            try {
              final records = await _pb.collection('products').getFullList();
              if (!controller.isClosed) {
                controller.add(_mapRecords(records));
              }
            } catch (e) {
              if (!controller.isClosed) {
                controller.addError(
                  DatabaseObException('Erro ao carregar os dados'),
                );
              }
            }
          },
        );
      } catch (e) {
        if (!controller.isClosed) {
          controller.addError(
            DatabaseObException('Erro ao iniciar a subscription'),
          );
        }
      }
    };

    controller.onCancel = () async {
      await unsubscribe?.call();
      await controller.close();
    };

    return controller.stream;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  List<Product> _mapRecords(List<RecordModel> records) =>
      records.map((r) => Product(name: r.data['name'] as String)).toList();
}
