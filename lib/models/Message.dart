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


/** This is an auto generated class representing the Message type in your schema. */
class Message extends amplify_core.Model {
  static const classType = const _MessageModelType();
  final String id;
  final String? _owner;
  final String? _chatId;
  final String? _userId;
  final MessageType? _type;
  final String? _body;
  final String? _uploadId;
  final Upload? _upload;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MessageModelIdentifier get modelIdentifier {
      return MessageModelIdentifier(
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
  
  MessageType? get type {
    return _type;
  }
  
  String? get body {
    return _body;
  }
  
  String? get uploadId {
    return _uploadId;
  }
  
  Upload? get upload {
    return _upload;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Message._internal({required this.id, owner, chatId, userId, type, body, uploadId, upload, createdAt, updatedAt}): _owner = owner, _chatId = chatId, _userId = userId, _type = type, _body = body, _uploadId = uploadId, _upload = upload, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Message({String? id, String? owner, String? chatId, String? userId, MessageType? type, String? body, String? uploadId, Upload? upload, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return Message._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      owner: owner,
      chatId: chatId,
      userId: userId,
      type: type,
      body: body,
      uploadId: uploadId,
      upload: upload,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Message &&
      id == other.id &&
      _owner == other._owner &&
      _chatId == other._chatId &&
      _userId == other._userId &&
      _type == other._type &&
      _body == other._body &&
      _uploadId == other._uploadId &&
      _upload == other._upload &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Message {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("owner=" + "$_owner" + ", ");
    buffer.write("chatId=" + "$_chatId" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("type=" + (_type != null ? amplify_core.enumToString(_type)! : "null") + ", ");
    buffer.write("body=" + "$_body" + ", ");
    buffer.write("uploadId=" + "$_uploadId" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Message copyWith({String? owner, String? chatId, String? userId, MessageType? type, String? body, String? uploadId, Upload? upload, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return Message._internal(
      id: id,
      owner: owner ?? this.owner,
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      body: body ?? this.body,
      uploadId: uploadId ?? this.uploadId,
      upload: upload ?? this.upload,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  Message copyWithModelFieldValues({
    ModelFieldValue<String?>? owner,
    ModelFieldValue<String?>? chatId,
    ModelFieldValue<String?>? userId,
    ModelFieldValue<MessageType?>? type,
    ModelFieldValue<String?>? body,
    ModelFieldValue<String?>? uploadId,
    ModelFieldValue<Upload?>? upload,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return Message._internal(
      id: id,
      owner: owner == null ? this.owner : owner.value,
      chatId: chatId == null ? this.chatId : chatId.value,
      userId: userId == null ? this.userId : userId.value,
      type: type == null ? this.type : type.value,
      body: body == null ? this.body : body.value,
      uploadId: uploadId == null ? this.uploadId : uploadId.value,
      upload: upload == null ? this.upload : upload.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  Message.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _owner = json['owner'],
      _chatId = json['chatId'],
      _userId = json['userId'],
      _type = amplify_core.enumFromString<MessageType>(json['type'], MessageType.values),
      _body = json['body'],
      _uploadId = json['uploadId'],
      _upload = json['upload']?['serializedData'] != null
        ? Upload.fromJson(new Map<String, dynamic>.from(json['upload']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'owner': _owner, 'chatId': _chatId, 'userId': _userId, 'type': amplify_core.enumToString(_type), 'body': _body, 'uploadId': _uploadId, 'upload': _upload?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'owner': _owner,
    'chatId': _chatId,
    'userId': _userId,
    'type': _type,
    'body': _body,
    'uploadId': _uploadId,
    'upload': _upload,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<MessageModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MessageModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final OWNER = amplify_core.QueryField(fieldName: "owner");
  static final CHATID = amplify_core.QueryField(fieldName: "chatId");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final BODY = amplify_core.QueryField(fieldName: "body");
  static final UPLOADID = amplify_core.QueryField(fieldName: "uploadId");
  static final UPLOAD = amplify_core.QueryField(
    fieldName: "upload",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Upload'));
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Message";
    modelSchemaDefinition.pluralName = "Messages";
    
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
      amplify_core.ModelIndex(fields: const ["chatId", "createdAt"], name: "listMessageByChatId"),
      amplify_core.ModelIndex(fields: const ["userId", "createdAt"], name: "listMessageByUserId")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.OWNER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.CHATID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.USERID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.TYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.BODY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.UPLOADID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: Message.UPLOAD,
      isRequired: false,
      ofModelName: 'Upload',
      associatedKey: Upload.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _MessageModelType extends amplify_core.ModelType<Message> {
  const _MessageModelType();
  
  @override
  Message fromJson(Map<String, dynamic> jsonData) {
    return Message.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Message';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Message] in your schema.
 */
class MessageModelIdentifier implements amplify_core.ModelIdentifier<Message> {
  final String id;

  /** Create an instance of MessageModelIdentifier using [id] the primary key. */
  const MessageModelIdentifier({
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
  String toString() => 'MessageModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MessageModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}