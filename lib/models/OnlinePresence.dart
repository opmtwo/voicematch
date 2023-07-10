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


/** This is an auto generated class representing the OnlinePresence type in your schema. */
class OnlinePresence extends amplify_core.Model {
  static const classType = const _OnlinePresenceModelType();
  final String id;
  final String? _owner;
  final OnlineStatus? _status;
  final amplify_core.TemporalDateTime? _lastSeenAt;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  OnlinePresenceModelIdentifier get modelIdentifier {
      return OnlinePresenceModelIdentifier(
        id: id
      );
  }
  
  String? get owner {
    return _owner;
  }
  
  OnlineStatus? get status {
    return _status;
  }
  
  amplify_core.TemporalDateTime? get lastSeenAt {
    return _lastSeenAt;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const OnlinePresence._internal({required this.id, owner, status, lastSeenAt, createdAt, updatedAt}): _owner = owner, _status = status, _lastSeenAt = lastSeenAt, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory OnlinePresence({String? id, String? owner, OnlineStatus? status, amplify_core.TemporalDateTime? lastSeenAt, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return OnlinePresence._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      owner: owner,
      status: status,
      lastSeenAt: lastSeenAt,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OnlinePresence &&
      id == other.id &&
      _owner == other._owner &&
      _status == other._status &&
      _lastSeenAt == other._lastSeenAt &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("OnlinePresence {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("owner=" + "$_owner" + ", ");
    buffer.write("status=" + (_status != null ? amplify_core.enumToString(_status)! : "null") + ", ");
    buffer.write("lastSeenAt=" + (_lastSeenAt != null ? _lastSeenAt!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  OnlinePresence copyWith({String? owner, OnlineStatus? status, amplify_core.TemporalDateTime? lastSeenAt, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return OnlinePresence._internal(
      id: id,
      owner: owner ?? this.owner,
      status: status ?? this.status,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  OnlinePresence copyWithModelFieldValues({
    ModelFieldValue<String?>? owner,
    ModelFieldValue<OnlineStatus?>? status,
    ModelFieldValue<amplify_core.TemporalDateTime?>? lastSeenAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return OnlinePresence._internal(
      id: id,
      owner: owner == null ? this.owner : owner.value,
      status: status == null ? this.status : status.value,
      lastSeenAt: lastSeenAt == null ? this.lastSeenAt : lastSeenAt.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  OnlinePresence.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _owner = json['owner'],
      _status = amplify_core.enumFromString<OnlineStatus>(json['status'], OnlineStatus.values),
      _lastSeenAt = json['lastSeenAt'] != null ? amplify_core.TemporalDateTime.fromString(json['lastSeenAt']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'owner': _owner, 'status': amplify_core.enumToString(_status), 'lastSeenAt': _lastSeenAt?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'owner': _owner,
    'status': _status,
    'lastSeenAt': _lastSeenAt,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<OnlinePresenceModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<OnlinePresenceModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final OWNER = amplify_core.QueryField(fieldName: "owner");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final LASTSEENAT = amplify_core.QueryField(fieldName: "lastSeenAt");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "OnlinePresence";
    modelSchemaDefinition.pluralName = "OnlinePresences";
    
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
      key: OnlinePresence.OWNER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: OnlinePresence.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: OnlinePresence.LASTSEENAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: OnlinePresence.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: OnlinePresence.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _OnlinePresenceModelType extends amplify_core.ModelType<OnlinePresence> {
  const _OnlinePresenceModelType();
  
  @override
  OnlinePresence fromJson(Map<String, dynamic> jsonData) {
    return OnlinePresence.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'OnlinePresence';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [OnlinePresence] in your schema.
 */
class OnlinePresenceModelIdentifier implements amplify_core.ModelIdentifier<OnlinePresence> {
  final String id;

  /** Create an instance of OnlinePresenceModelIdentifier using [id] the primary key. */
  const OnlinePresenceModelIdentifier({
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
  String toString() => 'OnlinePresenceModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is OnlinePresenceModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}