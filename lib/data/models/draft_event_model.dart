class DraftEventModel {
  String? message;
  List<DraftData>? draftData;
  bool? status;

  DraftEventModel({
    this.message,
    this.draftData,
    this.status,
  });

  factory DraftEventModel.fromJson(Map<String, dynamic> json) =>
      DraftEventModel(
        message: json["message"],
        draftData: json["body"] == null
            ? []
            : List<DraftData>.from(
                json["body"]!.map((x) => DraftData.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "body": draftData == null
            ? []
            : List<dynamic>.from(draftData!.map((x) => x.toJson())),
        "status": status,
      };
}

class DraftData {
  String? id;
  double? longitude;
  double? latitude;
  String? attachment;
  String? thumbnail;
  String? postType;
  bool? shareAnonymous;
  String? title;
  String? additionalDetails;
  String? address;
  String? postCategoryId;
  String? mainCategoryId;
  String? subCategoryId;
  String? countryCode;
  String? additionMobileNumber;
  List<String>? hashTags;

  DraftData({
    this.id,
    this.longitude,
    this.latitude,
    this.attachment,
    this.thumbnail,
    this.postType,
    this.shareAnonymous,
    this.title,
    this.additionalDetails,
    this.address,
    this.postCategoryId,
    this.hashTags,
    this.mainCategoryId,
    this.subCategoryId,
    this.additionMobileNumber,
    this.countryCode,
  });

  factory DraftData.fromJson(Map<String, dynamic> json) => DraftData(
        id: json["_id"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        attachment: json["attachment"],
        thumbnail: json["thumbnail"],
        postType: json["postType"],
        shareAnonymous: json["shareAnonymous"],
        title: json["title"],
        additionalDetails: json["additionalDetails"],
        address: json["address"],
        postCategoryId: json["postCategoryId"],
        mainCategoryId: json['mainCategoryId'],
        subCategoryId: json['subCategoryId'],
        additionMobileNumber: json['additionMobileNumber'],
        countryCode: json['countryCode'],
        hashTags: json["hashTags"] == null
            ? []
            : List<String>.from(json["hashTags"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "longitude": longitude,
        "latitude": latitude,
        "attachment": attachment,
        "thumbnail": thumbnail,
        "postType": postType,
        "shareAnonymous": shareAnonymous,
        "title": title,
        "additionalDetails": additionalDetails,
        "address": address,
        "postCategoryId": postCategoryId,
        "hashTags":
            hashTags == null ? [] : List<dynamic>.from(hashTags!.map((x) => x)),
      };
}
