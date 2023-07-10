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
import 'package:collection/collection.dart';


/** This is an auto generated class representing the User type in your schema. */
class User extends amplify_core.Model {
  static const classType = const _UserModelType();
  final String id;
  final String? _owner;
  final OnlinePresence? _onlinePresence;
  final String? _name;
  final String? _givenName;
  final String? _familyName;
  final String? _pictureNormal;
  final String? _pictureMasked;
  final String? _gender;
  final String? _lookingFor;
  final String? _ageRange;
  final String? _distance;
  final List<String>? _locale;
  final String? _interestCreativity;
  final String? _interestSports;
  final String? _interestVideo;
  final String? _interestMusic;
  final String? _interestTravelling;
  final String? _interestPet;
  final String? _introId;
  final Recording? _intro;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserModelIdentifier get modelIdentifier {
      return UserModelIdentifier(
        id: id
      );
  }
  
  String? get owner {
    return _owner;
  }
  
  OnlinePresence? get onlinePresence {
    return _onlinePresence;
  }
  
  String? get name {
    return _name;
  }
  
  String? get givenName {
    return _givenName;
  }
  
  String? get familyName {
    return _familyName;
  }
  
  String? get pictureNormal {
    return _pictureNormal;
  }
  
  String? get pictureMasked {
    return _pictureMasked;
  }
  
  String? get gender {
    return _gender;
  }
  
  String? get lookingFor {
    return _lookingFor;
  }
  
  String? get ageRange {
    return _ageRange;
  }
  
  String? get distance {
    return _distance;
  }
  
  List<String>? get locale {
    return _locale;
  }
  
  String? get interestCreativity {
    return _interestCreativity;
  }
  
  String? get interestSports {
    return _interestSports;
  }
  
  String? get interestVideo {
    return _interestVideo;
  }
  
  String? get interestMusic {
    return _interestMusic;
  }
  
  String? get interestTravelling {
    return _interestTravelling;
  }
  
  String? get interestPet {
    return _interestPet;
  }
  
  String? get introId {
    return _introId;
  }
  
