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

class UploadModel {
  final String id;
  final String owner;
  final String userId;
  final String name;
  final String mime;
  final int size;
  final double? duration;
  final String key;
  final String url;
  final String? keyThumb;
  final String? urlThumb;
  final String createdAt;
  final String updatedAt;

  UploadModel({
    required this.id,
    required this.owner,
    required this.userId,
    required this.name,
    required this.mime,
    required this.size,
    required this.duration,
    required this.key,
    required this.url,
    required this.keyThumb,
    required this.urlThumb,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UploadModel.fromJson(Map<String, dynamic> parsedJson) {
    return UploadModel(
      id: parsedJson['id'],
      owner: parsedJson['owner'],
      userId: parsedJson['userId'],
      name: parsedJson['name'],
      mime: parsedJson['mime'],
      size: int.parse(parsedJson['size'].toString()),
      duration: parsedJson['duration'] != null
          ? double.parse(parsedJson['duration'].toString())
          : null,
      key: parsedJson['key'],
      url: parsedJson['url'],
      keyThumb: parsedJson['keyThumb'],
      urlThumb: parsedJson['urlThumb'],
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
  final bool? isUserRevealed;
  final String? userRevealedAt;
  final bool? isMemberRevealed;
  final String? memberRevealedAt;
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
    this.isUserRevealed,
    this.userRevealedAt,
    this.isMemberRevealed,
    this.memberRevealedAt,
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
      isUserRevealed: parsedJson['isUserRevealed'],
      userRevealedAt: parsedJson['userRevealedAt'],
      isMemberRevealed: parsedJson['isMemberRevealed'],
      memberRevealedAt: parsedJson['memberRevealedAt'],
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
    );
  }
}

class MessageEventModel {
  final String id;
  final String owner;
  final String messageId;
  final String userId;
  final String chatId;
  final String chatUserId;
  bool? isBusy;
  final String? type;
  final String? body;
  final String? uploadId;
  final UploadModel? upload;
  final String? recordingId;
  final RecordingModel? recording;
  final String? fileKey;
  final int? fileSize;
  final String? fileMime;
  final String? deliveredAt;
  final String? readAt;
  final bool? isSender;
  final bool? isReceiver;
  final String createdAt;
  final String updatedAt;

  MessageEventModel({
    required this.id,
    required this.owner,
    required this.messageId,
    required this.userId,
    required this.chatId,
    required this.chatUserId,
    this.isBusy,
    this.type,
    this.body,
    this.uploadId,
    this.upload,
    this.recordingId,
    this.recording,
    this.fileKey,
    this.fileSize,
    this.fileMime,
    this.deliveredAt,
    this.readAt,
    this.isSender,
    this.isReceiver,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageEventModel.fromJson(Map<String, dynamic> parsedJson) {
    RecordingModel? recording;
    if (parsedJson['recording']?['id'] != null) {
      recording = RecordingModel.fromJson(parsedJson['recording']);
    }

    UploadModel? upload;
    if (parsedJson['upload']?['id'] != null) {
      upload = UploadModel.fromJson(parsedJson['upload']);
    }

    return MessageEventModel(
      id: parsedJson['id'],
      owner: parsedJson['owner'],
      messageId: parsedJson['messageId'],
      userId: parsedJson['userId'],
      chatId: parsedJson['chatId'],
      chatUserId: parsedJson['chatUserId'],
      type: parsedJson['type'],
      body: parsedJson['body'],
      uploadId: upload?.id,
      upload: upload,
      recordingId: parsedJson['recordingId'],
      recording: recording,
      fileKey: parsedJson['fileKey'],
      fileSize: parsedJson['fileSize'],
      fileMime: parsedJson['fileMime'],
      deliveredAt: parsedJson['deliveredAt'],
      readAt: parsedJson['readAt'],
      isSender: parsedJson['isSender'],
      isReceiver: parsedJson['isReceiver'],
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
    );
  }
}
