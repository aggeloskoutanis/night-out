import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions? get platformOptions {
    // Web
    return const FirebaseOptions(
      apiKey: 'AIzaSyCQpD7ejwAaM65K2SfkDR_SZytJcbCup1U',
      projectId: 'night-out-11544',
      messagingSenderId: '690138575353',
      appId: 'com.aggelos.nightout',
    );
  }
}
