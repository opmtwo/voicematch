class UserProfileModel {
  final String id;
  final String owner;
  final OnlinePresenceModel? onlinePresence;
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
  final RecordingModel? intro;
  final String createdAt;
  final String updatedAt;

  UserProfileModel({
    required this.id,
    required this.owner,
    this.onlinePresence,
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
    this.intro,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> parsedJson) {
    OnlinePresenceModel? onlinePresence;
    if (parsedJson['onlinePresence']?['id'] != null) {
      onlinePresence =
          OnlinePresenceModel.fromJson(parsedJson['onlinePresence']);
    }

    RecordingModel? intro;
    if (parsedJson['intro']?['id'] != null) {
      intro = RecordingModel.fromJson(parsedJson['intro']);
    }

    // safePrint("${parsedJson['locale']}");

    return UserProfileModel(
      id: parsedJson['id'],
      owner: parsedJson['owner'],
      onlinePresence: onlinePresence,
      name: parsedJson['name'],
      givenName: parsedJson['givenName'],
      familyName: parsedJson['familyName'],
      pictureNormal: parsedJson['pictureNormal'],
      pictureMasked: parsedJson['pictureMasked'],
      gender: parsedJson['gender'],
      lookingFor: parsedJson['lookingFor'],
      ageRange: parsedJson['ageRange'],
      distance: parsedJson['distance'],
      locale: List<String>.from(parsedJson['locale']),
      interestCreativity: parsedJson['interestCreativity'],
      interestSports: parsedJson['interestSports'],
      interestVideo: parsedJson['interestVideo'],
      interestMusic: parsedJson['interestMusic'],
      interestTravelling: parsedJson['interestTravelling'],
      interestPet: parsedJson['interestPet'],
      introId: parsedJson['introId'],
      intro: intro,
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
    );
  }
}

class OnlinePresenceModel {
  final String id;
  final String owner;
  final String lastSeenAt;
  final String createdAt;
  final String updatedAt;

  OnlinePresenceModel({
    required this.id,
    required this.owner,
    required this.lastSeenAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OnlinePresenceModel.fromJson(Map<String, dynamic> parsedJson) {
    return OnlinePresenceModel(
      id: parsedJson['id'],
      owner: parsedJson['owner'],
      lastSeenAt: parsedJson['lastSeenAt'],
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
    );
  }
}

class RecordingModel {
  final String id;
  final String owner;
  final String userId;
  final double duration;
  final String key;
  final String url;
  final String createdAt;
  final String updatedAt;

  RecordingModel({
    required this.id,
    required this.owner,
    required this.userId,
    required this.duration,
    required this.key,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecordingModel.fromJson(Map<String, dynamic> parsedJson) {
    return RecordingModel(
      id: parsedJson['id'],
      owner: parsedJson['owner'],
      userId: parsedJson['userId'],
      duration: double.parse(parsedJson['duration'].toString()),
      key: parsedJson['key'],
      url: parsedJson['url'],
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
    );
  }
}

class ConnectionModel {
  final String id;
  final String owner;
  final String chatId;
  final String userId;
  final UserProfileModel? user;
  final String memberId;
  final UserProfileModel member;
  final OnlinePresenceModel? onlinePresence;
  final bool? isSender;
  final bool? isReceiver;
  final bool? isAccepted;
  final bool? isDeclined;
  final bool? isBlocked;
  final bool? isMuted;
  final bool? isPinned;
  final String? acceptedAt;
  final String? declinedAt;
  final String? blockedAt;
  final String? mutedAt;
  final String? pinnedAt;
  final double matchPercentage;
  final String createdAt;
  final String updatedAt;

  ConnectionModel({
    required this.id,
    required this.owner,
    required this.chatId,
    required this.userId,
    required this.memberId,
    required this.member,
    this.user,
    this.onlinePresence,
    this.isSender,
    this.isReceiver,
    this.isAccepted,
    this.isDeclined,
    this.isBlocked,
    this.isMuted,
    this.isPinned,
    this.acceptedAt,
    this.declinedAt,
    this.blockedAt,
    this.mutedAt,
    this.pinnedAt,
    required this.matchPercentage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConnectionModel.fromJson(Map<String, dynamic> parsedJson) {
    OnlinePresenceModel? onlinePresence;
    if (parsedJson['onlinePresence']?['id'] != null) {
      onlinePresence =
          OnlinePresenceModel.fromJson(parsedJson['onlinePresence']);
    }

    UserProfileModel? user;
    if (parsedJson['user']?['id'] != null) {
      user = UserProfileModel.fromJson(parsedJson['user']);
    }

    return ConnectionModel(
      id: parsedJson['id'],
      owner: parsedJson['owner'],
      chatId: parsedJson['chatId'],
      userId: parsedJson['userId'],
      user: user,
      memberId: parsedJson['memberId'],
      member: UserProfileModel.fromJson(parsedJson['member']),
      onlinePresence: onlinePresence,
      isSender: parsedJson['isSender'] == true,
      isReceiver: parsedJson['isReceiver'] == true,
      isAccepted: parsedJson['isAccepted'] == true,
      isDeclined: parsedJson['isDeclined'] == true,
      isBlocked: parsedJson['isBlocked'] == true,
      isMuted: parsedJson['isMuted'] == true,
      isPinned: parsedJson['isPinned'] == true,
      acceptedAt: parsedJson['acceptedAt'],
      declinedAt: parsedJson['declinedAt'],
      blockedAt: parsedJson['blockedAt'],
      mutedAt: parsedJson['mutedAt'],
      pinnedAt: parsedJson['pinnedAt'],
      matchPercentage: double.parse(parsedJson['matchPercentage'].toString()),
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
    );
  }
}


enum MessageTypeEnum {
  text,
  image,
  video,
  audio,
  document,
  link,
  file,
  other,
}
