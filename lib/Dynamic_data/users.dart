import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'dart:math';


class User {
  String id;
  String nom;
  String postNom;
  String prenom;
  GeoPoint positionCentrale;
  double rayon;


  User({
    required this.id,
    required this.nom,
    required this.postNom,
    required this.prenom,
    required this.positionCentrale,
    required this.rayon,

  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return User(
      id: doc.id,
      nom: data['nom'] ?? '',
      postNom: data['postNom'] ?? '',
      prenom: data['prenom'] ?? '',
      positionCentrale: data['positionCentrale'],
      rayon: data['rayon'] ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'postNom': postNom,
      'prenom': prenom,
      'positionCentrale': positionCentrale,
      'rayon': rayon,
    };
  }
}

class Timesheet {
  String id;
  String userId;
  DateTime arrivalTime;
  DateTime? departureTime;

  Timesheet({
    required this.id,
    required this.userId,
    required this.arrivalTime,
    this.departureTime,
  });

  factory Timesheet.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Timesheet(
      id: doc.id,
      userId: data['userId'] ?? '',
      arrivalTime: (data['arrivalTime'] as Timestamp).toDate(),
      departureTime: data['departureTime'] != null
          ? (data['departureTime'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'arrivalTime': arrivalTime,
      'departureTime': departureTime,
    };
  }
}

//services

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(User user) {
    return _db.collection('Users').doc(user.id).set(user.toFirestore());
  }

  Future<User?> getUser(String userId) async {
    var doc = await _db.collection('Users').doc(userId).get();
    return doc.exists ? User.fromFirestore(doc) : null;
  }

  Future<void> addTimesheet(Timesheet timesheet) {
    return _db.collection('Timesheets').add(timesheet.toFirestore());
  }

  Future<void> updateTimesheet(String id, DateTime departureTime) {
    return _db.collection('Timesheets').doc(id).update({
      'departureTime': departureTime,
    });
  }
}




//location

class LocationService {
  final Location _location = Location();

  Future<LocationData?> getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await _location.getLocation();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  bool isWithinRadius(GeoPoint centralPoint, double radius, LocationData currentLocation) {
    double distance = calculateDistance(
      centralPoint.latitude,
      centralPoint.longitude,
      currentLocation.latitude!,
      currentLocation.longitude!,
    );
    return distance <= radius;
  }
}