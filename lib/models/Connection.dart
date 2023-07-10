/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the Connection type in your schema. */
class Connection extends amplify_core.Model {
  static const classType = const _ConnectionModelType();
  final String id;
  final String? _owner;
  final String? _chatId;
  final String? _userId;
  final String? _memberId;
  final User? _user;
  final User? _member;
  final OnlinePresence? _onlinePresence;
  final bool? _isSender;
  final bool? _isReceiver;
  final bool? _isAccepted;
  final bool? _isDeclined;
  final bool? _isBlocked;
  final bool? _isMuted;
  final bool? _isPinned;
  final amplify_core.TemporalDateTime? _acceptedAt;
  final amplify_core.TemporalDateTime? _declinedAt;
  final amplify_core.TemporalDateTime? _blockedAt;
  final amplify_core.TemporalDateTime? _mutedAt;
  final amplify_core.TemporalDateTime? _pinnedAt;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ConnectionModelIdentifier get modelIdentifier {
      return ConnectionModelIdentifier(
        id: id
      );
  }
  
  String? get owner {
    return _owner;
  }
  
  String? get chatId {
    return _chatId;
  }
  
  String? get userId {
    return _userId;
  }
  
  String? get memberId {
    return _memberId;
  }
  
  User? get user {
    return _user;
  }
  
  User? get member {
    return _member;
  }
  
  OnlinePresence? get onlinePresence {
    return _onlinePresence;
  }
  
  bool? get isSender {
    return _isSender;
  }
  
  bool? get isReceiver {
    return _isReceiver;
  }
  
  bool? get isAccepted {
    return _isAccepted;
  }
  
  bool? get isDeclined {
    return _isDeclined;
  }
  
  bool? get isBlocked {
    return _isBlocked;
  }
  
  bool? get isMuted {
    return _isMuted;
  }
  
  bool? get isPinned {
    return _isPinned;
  }
  
  amplify_core.TemporalDateTime? get acceptedAt {
    return _acceptedAt;
  }
  
  amplify_core.TemporalDateTime? get declinedAt {
    return _declinedAt;
  }
  
  amplify_core.TemporalDateTime? get blockedAt {
    return _blockedAt;
  }
  
  amplify_core.TemporalDateTime? get mutedAt {
    return _mutedAt;
  }
  
