class UserProfileModel {
  final String id;
  final String owner;
  // final String onlinePresence;
  final String? name;
  final String? givenName;
  final String? familyName;
  final String? pictureNormal;
  final String? pictureMasked;
  final String? gender;
  final String? lookingFor;
  final String? ageRange;
  final String? distance;
  final List<String>? locale;
  final String? interestCreativity;
  final String? interestSports;
  final String? interestVideo;
  final String? interestMusic;
  final String? interestTravelling;
  final String? interestPet;
  final String? introId;
  // final String intro;
  final String createdAt;
  final String updatedAt;

  UserProfileModel({
    required this.id,
    required this.owner,
    // required this.onlinePresence,
    this.name,
    this.givenName,
    this.familyName,
    this.pictureNormal,
    this.pictureMasked,
    this.gender,
    this.lookingFor,
    this.ageRange,
    this.distance,
    this.locale,
    this.interestCreativity,
    this.interestSports,
    this.interestVideo,
    this.interestMusic,
    this.interestTravelling,
    this.interestPet,
    this.introId,
    // required this.intro,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> parsedJson) {
    return UserProfileModel(
      id: parsedJson['id'],
      owner: parsedJson['owner'],
      // onlinePresence: parsedJson['onlinePresence'],
      name: parsedJson['name'],
      givenName: parsedJson['givenName'],
      familyName: parsedJson['familyName'],
      pictureNormal: parsedJson['pictureNormal'],
      pictureMasked: parsedJson['pictureMasked'],
      gender: parsedJson['gender'],
      lookingFor: parsedJson['lookingFor'],
      ageRange: parsedJson['ageRange'],
      distance: parsedJson['distance'],
      locale: parsedJson['locale'],
      interestCreativity: parsedJson['interestCreativity'],
      interestSports: parsedJson['interestSports'],
      interestVideo: parsedJson['interestVideo'],
      interestMusic: parsedJson['interestMusic'],
      interestTravelling: parsedJson['interestTravelling'],
      interestPet: parsedJson['interestPet'],
      introId: parsedJson['introId'],
      // intro: parsedJson['intro'],
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
    );
  }
}
