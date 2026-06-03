class UserModel {
  String? id;
  String? email;
  String? name;
  String? username;
  String? mobileNumber;
  String? provider;
  String? role;
  bool? isVerified;
  bool? isNewUser;
  String? country;
  String? state;
  String? city;
  DateTime? dateOfBirth;
  String? fcmToken;
  int? profileRating;
  String? profilePicture;
  int? userRadius;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.mobileNumber,
    this.provider,
    this.username,
    this.role,
    this.isNewUser,
    this.isVerified,
    this.country,
    this.state,
    this.city,
    this.dateOfBirth,
    this.fcmToken,
    this.profileRating,
    this.profilePicture,
    this.userRadius,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        email: json["email"],
        name: json["name"],
        mobileNumber: json["mobileNumber"],
        provider: json["provider"],
        role: json["role"],
        isNewUser: json["isNewUser"],
        username: json["username"],
        isVerified: json["isVerified"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.parse(json["dateOfBirth"]),
        fcmToken: json["fcmToken"],
        profileRating: json["profileRating"],
        userRadius: json["userRadius"],
        profilePicture: json["profilePicture"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "name": name,
        "mobileNumber": mobileNumber,
        "provider": provider,
        "isNewUser": isNewUser,
        "role": role,
        "isVerified": isVerified,
        "country": country,
        "username": username,
        "state": state,
        "city": city,
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "fcmToken": fcmToken,
        "profileRating": profileRating,
        "userRadius": userRadius,
        "profilePicture": profilePicture,
      };
}