  amplify_core.TemporalDateTime? get pinnedAt {
    return _pinnedAt;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Connection._internal({required this.id, owner, chatId, userId, memberId, user, member, onlinePresence, isSender, isReceiver, isAccepted, isDeclined, isBlocked, isMuted, isPinned, acceptedAt, declinedAt, blockedAt, mutedAt, pinnedAt, createdAt, updatedAt}): _owner = owner, _chatId = chatId, _userId = userId, _memberId = memberId, _user = user, _member = member, _onlinePresence = onlinePresence, _isSender = isSender, _isReceiver = isReceiver, _isAccepted = isAccepted, _isDeclined = isDeclined, _isBlocked = isBlocked, _isMuted = isMuted, _isPinned = isPinned, _acceptedAt = acceptedAt, _declinedAt = declinedAt, _blockedAt = blockedAt, _mutedAt = mutedAt, _pinnedAt = pinnedAt, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Connection({String? id, String? owner, String? chatId, String? userId, String? memberId, User? user, User? member, OnlinePresence? onlinePresence, bool? isSender, bool? isReceiver, bool? isAccepted, bool? isDeclined, bool? isBlocked, bool? isMuted, bool? isPinned, amplify_core.TemporalDateTime? acceptedAt, amplify_core.TemporalDateTime? declinedAt, amplify_core.TemporalDateTime? blockedAt, amplify_core.TemporalDateTime? mutedAt, amplify_core.TemporalDateTime? pinnedAt, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return Connection._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      owner: owner,
      chatId: chatId,
      userId: userId,
      memberId: memberId,
      user: user,
      member: member,
      onlinePresence: onlinePresence,
      isSender: isSender,
      isReceiver: isReceiver,
      isAccepted: isAccepted,
      isDeclined: isDeclined,
      isBlocked: isBlocked,
      isMuted: isMuted,
      isPinned: isPinned,
      acceptedAt: acceptedAt,
      declinedAt: declinedAt,
      blockedAt: blockedAt,
      mutedAt: mutedAt,
      pinnedAt: pinnedAt,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Connection &&
      id == other.id &&
      _owner == other._owner &&
      _chatId == other._chatId &&
      _userId == other._userId &&
      _memberId == other._memberId &&
      _user == other._user &&
      _member == other._member &&
      _onlinePresence == other._onlinePresence &&
      _isSender == other._isSender &&
      _isReceiver == other._isReceiver &&
      _isAccepted == other._isAccepted &&
      _isDeclined == other._isDeclined &&
      _isBlocked == other._isBlocked &&
      _isMuted == other._isMuted &&
      _isPinned == other._isPinned &&
      _acceptedAt == other._acceptedAt &&
      _declinedAt == other._declinedAt &&
      _blockedAt == other._blockedAt &&
      _mutedAt == other._mutedAt &&
      _pinnedAt == other._pinnedAt &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Connection {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("owner=" + "$_owner" + ", ");
    buffer.write("chatId=" + "$_chatId" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("memberId=" + "$_memberId" + ", ");
    buffer.write("isSender=" + (_isSender != null ? _isSender!.toString() : "null") + ", ");
    buffer.write("isReceiver=" + (_isReceiver != null ? _isReceiver!.toString() : "null") + ", ");
    buffer.write("isAccepted=" + (_isAccepted != null ? _isAccepted!.toString() : "null") + ", ");
    buffer.write("isDeclined=" + (_isDeclined != null ? _isDeclined!.toString() : "null") + ", ");
    buffer.write("isBlocked=" + (_isBlocked != null ? _isBlocked!.toString() : "null") + ", ");
    buffer.write("isMuted=" + (_isMuted != null ? _isMuted!.toString() : "null") + ", ");
    buffer.write("isPinned=" + (_isPinned != null ? _isPinned!.toString() : "null") + ", ");
    buffer.write("acceptedAt=" + (_acceptedAt != null ? _acceptedAt!.format() : "null") + ", ");
    buffer.write("declinedAt=" + (_declinedAt != null ? _declinedAt!.format() : "null") + ", ");
    buffer.write("blockedAt=" + (_blockedAt != null ? _blockedAt!.format() : "null") + ", ");
    buffer.write("mutedAt=" + (_mutedAt != null ? _mutedAt!.format() : "null") + ", ");
    buffer.write("pinnedAt=" + (_pinnedAt != null ? _pinnedAt!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Connection copyWith({String? owner, String? chatId, String? userId, String? memberId, User? user, User? member, OnlinePresence? onlinePresence, bool? isSender, bool? isReceiver, bool? isAccepted, bool? isDeclined, bool? isBlocked, bool? isMuted, bool? isPinned, amplify_core.TemporalDateTime? acceptedAt, amplify_core.TemporalDateTime? declinedAt, amplify_core.TemporalDateTime? blockedAt, amplify_core.TemporalDateTime? mutedAt, amplify_core.TemporalDateTime? pinnedAt, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return Connection._internal(
      id: id,
      owner: owner ?? this.owner,
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      memberId: memberId ?? this.memberId,
      user: user ?? this.user,
      member: member ?? this.member,
      onlinePresence: onlinePresence ?? this.onlinePresence,
      isSender: isSender ?? this.isSender,
      isReceiver: isReceiver ?? this.isReceiver,
      isAccepted: isAccepted ?? this.isAccepted,
      isDeclined: isDeclined ?? this.isDeclined,
      isBlocked: isBlocked ?? this.isBlocked,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      declinedAt: declinedAt ?? this.declinedAt,
      blockedAt: blockedAt ?? this.blockedAt,
      mutedAt: mutedAt ?? this.mutedAt,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  Connection copyWithModelFieldValues({
    ModelFieldValue<String?>? owner,
    ModelFieldValue<String?>? chatId,
    ModelFieldValue<String?>? userId,
    ModelFieldValue<String?>? memberId,
    ModelFieldValue<User?>? user,
    ModelFieldValue<User?>? member,
    ModelFieldValue<OnlinePresence?>? onlinePresence,
    ModelFieldValue<bool?>? isSender,
    ModelFieldValue<bool?>? isReceiver,
    ModelFieldValue<bool?>? isAccepted,
    ModelFieldValue<bool?>? isDeclined,
    ModelFieldValue<bool?>? isBlocked,
    ModelFieldValue<bool?>? isMuted,
    ModelFieldValue<bool?>? isPinned,
    ModelFieldValue<amplify_core.TemporalDateTime?>? acceptedAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? declinedAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? blockedAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? mutedAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? pinnedAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return Connection._internal(
      id: id,
      owner: owner == null ? this.owner : owner.value,
      chatId: chatId == null ? this.chatId : chatId.value,
      userId: userId == null ? this.userId : userId.value,
      memberId: memberId == null ? this.memberId : memberId.value,
      user: user == null ? this.user : user.value,
      member: member == null ? this.member : member.value,
      onlinePresence: onlinePresence == null ? this.onlinePresence : onlinePresence.value,
      isSender: isSender == null ? this.isSender : isSender.value,
      isReceiver: isReceiver == null ? this.isReceiver : isReceiver.value,
      isAccepted: isAccepted == null ? this.isAccepted : isAccepted.value,
      isDeclined: isDeclined == null ? this.isDeclined : isDeclined.value,
      isBlocked: isBlocked == null ? this.isBlocked : isBlocked.value,
      isMuted: isMuted == null ? this.isMuted : isMuted.value,
      isPinned: isPinned == null ? this.isPinned : isPinned.value,
      acceptedAt: acceptedAt == null ? this.acceptedAt : acceptedAt.value,
      declinedAt: declinedAt == null ? this.declinedAt : declinedAt.value,
      blockedAt: blockedAt == null ? this.blockedAt : blockedAt.value,
      mutedAt: mutedAt == null ? this.mutedAt : mutedAt.value,
      pinnedAt: pinnedAt == null ? this.pinnedAt : pinnedAt.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  Connection.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _owner = json['owner'],
      _chatId = json['chatId'],
      _userId = json['userId'],
      _memberId = json['memberId'],
      _user = json['user']?['serializedData'] != null
        ? User.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
        : null,
      _member = json['member']?['serializedData'] != null
        ? User.fromJson(new Map<String, dynamic>.from(json['member']['serializedData']))
        : null,
      _onlinePresence = json['onlinePresence']?['serializedData'] != null
        ? OnlinePresence.fromJson(new Map<String, dynamic>.from(json['onlinePresence']['serializedData']))
        : null,
      _isSender = json['isSender'],
      _isReceiver = json['isReceiver'],
      _isAccepted = json['isAccepted'],
      _isDeclined = json['isDeclined'],
      _isBlocked = json['isBlocked'],
      _isMuted = json['isMuted'],
      _isPinned = json['isPinned'],
      _acceptedAt = json['acceptedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['acceptedAt']) : null,
      _declinedAt = json['declinedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['declinedAt']) : null,
      _blockedAt = json['blockedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['blockedAt']) : null,
      _mutedAt = json['mutedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['mutedAt']) : null,
      _pinnedAt = json['pinnedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['pinnedAt']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'owner': _owner, 'chatId': _chatId, 'userId': _userId, 'memberId': _memberId, 'user': _user?.toJson(), 'member': _member?.toJson(), 'onlinePresence': _onlinePresence?.toJson(), 'isSender': _isSender, 'isReceiver': _isReceiver, 'isAccepted': _isAccepted, 'isDeclined': _isDeclined, 'isBlocked': _isBlocked, 'isMuted': _isMuted, 'isPinned': _isPinned, 'acceptedAt': _acceptedAt?.format(), 'declinedAt': _declinedAt?.format(), 'blockedAt': _blockedAt?.format(), 'mutedAt': _mutedAt?.format(), 'pinnedAt': _pinnedAt?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'owner': _owner,
    'chatId': _chatId,
    'userId': _userId,
    'memberId': _memberId,
    'user': _user,
    'member': _member,
    'onlinePresence': _onlinePresence,
    'isSender': _isSender,
    'isReceiver': _isReceiver,
    'isAccepted': _isAccepted,
    'isDeclined': _isDeclined,
    'isBlocked': _isBlocked,
    'isMuted': _isMuted,
    'isPinned': _isPinned,
    'acceptedAt': _acceptedAt,
    'declinedAt': _declinedAt,
    'blockedAt': _blockedAt,
    'mutedAt': _mutedAt,
    'pinnedAt': _pinnedAt,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ConnectionModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ConnectionModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final OWNER = amplify_core.QueryField(fieldName: "owner");
  static final CHATID = amplify_core.QueryField(fieldName: "chatId");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final MEMBERID = amplify_core.QueryField(fieldName: "memberId");
  static final USER = amplify_core.QueryField(
    fieldName: "user",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final MEMBER = amplify_core.QueryField(
    fieldName: "member",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'User'));
  static final ONLINEPRESENCE = amplify_core.QueryField(
    fieldName: "onlinePresence",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'OnlinePresence'));
  static final ISSENDER = amplify_core.QueryField(fieldName: "isSender");
  static final ISRECEIVER = amplify_core.QueryField(fieldName: "isReceiver");
  static final ISACCEPTED = amplify_core.QueryField(fieldName: "isAccepted");
  static final ISDECLINED = amplify_core.QueryField(fieldName: "isDeclined");
  static final ISBLOCKED = amplify_core.QueryField(fieldName: "isBlocked");
  static final ISMUTED = amplify_core.QueryField(fieldName: "isMuted");
  static final ISPINNED = amplify_core.QueryField(fieldName: "isPinned");
  static final ACCEPTEDAT = amplify_core.QueryField(fieldName: "acceptedAt");
  static final DECLINEDAT = amplify_core.QueryField(fieldName: "declinedAt");
  static final BLOCKEDAT = amplify_core.QueryField(fieldName: "blockedAt");
  static final MUTEDAT = amplify_core.QueryField(fieldName: "mutedAt");
  static final PINNEDAT = amplify_core.QueryField(fieldName: "pinnedAt");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Connection";
    modelSchemaDefinition.pluralName = "Connections";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["chatId", "createdAt"], name: "listConnectionByChatId"),
      amplify_core.ModelIndex(fields: const ["userId", "createdAt"], name: "listConnectionByUserId"),
      amplify_core.ModelIndex(fields: const ["memberId", "createdAt"], name: "listConnectionByMemberId")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.OWNER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.CHATID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.USERID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.MEMBERID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: Connection.USER,
      isRequired: false,
      ofModelName: 'User',
      associatedKey: User.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: Connection.MEMBER,
      isRequired: false,
      ofModelName: 'User',
      associatedKey: User.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: Connection.ONLINEPRESENCE,
      isRequired: false,
      ofModelName: 'OnlinePresence',
      associatedKey: OnlinePresence.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.ISSENDER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.ISRECEIVER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.ISACCEPTED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.ISDECLINED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.ISBLOCKED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.ISMUTED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.ISPINNED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.ACCEPTEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.DECLINEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.BLOCKEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.MUTEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.PINNEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Connection.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ConnectionModelType extends amplify_core.ModelType<Connection> {
  const _ConnectionModelType();
  
  @override
  Connection fromJson(Map<String, dynamic> jsonData) {
    return Connection.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Connection';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Connection] in your schema.
 */
class ConnectionModelIdentifier implements amplify_core.ModelIdentifier<Connection> {
  final String id;

  /** Create an instance of ConnectionModelIdentifier using [id] the primary key. */
  const ConnectionModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'ConnectionModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ConnectionModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}