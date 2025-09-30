import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatEntity extends Equatable {
  final String id;
  final String currentUserId;
  final ChatParticipant participant;
  final ChatType type;
  final String title;
  final String? description;
  final String? avatarUrl;
  final MessageEntity? lastMessage;
  final int unreadCount;
  final bool isArchived;
  final bool isBlocked;
  final bool isMuted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSeenAt;
  final Map<String, dynamic>? metadata;
  final List<String>? tags;

  const ChatEntity({
    required this.id,
    required this.currentUserId,
    required this.participant,
    this.type = ChatType.direct,
    required this.title,
    this.description,
    this.avatarUrl,
    this.lastMessage,
    this.unreadCount = 0,
    this.isArchived = false,
    this.isBlocked = false,
    this.isMuted = false,
    required this.createdAt,
    required this.updatedAt,
    this.lastSeenAt,
    this.metadata,
    this.tags,
  });

  bool get isOnline => lastSeenAt != null &&
    DateTime.now().difference(lastSeenAt!).inMinutes < 5;

  bool get canSendMessage => !isBlocked && !isArchived;

  bool get showUnreadBadge => unreadCount > 0 && !isMuted;

  String get displayTitle => title.isNotEmpty ? title : participant.displayName;

  String get lastActivityText {
    if (lastMessage == null) {
      return 'No messages yet';
    }
    return lastMessage!.timeAgo;
  }

  @override
  List<Object?> get props => [
        id,
        currentUserId,
        participant,
        type,
        title,
        description,
        avatarUrl,
        lastMessage,
        unreadCount,
        isArchived,
        isBlocked,
        isMuted,
        createdAt,
        updatedAt,
        lastSeenAt,
        metadata,
        tags,
      ];
}

class ChatParticipant extends Equatable {
  final String id;
  final String displayName;
  final String? avatarUrl;
  final String? email;
  final String? phone;
  final UserRole role;
  final bool isVerified;
  final bool isOnline;
  final DateTime? lastSeenAt;
  final int messageCount;
  final double? rating;
  final Map<String, dynamic>? metadata;

  const ChatParticipant({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    this.email,
    this.phone,
    this.role = UserRole.user,
    this.isVerified = false,
    this.isOnline = false,
    this.lastSeenAt,
    this.messageCount = 0,
    this.rating,
    this.metadata,
  });

  String get onlineStatus {
    if (isOnline) return 'Online';
    if (lastSeenAt == null) return 'Offline';
    return 'Last seen ${_calculateLastSeen()}';
  }

  String _calculateLastSeen() {
    if (lastSeenAt == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastSeenAt!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        avatarUrl,
        email,
        phone,
        role,
        isVerified,
        isOnline,
        lastSeenAt,
        messageCount,
        rating,
        metadata,
      ];
}

class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final MessageType type;
  final String content;
  final MessageStatus status;
  final DateTime createdAt;
  final DateTime? editedAt;
  final DateTime? deletedAt;
  final List<String> readBy;
  final List<MessageReaction> reactions;
  final MessageReply? replyTo;
  final List<MessageAttachment> attachments;
  final Map<String, dynamic>? metadata;
  final bool isForwarded;
  final String? originalMessageId;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.type,
    required this.content,
    this.status = MessageStatus.sending,
    required this.createdAt,
    this.editedAt,
    this.deletedAt,
    this.readBy = const [],
    this.reactions = const [],
    this.replyTo,
    this.attachments = const [],
    this.metadata,
    this.isForwarded = false,
    this.originalMessageId,
  });

  bool get isDeleted => deletedAt != null;

  bool get isEdited => editedAt != null;

  bool get canBeEdited => !isDeleted &&
    DateTime.now().difference(createdAt).inMinutes < 5;

  bool get canBeDeleted => !isDeleted &&
    (senderId == _currentUserId || DateTime.now().difference(createdAt).inMinutes < 10);

  bool get isRead => readBy.contains(_currentUserId);

  String get timeAgo => _calculateTimeAgo();

  String get displayTime => _formatDisplayTime();

  String _calculateTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  String _formatDisplayTime() {
    return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [
        id,
        chatId,
        senderId,
        senderName,
        senderAvatar,
        type,
        content,
        status,
        createdAt,
        editedAt,
        deletedAt,
        readBy,
        reactions,
        replyTo,
        attachments,
        metadata,
        isForwarded,
        originalMessageId,
      ];
}

