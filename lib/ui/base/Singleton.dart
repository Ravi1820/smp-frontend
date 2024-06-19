

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:go_swift/model/ProfileData.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
  var _parsedJson;
  setPaymentSuccessData(var parsedJson){
    this._parsedJson = parsedJson;
  }
   getPaymentSuccessData(){
    return this._parsedJson;
  }
  // ProfileData? _profileData;
  var _customerUID;
  String? _address;

  // setCustomerProfileData(ProfileData _profileData){
  //   this._profileData = _profileData;
  // }
  // getCustomerProfileData(){
  //   return this._profileData;
  // }
  setCustomerUID(var _customerUID){
    this._customerUID = _customerUID;
  }
  getCustomerUID(){
    return this._customerUID;
  }

  setAddress(var address){
    _address = address;
  }
  getAddress(){
    if(_address != null && _address!.length>0)
    return this._address;
    else return "";
  }

  // FirebaseAuth? _firebaseAuth;
  // setFirebaseAuth(FirebaseAuth _firebaseAuth){
  //   this._firebaseAuth = _firebaseAuth;
  // }
  // getFirebaseAuth(){
  //   return this._firebaseAuth;
  // }
}