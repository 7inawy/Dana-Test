// models/message_model.dart

import 'package:flutter/cupertino.dart';
import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../l10n/app_localizations.dart';

enum MessageSender { user, doctor }

class Message {
  final String id;
  final String text;
  final MessageSender sender;
  final String time;
  final bool isRead;

  const Message({
    required this.id,
    required this.text,
    required this.sender,
    required this.time,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'sender': sender.name,
    'time': time,
    'isRead': isRead,
  };

  static Message fromJson(Map<String, dynamic> json) => Message(
    id: (json['id'] ?? '').toString(),
    text: (json['text'] ?? '').toString(),
    sender: MessageSender.values.firstWhere(
      (s) => s.name == (json['sender'] ?? 'user').toString(),
      orElse: () => MessageSender.user,
    ),
    time: (json['time'] ?? '').toString(),
    isRead: json['isRead'] == true,
  );
}

class Doctor {
  final String? id;
  final String name;
  final String specialty;
  final String location;
  final String imageUrl;

  const Doctor({
    this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.imageUrl,
  });
}

Doctor getSampleDoctor(BuildContext context) => Doctor(
  id: null,
  name: AppLocalizations.of(context)!.doctorName,
  specialty: AppLocalizations.of(context)!.doctorSpecialty,
  location: AppLocalizations.of(context)!.doctorLocation,
  imageUrl: 'https://i.pravatar.cc/150?img=11',
);

Doctor getAIDoctor(BuildContext context) => Doctor(
  id: null,
  name: AppLocalizations.of(context)!.aiAssistantName,
  specialty: '',
  location: '',
  imageUrl: AppAssets.aiAvatar,
);

List<Message> getSampleMessages(BuildContext context) => [
  Message(
    id: '1',
    text: AppLocalizations.of(context)!.sampleMessage1,
    sender: MessageSender.user,
    time: '10:02',
    isRead: true,
  ),
  Message(
    id: '2',
    text: AppLocalizations.of(context)!.sampleMessage2,
    sender: MessageSender.doctor,
    time: '10:06',
    isRead: true,
  ),
  Message(
    id: '3',
    text: AppLocalizations.of(context)!.sampleMessage3,
    sender: MessageSender.user,
    time: '10:06',
    isRead: true,
  ),
  Message(
    id: '4',
    text: AppLocalizations.of(context)!.sampleMessage4,
    sender: MessageSender.doctor,
    time: '10:07',
    isRead: true,
  ),
  Message(
    id: '5',
    text: AppLocalizations.of(context)!.sampleMessage5,
    sender: MessageSender.user,
    time: '10:34',
    isRead: true,
  ),
  Message(
    id: '6',
    text: AppLocalizations.of(context)!.sampleMessage6,
    sender: MessageSender.doctor,
    time: '10:18',
    isRead: true,
  ),
  Message(
    id: '7',
    text: AppLocalizations.of(context)!.sampleMessage7,
    sender: MessageSender.user,
    time: '10:21',
    isRead: true,
  ),
  Message(
    id: '8',
    text: AppLocalizations.of(context)!.sampleMessage8,
    sender: MessageSender.doctor,
    time: '10:21',
    isRead: true,
  ),
];