// Static variable for current user - in real app this would come from auth state
String get _currentUserId => 'current_user_id'; // TODO: Get from auth state

class MessageReaction extends Equatable {
  final String emoji;
  final String userId;
  final String userName;
  final DateTime createdAt;

  const MessageReaction({
    required this.emoji,
    required this.userId,
    required this.userName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [emoji, userId, userName, createdAt];
}

class MessageReply extends Equatable {
  final String messageId;
  final String content;
  final String senderName;
  final MessageType type;

  const MessageReply({
    required this.messageId,
    required this.content,
    required this.senderName,
    required this.type,
  });

  @override
  List<Object?> get props => [messageId, content, senderName, type];
}

class MessageAttachment extends Equatable {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int fileSize;
  final String? thumbnailUrl;
  final AttachmentStatus status;
  final DateTime uploadedAt;
  final Map<String, dynamic>? metadata;

  const MessageAttachment({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.fileSize,
    this.thumbnailUrl,
    this.status = AttachmentStatus.uploaded,
    required this.uploadedAt,
    this.metadata,
  });

  bool get isImage => fileType.startsWith('image/');

  bool get isVideo => fileType.startsWith('video/');

  bool get isAudio => fileType.startsWith('audio/');

  bool get isDocument => !isImage && !isVideo && !isAudio;

  String get sizeText => _formatFileSize();

  String _formatFileSize() {
    const units = ['B', 'KB', 'MB', 'GB'];
    var size = fileSize.toDouble();
    var unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }

  @override
  List<Object?> get props => [
        id,
        fileName,
        fileUrl,
        fileType,
        fileSize,
        thumbnailUrl,
        status,
        uploadedAt,
        metadata,
      ];
}

enum ChatType {
  direct('direct', 'Direkt Mesaj', Icons.person),
  group('group', 'Grup Sohbeti', Icons.group),
  support('support', 'Destek', Icons.support),
  system('system', 'Sistem', Icons.info);

  const ChatType(this.value, this.displayName, this.icon);
  final String value;
  final String displayName;
  final IconData icon;

  static ChatType fromString(String value) {
    return ChatType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ChatType.direct,
    );
  }
}

enum MessageType {
  text('text', 'Metin', Icons.text_fields),
  image('image', 'Resim', Icons.image),
  video('video', 'Video', Icons.video_file),
  audio('audio', 'Ses', Icons.audiotrack),
  file('file', 'Dosya', Icons.insert_drive_file),
  location('location', 'Konum', Icons.location_on),
  contact('contact', 'Kişi', Icons.contact_phone),
  sticker('sticker', 'Sticker', Icons.emoji_emotions),
  gif('gif', 'GIF', Icons.gif),
  system('system', 'Sistem', Icons.info_outline);

  const MessageType(this.value, this.displayName, this.icon);
  final String value;
  final String displayName;
  final IconData icon;

  static MessageType fromString(String value) {
    return MessageType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MessageType.text,
    );
  }
}

enum MessageStatus {
  sending('sending', 'Gönderiliyor'),
  sent('sent', 'Gönderildi'),
  delivered('delivered', 'Teslim Edildi'),
  read('read', 'Okundu'),
  failed('failed', 'Başarısız');

  const MessageStatus(this.value, this.displayName);
  final String value;
  final String displayName;

  static MessageStatus fromString(String value) {
    return MessageStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => MessageStatus.sent,
    );
  }
}

enum AttachmentStatus {
  uploading('uploading', 'Yükleniyor'),
  uploaded('uploaded', 'Yüklendi'),
  failed('failed', 'Başarısız');

  const AttachmentStatus(this.value, this.displayName);
  final String value;
  final String displayName;

  static AttachmentStatus fromString(String value) {
    return AttachmentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AttachmentStatus.uploaded,
    );
  }
}

enum UserRole {
  user('user', 'Kullanıcı'),
  moderator('moderator', 'Moderatör'),
  admin('admin', 'Admin'),
  system('system', 'Sistem');

  const UserRole(this.value, this.displayName);
  final String value;
  final String displayName;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.user,
    );
  }
}

class ChatRoomEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? avatarUrl;
  final List<ChatParticipant> participants;
  final List<String> admins;
  final ChatRoomSettings settings;
  final MessageEntity? lastMessage;
  final int messageCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatRoomEntity({
    required this.id,
    required this.name,
    required this.description,
    this.avatarUrl,
    required this.participants,
    this.admins = const [],
    this.settings = const ChatRoomSettings(),
    this.lastMessage,
    this.messageCount = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get canAddParticipants => participants.length < settings.maxParticipants;

  bool get canSendMessage => isActive && participants.length >= 2;

  ChatParticipant? getParticipant(String userId) {
    return participants.where((p) => p.id == userId).firstOrNull;
  }

  bool isAdmin(String userId) => admins.contains(userId);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        avatarUrl,
        participants,
        admins,
        settings,
        lastMessage,
        messageCount,
        isActive,
        createdAt,
        updatedAt,
      ];
}

class ChatRoomSettings extends Equatable {
  final int maxParticipants;
  final bool allowFileSharing;
  final bool allowImageSharing;
  final bool allowVoiceMessages;
  final bool allowLocationSharing;
  final bool requireAdminApproval;
  final bool allowGuestUsers;
  final int messageHistoryDays;
  final int maxMessageLength;
  final List<String> allowedFileTypes;
  final int maxFileSizeMB;

  const ChatRoomSettings({
    this.maxParticipants = 50,
    this.allowFileSharing = true,
    this.allowImageSharing = true,
    this.allowVoiceMessages = true,
    this.allowLocationSharing = true,
    this.requireAdminApproval = false,
    this.allowGuestUsers = false,
    this.messageHistoryDays = 30,
    this.maxMessageLength = 1000,
    this.allowedFileTypes = const ['pdf', 'doc', 'docx', 'txt', 'jpg', 'png', 'gif', 'mp4', 'mp3'],
    this.maxFileSizeMB = 10,
  });

  @override
  List<Object?> get props => [
        maxParticipants,
        allowFileSharing,
        allowImageSharing,
        allowVoiceMessages,
        allowLocationSharing,
        requireAdminApproval,
        allowGuestUsers,
        messageHistoryDays,
        maxMessageLength,
        allowedFileTypes,
        maxFileSizeMB,
      ];
}

class ChatStats extends Equatable {
  final int totalChats;
  final int activeChats;
  final int totalMessages;
  final int unreadMessages;
  final Map<String, int> messageTypeDistribution;
  final Map<String, int> chatTypeDistribution;
  final List<ChatActivity> dailyActivity;
  final List<TopParticipant> topParticipants;

  const ChatStats({
    required this.totalChats,
    required this.activeChats,
    required this.totalMessages,
    required this.unreadMessages,
    required this.messageTypeDistribution,
    required this.chatTypeDistribution,
    required this.dailyActivity,
    required this.topParticipants,
  });

  @override
  List<Object?> get props => [
        totalChats,
        activeChats,
        totalMessages,
        unreadMessages,
        messageTypeDistribution,
        chatTypeDistribution,
        dailyActivity,
        topParticipants,
      ];
}

class ChatActivity extends Equatable {
  final DateTime date;
  final int messageCount;
  final int chatCount;

  const ChatActivity({
    required this.date,
    required this.messageCount,
    required this.chatCount,
  });

  @override
  List<Object?> get props => [date, messageCount, chatCount];
}

class TopParticipant extends Equatable {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int messageCount;
  final int chatCount;

  const TopParticipant({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.messageCount,
    required this.chatCount,
  });

  @override
  List<Object?> get props => [userId, userName, avatarUrl, messageCount, chatCount];
}

// Extension methods
extension ChatEntityExtension on ChatEntity {
  static ChatEntity? getChatByParticipant(List<ChatEntity> chats, String participantId) {
    return chats.where((chat) => chat.participant.id == participantId).firstOrNull;
  }

  static List<ChatEntity> getActiveChats(List<ChatEntity> chats) {
    return chats.where((chat) => chat.canSendMessage && !chat.isArchived).toList();
  }

  static List<ChatEntity> getArchivedChats(List<ChatEntity> chats) {
    return chats.where((chat) => chat.isArchived).toList();
  }

  static int getTotalUnreadCount(List<ChatEntity> chats) {
    return chats.fold(0, (sum, chat) => sum + chat.unreadCount);
  }
}

// Helper extensions
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

extension ChatParticipantExtension on ChatParticipant {
  bool get isCurrentUser => id == _currentUserId;
}