  Recording? get intro {
    return _intro;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const User._internal({required this.id, owner, onlinePresence, name, givenName, familyName, pictureNormal, pictureMasked, gender, lookingFor, ageRange, distance, locale, interestCreativity, interestSports, interestVideo, interestMusic, interestTravelling, interestPet, introId, intro, createdAt, updatedAt}): _owner = owner, _onlinePresence = onlinePresence, _name = name, _givenName = givenName, _familyName = familyName, _pictureNormal = pictureNormal, _pictureMasked = pictureMasked, _gender = gender, _lookingFor = lookingFor, _ageRange = ageRange, _distance = distance, _locale = locale, _interestCreativity = interestCreativity, _interestSports = interestSports, _interestVideo = interestVideo, _interestMusic = interestMusic, _interestTravelling = interestTravelling, _interestPet = interestPet, _introId = introId, _intro = intro, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory User({String? id, String? owner, OnlinePresence? onlinePresence, String? name, String? givenName, String? familyName, String? pictureNormal, String? pictureMasked, String? gender, String? lookingFor, String? ageRange, String? distance, List<String>? locale, String? interestCreativity, String? interestSports, String? interestVideo, String? interestMusic, String? interestTravelling, String? interestPet, String? introId, Recording? intro, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return User._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      owner: owner,
      onlinePresence: onlinePresence,
      name: name,
      givenName: givenName,
      familyName: familyName,
      pictureNormal: pictureNormal,
      pictureMasked: pictureMasked,
      gender: gender,
      lookingFor: lookingFor,
      ageRange: ageRange,
      distance: distance,
      locale: locale != null ? List<String>.unmodifiable(locale) : locale,
      interestCreativity: interestCreativity,
      interestSports: interestSports,
      interestVideo: interestVideo,
      interestMusic: interestMusic,
      interestTravelling: interestTravelling,
      interestPet: interestPet,
      introId: introId,
      intro: intro,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      id == other.id &&
      _owner == other._owner &&
      _onlinePresence == other._onlinePresence &&
      _name == other._name &&
      _givenName == other._givenName &&
      _familyName == other._familyName &&
      _pictureNormal == other._pictureNormal &&
      _pictureMasked == other._pictureMasked &&
      _gender == other._gender &&
      _lookingFor == other._lookingFor &&
      _ageRange == other._ageRange &&
      _distance == other._distance &&
      DeepCollectionEquality().equals(_locale, other._locale) &&
      _interestCreativity == other._interestCreativity &&
      _interestSports == other._interestSports &&
      _interestVideo == other._interestVideo &&
      _interestMusic == other._interestMusic &&
      _interestTravelling == other._interestTravelling &&
      _interestPet == other._interestPet &&
      _introId == other._introId &&
      _intro == other._intro &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("owner=" + "$_owner" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("givenName=" + "$_givenName" + ", ");
    buffer.write("familyName=" + "$_familyName" + ", ");
    buffer.write("pictureNormal=" + "$_pictureNormal" + ", ");
    buffer.write("pictureMasked=" + "$_pictureMasked" + ", ");
    buffer.write("gender=" + "$_gender" + ", ");
    buffer.write("lookingFor=" + "$_lookingFor" + ", ");
    buffer.write("ageRange=" + "$_ageRange" + ", ");
    buffer.write("distance=" + "$_distance" + ", ");
    buffer.write("locale=" + (_locale != null ? _locale!.toString() : "null") + ", ");
    buffer.write("interestCreativity=" + "$_interestCreativity" + ", ");
    buffer.write("interestSports=" + "$_interestSports" + ", ");
    buffer.write("interestVideo=" + "$_interestVideo" + ", ");
    buffer.write("interestMusic=" + "$_interestMusic" + ", ");
    buffer.write("interestTravelling=" + "$_interestTravelling" + ", ");
    buffer.write("interestPet=" + "$_interestPet" + ", ");
    buffer.write("introId=" + "$_introId" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({String? owner, OnlinePresence? onlinePresence, String? name, String? givenName, String? familyName, String? pictureNormal, String? pictureMasked, String? gender, String? lookingFor, String? ageRange, String? distance, List<String>? locale, String? interestCreativity, String? interestSports, String? interestVideo, String? interestMusic, String? interestTravelling, String? interestPet, String? introId, Recording? intro, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return User._internal(
      id: id,
      owner: owner ?? this.owner,
      onlinePresence: onlinePresence ?? this.onlinePresence,
      name: name ?? this.name,
      givenName: givenName ?? this.givenName,
      familyName: familyName ?? this.familyName,
      pictureNormal: pictureNormal ?? this.pictureNormal,
      pictureMasked: pictureMasked ?? this.pictureMasked,
      gender: gender ?? this.gender,
      lookingFor: lookingFor ?? this.lookingFor,
      ageRange: ageRange ?? this.ageRange,
      distance: distance ?? this.distance,
      locale: locale ?? this.locale,
      interestCreativity: interestCreativity ?? this.interestCreativity,
      interestSports: interestSports ?? this.interestSports,
      interestVideo: interestVideo ?? this.interestVideo,
      interestMusic: interestMusic ?? this.interestMusic,
      interestTravelling: interestTravelling ?? this.interestTravelling,
      interestPet: interestPet ?? this.interestPet,
      introId: introId ?? this.introId,
      intro: intro ?? this.intro,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  User copyWithModelFieldValues({
    ModelFieldValue<String?>? owner,
    ModelFieldValue<OnlinePresence?>? onlinePresence,
    ModelFieldValue<String?>? name,
    ModelFieldValue<String?>? givenName,
    ModelFieldValue<String?>? familyName,
    ModelFieldValue<String?>? pictureNormal,
    ModelFieldValue<String?>? pictureMasked,
    ModelFieldValue<String?>? gender,
    ModelFieldValue<String?>? lookingFor,
    ModelFieldValue<String?>? ageRange,
    ModelFieldValue<String?>? distance,
    ModelFieldValue<List<String>?>? locale,
    ModelFieldValue<String?>? interestCreativity,
    ModelFieldValue<String?>? interestSports,
    ModelFieldValue<String?>? interestVideo,
    ModelFieldValue<String?>? interestMusic,
    ModelFieldValue<String?>? interestTravelling,
    ModelFieldValue<String?>? interestPet,
    ModelFieldValue<String?>? introId,
    ModelFieldValue<Recording?>? intro,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return User._internal(
      id: id,
      owner: owner == null ? this.owner : owner.value,
      onlinePresence: onlinePresence == null ? this.onlinePresence : onlinePresence.value,
      name: name == null ? this.name : name.value,
      givenName: givenName == null ? this.givenName : givenName.value,
      familyName: familyName == null ? this.familyName : familyName.value,
      pictureNormal: pictureNormal == null ? this.pictureNormal : pictureNormal.value,
      pictureMasked: pictureMasked == null ? this.pictureMasked : pictureMasked.value,
      gender: gender == null ? this.gender : gender.value,
      lookingFor: lookingFor == null ? this.lookingFor : lookingFor.value,
      ageRange: ageRange == null ? this.ageRange : ageRange.value,
      distance: distance == null ? this.distance : distance.value,
      locale: locale == null ? this.locale : locale.value,
      interestCreativity: interestCreativity == null ? this.interestCreativity : interestCreativity.value,
      interestSports: interestSports == null ? this.interestSports : interestSports.value,
      interestVideo: interestVideo == null ? this.interestVideo : interestVideo.value,
      interestMusic: interestMusic == null ? this.interestMusic : interestMusic.value,
      interestTravelling: interestTravelling == null ? this.interestTravelling : interestTravelling.value,
      interestPet: interestPet == null ? this.interestPet : interestPet.value,
      introId: introId == null ? this.introId : introId.value,
      intro: intro == null ? this.intro : intro.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _owner = json['owner'],
      _onlinePresence = json['onlinePresence']?['serializedData'] != null
        ? OnlinePresence.fromJson(new Map<String, dynamic>.from(json['onlinePresence']['serializedData']))
        : null,
      _name = json['name'],
      _givenName = json['givenName'],
      _familyName = json['familyName'],
      _pictureNormal = json['pictureNormal'],
      _pictureMasked = json['pictureMasked'],
      _gender = json['gender'],
      _lookingFor = json['lookingFor'],
      _ageRange = json['ageRange'],
      _distance = json['distance'],
      _locale = json['locale']?.cast<String>(),
      _interestCreativity = json['interestCreativity'],
      _interestSports = json['interestSports'],
      _interestVideo = json['interestVideo'],
      _interestMusic = json['interestMusic'],
      _interestTravelling = json['interestTravelling'],
      _interestPet = json['interestPet'],
      _introId = json['introId'],
      _intro = json['intro']?['serializedData'] != null
        ? Recording.fromJson(new Map<String, dynamic>.from(json['intro']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'owner': _owner, 'onlinePresence': _onlinePresence?.toJson(), 'name': _name, 'givenName': _givenName, 'familyName': _familyName, 'pictureNormal': _pictureNormal, 'pictureMasked': _pictureMasked, 'gender': _gender, 'lookingFor': _lookingFor, 'ageRange': _ageRange, 'distance': _distance, 'locale': _locale, 'interestCreativity': _interestCreativity, 'interestSports': _interestSports, 'interestVideo': _interestVideo, 'interestMusic': _interestMusic, 'interestTravelling': _interestTravelling, 'interestPet': _interestPet, 'introId': _introId, 'intro': _intro?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'owner': _owner,
    'onlinePresence': _onlinePresence,
    'name': _name,
    'givenName': _givenName,
    'familyName': _familyName,
    'pictureNormal': _pictureNormal,
    'pictureMasked': _pictureMasked,
    'gender': _gender,
    'lookingFor': _lookingFor,
    'ageRange': _ageRange,
    'distance': _distance,
    'locale': _locale,
    'interestCreativity': _interestCreativity,
    'interestSports': _interestSports,
    'interestVideo': _interestVideo,
    'interestMusic': _interestMusic,
    'interestTravelling': _interestTravelling,
    'interestPet': _interestPet,
    'introId': _introId,
    'intro': _intro,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final OWNER = amplify_core.QueryField(fieldName: "owner");
  static final ONLINEPRESENCE = amplify_core.QueryField(
    fieldName: "onlinePresence",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'OnlinePresence'));
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final GIVENNAME = amplify_core.QueryField(fieldName: "givenName");
  static final FAMILYNAME = amplify_core.QueryField(fieldName: "familyName");
  static final PICTURENORMAL = amplify_core.QueryField(fieldName: "pictureNormal");
  static final PICTUREMASKED = amplify_core.QueryField(fieldName: "pictureMasked");
  static final GENDER = amplify_core.QueryField(fieldName: "gender");
  static final LOOKINGFOR = amplify_core.QueryField(fieldName: "lookingFor");
  static final AGERANGE = amplify_core.QueryField(fieldName: "ageRange");
  static final DISTANCE = amplify_core.QueryField(fieldName: "distance");
  static final LOCALE = amplify_core.QueryField(fieldName: "locale");
  static final INTERESTCREATIVITY = amplify_core.QueryField(fieldName: "interestCreativity");
  static final INTERESTSPORTS = amplify_core.QueryField(fieldName: "interestSports");
  static final INTERESTVIDEO = amplify_core.QueryField(fieldName: "interestVideo");
  static final INTERESTMUSIC = amplify_core.QueryField(fieldName: "interestMusic");
  static final INTERESTTRAVELLING = amplify_core.QueryField(fieldName: "interestTravelling");
  static final INTERESTPET = amplify_core.QueryField(fieldName: "interestPet");
  static final INTROID = amplify_core.QueryField(fieldName: "introId");
  static final INTRO = amplify_core.QueryField(
    fieldName: "intro",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Recording'));
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.OWNER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: User.ONLINEPRESENCE,
      isRequired: false,
      ofModelName: 'OnlinePresence',
      associatedKey: OnlinePresence.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.GIVENNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.FAMILYNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PICTURENORMAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PICTUREMASKED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.GENDER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.LOOKINGFOR,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.AGERANGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.DISTANCE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.LOCALE,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.INTERESTCREATIVITY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.INTERESTSPORTS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.INTERESTVIDEO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.INTERESTMUSIC,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.INTERESTTRAVELLING,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.INTERESTPET,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.INTROID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: User.INTRO,
      isRequired: false,
      ofModelName: 'Recording',
      associatedKey: Recording.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _UserModelType extends amplify_core.ModelType<User> {
  const _UserModelType();
  
  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'User';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [User] in your schema.
 */
class UserModelIdentifier implements amplify_core.ModelIdentifier<User> {
  final String id;

  /** Create an instance of UserModelIdentifier using [id] the primary key. */
  const UserModelIdentifier({
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
  String toString() => 'UserModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}