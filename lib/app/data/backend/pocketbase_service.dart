import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PocketbaseService {
  PocketbaseService._internal();

  static final PocketbaseService _instance = PocketbaseService._internal();

  factory PocketbaseService() => _instance;

  PocketBase? _pb;

  Future<PocketBase> get instance async {
    if (_pb != null) return _pb!;

    // Vamos fazer a configuração conforme a documentação do pocketBase
    final storage = await SharedPreferences.getInstance();
    final initial = storage.getString('pb_auth');

    // indicamos a Store para salvar as credenciais
    final store = AsyncAuthStore(
      save: (String data) async => storage.setString('pb_auth', data),
      initial: initial,
    );

    // Use 10.0.2.2 para Android emulator, 127.0.0.1 para outras plataformas (local)

    // No dispositivo físico precisa estar na mesma rede
    // e usar o IP do computador

    // Executar ipconfig (windows) ou
    // ifconfig | grep "inet " | grep -v 127.0.0.1
    // final baseUrl = 'http://192.168.0.185:8090';
    final baseUrl = 'http://127.0.0.1:8090';

    _pb = PocketBase(baseUrl, authStore: store);
    return _pb!;
  }
}
