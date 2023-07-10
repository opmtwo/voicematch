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


/** This is an auto generated class representing the Upload type in your schema. */
class Upload extends amplify_core.Model {
  static const classType = const _UploadModelType();
  final String id;
  final String? _owner;
  final String? _userId;
  final String? _modelId;
  final String? _modelType;
  final String? _name;
  final String? _mime;
  final int? _size;
  final int? _duration;
  final String? _key;
  final String? _url;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UploadModelIdentifier get modelIdentifier {
      return UploadModelIdentifier(
        id: id
      );
  }
  
  String? get owner {
    return _owner;
  }
  
  String? get userId {
    return _userId;
  }
  
  String get modelId {
    try {
      return _modelId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get modelType {
    return _modelType;
  }
  
  String? get name {
    return _name;
  }
  
  String? get mime {
    return _mime;
  }
  
  int? get size {
    return _size;
  }
  
  int? get duration {
    return _duration;
  }
  
  String? get key {
    return _key;
  }
  
  String? get url {
    return _url;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Upload._internal({required this.id, owner, userId, required modelId, modelType, name, mime, size, duration, key, url, createdAt, updatedAt}): _owner = owner, _userId = userId, _modelId = modelId, _modelType = modelType, _name = name, _mime = mime, _size = size, _duration = duration, _key = key, _url = url, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Upload({String? id, String? owner, String? userId, required String modelId, String? modelType, String? name, String? mime, int? size, int? duration, String? key, String? url, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return Upload._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      owner: owner,
      userId: userId,
      modelId: modelId,
      modelType: modelType,
      name: name,
      mime: mime,
      size: size,
      duration: duration,
      key: key,
      url: url,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Upload &&
      id == other.id &&
      _owner == other._owner &&
      _userId == other._userId &&
      _modelId == other._modelId &&
      _modelType == other._modelType &&
      _name == other._name &&
      _mime == other._mime &&
      _size == other._size &&
      _duration == other._duration &&
      _key == other._key &&
      _url == other._url &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Upload {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("owner=" + "$_owner" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("modelId=" + "$_modelId" + ", ");
    buffer.write("modelType=" + "$_modelType" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("mime=" + "$_mime" + ", ");
    buffer.write("size=" + (_size != null ? _size!.toString() : "null") + ", ");
    buffer.write("duration=" + (_duration != null ? _duration!.toString() : "null") + ", ");
    buffer.write("key=" + "$_key" + ", ");
    buffer.write("url=" + "$_url" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Upload copyWith({String? owner, String? userId, String? modelId, String? modelType, String? name, String? mime, int? size, int? duration, String? key, String? url, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return Upload._internal(
      id: id,
      owner: owner ?? this.owner,
      userId: userId ?? this.userId,
      modelId: modelId ?? this.modelId,
      modelType: modelType ?? this.modelType,
      name: name ?? this.name,
      mime: mime ?? this.mime,
      size: size ?? this.size,
      duration: duration ?? this.duration,
      key: key ?? this.key,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  Upload copyWithModelFieldValues({
    ModelFieldValue<String?>? owner,
    ModelFieldValue<String?>? userId,
    ModelFieldValue<String>? modelId,
    ModelFieldValue<String?>? modelType,
    ModelFieldValue<String?>? name,
    ModelFieldValue<String?>? mime,
    ModelFieldValue<int?>? size,
    ModelFieldValue<int?>? duration,
    ModelFieldValue<String?>? key,
    ModelFieldValue<String?>? url,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return Upload._internal(
      id: id,
      owner: owner == null ? this.owner : owner.value,
      userId: userId == null ? this.userId : userId.value,
      modelId: modelId == null ? this.modelId : modelId.value,
      modelType: modelType == null ? this.modelType : modelType.value,
      name: name == null ? this.name : name.value,
      mime: mime == null ? this.mime : mime.value,
      size: size == null ? this.size : size.value,
      duration: duration == null ? this.duration : duration.value,
      key: key == null ? this.key : key.value,
      url: url == null ? this.url : url.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  Upload.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _owner = json['owner'],
      _userId = json['userId'],
      _modelId = json['modelId'],
      _modelType = json['modelType'],
      _name = json['name'],
      _mime = json['mime'],
      _size = (json['size'] as num?)?.toInt(),
      _duration = (json['duration'] as num?)?.toInt(),
      _key = json['key'],
      _url = json['url'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'owner': _owner, 'userId': _userId, 'modelId': _modelId, 'modelType': _modelType, 'name': _name, 'mime': _mime, 'size': _size, 'duration': _duration, 'key': _key, 'url': _url, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'owner': _owner,
    'userId': _userId,
    'modelId': _modelId,
    'modelType': _modelType,
    'name': _name,
    'mime': _mime,
    'size': _size,
    'duration': _duration,
    'key': _key,
    'url': _url,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UploadModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UploadModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final OWNER = amplify_core.QueryField(fieldName: "owner");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final MODELID = amplify_core.QueryField(fieldName: "modelId");
  static final MODELTYPE = amplify_core.QueryField(fieldName: "modelType");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final MIME = amplify_core.QueryField(fieldName: "mime");
  static final SIZE = amplify_core.QueryField(fieldName: "size");
  static final DURATION = amplify_core.QueryField(fieldName: "duration");
  static final KEY = amplify_core.QueryField(fieldName: "key");
  static final URL = amplify_core.QueryField(fieldName: "url");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Upload";
    modelSchemaDefinition.pluralName = "Uploads";
    
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
      amplify_core.ModelIndex(fields: const ["userId", "createdAt"], name: "listUploadsByUserId"),
      amplify_core.ModelIndex(fields: const ["modelId", "createdAt"], name: "listUploadsByModelId")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.OWNER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.USERID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.MODELID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.MODELTYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.MIME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.SIZE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.DURATION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.KEY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.URL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Upload.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _UploadModelType extends amplify_core.ModelType<Upload> {
  const _UploadModelType();
  
  @override
  Upload fromJson(Map<String, dynamic> jsonData) {
    return Upload.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Upload';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Upload] in your schema.
 */
class UploadModelIdentifier implements amplify_core.ModelIdentifier<Upload> {
  final String id;

  /** Create an instance of UploadModelIdentifier using [id] the primary key. */
  const UploadModelIdentifier({
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
  String toString() => 'UploadModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UploadModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}