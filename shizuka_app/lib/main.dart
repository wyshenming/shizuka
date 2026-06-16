import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api/chat_api.dart';
import 'storage/local_data_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocalDataStore.ensureStructure();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ShizukaColors.surface,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: ShizukaColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ShizukaApp());
}

class ShizukaApp extends StatelessWidget {
  const ShizukaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '静谧之声',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: ShizukaColors.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ShizukaColors.primaryContainer,
          brightness: Brightness.light,
          primary: ShizukaColors.primary,
          surface: ShizukaColors.surface,
        ),
        fontFamily: 'Plus Jakarta Sans',
      ),
      initialRoute: AppRoutes.chatHome,
      routes: {
        AppRoutes.chatHome: (_) => const ChatHomePage(),
        AppRoutes.encounter: (_) => const EncounterPage(),
        AppRoutes.mine: (_) => const MinePage(),
        AppRoutes.profile: (_) => const ProfilePage(),
        AppRoutes.api: (_) => const ApiSettingsPage(),
        AppRoutes.about: (_) => const AboutPage(),
        AppRoutes.memories: (_) => const MemoriesPage(),
        AppRoutes.dialogue: (_) => const DialoguePage(),
        AppRoutes.newCharacter: (_) => const NewCharacterPage(),
      },
    );
  }
}

class AppRoutes {
  static const chatHome = '/';
  static const encounter = '/encounter';
  static const mine = '/mine';
  static const profile = '/profile';
  static const api = '/api';
  static const about = '/about';
  static const memories = '/memories';
  static const dialogue = '/dialogue';
  static const newCharacter = '/character/new';
}

class ShizukaColors {
  static const surface = Color(0xFFF8F9FA);
  static const surfaceDim = Color(0xFFD9DADB);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF3F4F5);
  static const surfaceContainer = Color(0xFFEDEEEF);
  static const surfaceContainerHigh = Color(0xFFE7E8E9);
  static const surfaceContainerHighest = Color(0xFFE1E3E4);
  static const onSurface = Color(0xFF191C1D);
  static const onSurfaceVariant = Color(0xFF41484A);
  static const outline = Color(0xFF71787A);
  static const outlineVariant = Color(0xFFC1C8C9);
  static const primary = Color(0xFF41646B);
  static const primaryContainer = Color(0xFFA5CAD2);
  static const onPrimaryContainer = Color(0xFF32565D);
  static const secondaryContainer = Color(0xFFEBDEF2);
  static const tertiaryContainer = Color(0xFFBBC9A6);
  static const error = Color(0xFFBA1A1A);
}

class ShizukaText {
  static const display = TextStyle(
    fontFamily: 'Noto Serif SC',
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static const displaySmall = TextStyle(
    fontFamily: 'Noto Serif SC',
    fontSize: 18,
    height: 28 / 18,
    fontWeight: FontWeight.w600,
  );

  static const dialogue = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 18,
    height: 1.8,
    fontWeight: FontWeight.w400,
  );

  static const dialogueMobile = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 16,
    height: 1.6,
    fontWeight: FontWeight.w400,
  );

  static const labelLarge = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.28,
  );

  static const labelSmall = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
  );

  static const system = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
  );
}

class GlassHeader extends StatelessWidget implements PreferredSizeWidget {
  const GlassHeader({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.primaryTitle = true,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final bool primaryTitle;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64 + MediaQuery.paddingOf(context).top,
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top,
            left: 24,
            right: 24,
          ),
          decoration: BoxDecoration(
            color: ShizukaColors.surface.withValues(alpha: 0.72),
            border: Border(
              bottom: BorderSide(
                color: ShizukaColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: 44, child: leading),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: ShizukaText.display.copyWith(
                    color: primaryTitle
                        ? ShizukaColors.primary
                        : ShizukaColors.onSurface,
                  ),
                ),
              ),
              SizedBox(width: 44, child: trailing),
            ],
          ),
        ),
      ),
    );
  }
}

class ShizukaScaffold extends StatelessWidget {
  const ShizukaScaffold({
    super.key,
    required this.title,
    required this.child,
    this.currentTab,
    this.leading,
    this.trailing,
    this.showBottomNav = true,
    this.primaryTitle = true,
  });

  final String title;
  final Widget child;
  final int? currentTab;
  final Widget? leading;
  final Widget? trailing;
  final bool showBottomNav;
  final bool primaryTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShizukaColors.surface,
      appBar: GlassHeader(
        title: title,
        leading: leading,
        trailing: trailing,
        primaryTitle: primaryTitle,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? ShizukaBottomNav(currentIndex: currentTab ?? 0)
          : null,
    );
  }
}

class ShizukaBottomNav extends StatelessWidget {
  const ShizukaBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.chat_bubble_rounded, '聊天', AppRoutes.chatHome),
      (Icons.group_rounded, '相遇', AppRoutes.encounter),
      (Icons.person_rounded, '我的', AppRoutes.mine),
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: 82 + MediaQuery.paddingOf(context).bottom,
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 8,
            bottom: MediaQuery.paddingOf(context).bottom,
          ),
          decoration: BoxDecoration(
            color: ShizukaColors.surface.withValues(alpha: 0.72),
            border: Border(
              top: BorderSide(
                color: ShizukaColors.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: ShizukaColors.primary.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var index = 0; index < items.length; index++)
                _BottomNavItem(
                  icon: items[index].$1,
                  label: items[index].$2,
                  active: currentIndex == index,
                  onTap: () {
                    if (currentIndex != index) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        items[index].$3,
                        (_) => false,
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? ShizukaColors.primary
        : ShizukaColors.onSurfaceVariant;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: active ? 18 : 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: active
              ? ShizukaColors.secondaryContainer.withValues(alpha: 0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: ShizukaColors.primaryContainer.withValues(
                      alpha: 0.4,
                    ),
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(height: 3),
            Text(label, style: ShizukaText.labelSmall.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class SoftIconButton extends StatelessWidget {
  const SoftIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = ShizukaColors.primary,
    this.background,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: color),
      style: IconButton.styleFrom(
        backgroundColor: background ?? Colors.transparent,
        shape: const CircleBorder(),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.url, required this.size, this.radius});

  final String url;
  final double size;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? size / 2),
        child: Container(
          width: size,
          height: size,
          color: ShizukaColors.surfaceContainerHigh,
          child: Icon(
            Icons.person,
            color: ShizukaColors.outline,
            size: size / 2,
          ),
        ),
      );
    }

    final fallback = Container(
      width: size,
      height: size,
      color: ShizukaColors.surfaceContainerHigh,
      child: Icon(Icons.person, color: ShizukaColors.outline, size: size / 2),
    );

    final image = url.startsWith('http')
        ? Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => fallback,
          )
        : Image.file(
            File(url),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => fallback,
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? size / 2),
      child: image,
    );
  }
}

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  @override
  void initState() {
    super.initState();
    ChatSessionStore.instance.addListener(_refresh);
  }

  @override
  void dispose() {
    ChatSessionStore.instance.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openSession(ChatSession session) async {
    final character = await CharacterStore.load(session.characterId);
    if (!mounted || character == null) {
      return;
    }
    await Navigator.pushNamed(
      context,
      AppRoutes.dialogue,
      arguments: character,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ChatSessionStore.instance.sessions;
    return ShizukaScaffold(
      title: '消息',
      currentTab: 0,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 28),
        children: [
          if (sessions.isEmpty) ...[
            const SizedBox(height: 120),
            Text(
              '还没有新的消息。',
              textAlign: TextAlign.center,
              style: ShizukaText.system.copyWith(
                color: ShizukaColors.outline.withValues(alpha: 0.6),
              ),
            ),
          ] else ...[
            for (final session in sessions) ...[
              ChatListTile(
                name: session.characterName,
                time: '',
                message: session.recentMessage,
                avatar: session.characterAvatar,
                onTap: () => _openSession(session),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ],
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    super.key,
    required this.name,
    required this.time,
    required this.message,
    required this.avatar,
    required this.onTap,
    this.online = false,
    this.unread = false,
  });

  final String name;
  final String time;
  final String message;
  final String avatar;
  final VoidCallback onTap;
  final bool online;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: ShizukaColors.outlineVariant.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: ShizukaColors.primary.withValues(alpha: 0.05),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: ShizukaColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Avatar(url: avatar, size: 80),
                ),
                if (online)
                  Positioned(
                    right: 3,
                    bottom: 3,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: ShizukaColors.primaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ShizukaText.displaySmall,
                        ),
                      ),
                      Text(
                        time,
                        style: ShizukaText.labelSmall.copyWith(
                          color: ShizukaColors.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ShizukaText.dialogueMobile.copyWith(
                      color: ShizukaColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (unread) ...[
              const SizedBox(width: 12),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: ShizukaColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ShizukaColors.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CharacterProfile {
  const CharacterProfile({
    required this.id,
    required this.name,
    required this.avatar,
    required this.gender,
    required this.age,
    required this.description,
    required this.persona,
    required this.background,
    required this.behaviorPreference,
    required this.dialogueExamples,
    required this.firstMessage,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String avatar;
  final String gender;
  final String age;
  final String description;
  final String persona;
  final String background;
  final String behaviorPreference;
  final String dialogueExamples;
  final String firstMessage;
  final List<String> tags;
  final String createdAt;
  final String updatedAt;

  factory CharacterProfile.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now().toIso8601String();
    return CharacterProfile(
      id:
          json['id'] as String? ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: _repairImportedText(json['name'] as String? ?? ''),
      avatar: json['avatar'] as String? ?? '',
      gender: _repairImportedText(json['gender'] as String? ?? ''),
      age: _repairImportedText(json['age'] as String? ?? ''),
      description: _repairImportedText(json['description'] as String? ?? ''),
      persona: _repairImportedText(json['persona'] as String? ?? ''),
      background: _repairImportedText(json['background'] as String? ?? ''),
      behaviorPreference: _repairImportedText(
        json['behaviorPreference'] as String? ?? '',
      ),
      dialogueExamples: _repairImportedText(
        json['dialogueExamples'] as String? ?? '',
      ),
      firstMessage: _repairImportedText(json['firstMessage'] as String? ?? ''),
      tags: (json['tags'] as List?)?.whereType<String>().toList() ?? const [],
      createdAt: json['createdAt'] as String? ?? now,
      updatedAt: json['updatedAt'] as String? ?? now,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
    'gender': gender,
    'age': age,
    'description': description,
    'persona': persona,
    'background': background,
    'behaviorPreference': behaviorPreference,
    'dialogueExamples': dialogueExamples,
    'firstMessage': firstMessage,
    'tags': tags,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  static String _repairImportedText(String value) {
    if (!RegExp(r'[ÃÂÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßà-ÿ]').hasMatch(value)) {
      return value;
    }

    try {
      final repaired = utf8.decode(latin1.encode(value));
      return repaired.contains('�') ? value : repaired;
    } catch (_) {
      return value;
    }
  }
}

class CharacterStore {
  static const _directory = 'characters';

  static Future<void> save(CharacterProfile character) async {
    await LocalDataStore.writeMap(
      '$_directory/${character.id}.json',
      character.toJson(),
    );
  }

  static Future<void> delete(String id) async {
    await LocalDataStore.deleteFile('$_directory/$id.json');
  }

  static Future<CharacterProfile?> load(String id) async {
    final json = await LocalDataStore.readMap('$_directory/$id.json');
    if (json == null) {
      return null;
    }
    return CharacterProfile.fromJson(json);
  }

  static Future<List<CharacterProfile>> loadAll() async {
    final paths = await LocalDataStore.listFiles(_directory);
    final characters = <CharacterProfile>[];
    for (final path in paths.where((path) => path.endsWith('.json'))) {
      final json = await LocalDataStore.readMap(path);
      if (json != null) {
        characters.add(CharacterProfile.fromJson(json));
      }
    }
    characters.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return characters;
  }
}

class ChatSession {
  const ChatSession({
    required this.characterId,
    required this.characterName,
    required this.characterAvatar,
    required this.recentMessage,
  });

  final String characterId;
  final String characterName;
  final String characterAvatar;
  final String recentMessage;
}

class DialogueMessage {
  const DialogueMessage({required this.role, required this.content});

  final ChatRole role;
  final String content;

  bool get mine => role == ChatRole.user;
}

class ChatSessionStore extends ChangeNotifier {
  ChatSessionStore._();

  static final ChatSessionStore instance = ChatSessionStore._();

  final Map<String, CharacterProfile> _characters = {};
  final Map<String, List<DialogueMessage>> _messages = {};
  final Map<String, DateTime> _updatedAt = {};

  List<ChatSession> get sessions {
    final ordered = _characters.values.toList()
      ..sort((a, b) {
        final aTime =
            _updatedAt[a.id] ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime =
            _updatedAt[b.id] ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

    return [
      for (final character in ordered)
        ChatSession(
          characterId: character.id,
          characterName: character.name.isEmpty ? '未命名角色' : character.name,
          characterAvatar: character.avatar,
          recentMessage: _lastMessageText(character.id),
        ),
    ];
  }

  String _lastMessageText(String characterId) {
    final messages = _messages[characterId];
    if (messages == null || messages.isEmpty) {
      return '';
    }
    return messages.last.content;
  }

  List<DialogueMessage> messagesFor(String characterId) {
    return List.unmodifiable(_messages[characterId] ?? const []);
  }

  void touchCharacter(CharacterProfile character) {
    _characters[character.id] = character;
    _updatedAt[character.id] = DateTime.now();
    notifyListeners();
  }

  void ensureOpeningMessage(CharacterProfile character) {
    touchCharacter(character);
    final opening = character.firstMessage.trim();
    if (opening.isEmpty) {
      return;
    }
    final messages = _messages.putIfAbsent(character.id, () => []);
    if (messages.isEmpty) {
      messages.add(DialogueMessage(role: ChatRole.assistant, content: opening));
      _updatedAt[character.id] = DateTime.now();
      notifyListeners();
    }
  }

  void addMessage(String characterId, DialogueMessage message) {
    _messages.putIfAbsent(characterId, () => []).add(message);
    _updatedAt[characterId] = DateTime.now();
    notifyListeners();
  }
}

class EncounterPage extends StatefulWidget {
  const EncounterPage({super.key});

  @override
  State<EncounterPage> createState() => _EncounterPageState();
}

class _EncounterPageState extends State<EncounterPage> {
  bool _menuOpen = false;
  List<CharacterProfile> _characters = const [];

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    final characters = await CharacterStore.loadAll();
    if (!mounted) {
      return;
    }
    setState(() => _characters = characters);
  }

  Future<void> _editCharacter(CharacterProfile character) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.newCharacter,
      arguments: character,
    );
    if (mounted) {
      await _loadCharacters();
    }
  }

  Future<void> _openCharacterDialogue(CharacterProfile character) async {
    ChatSessionStore.instance.ensureOpeningMessage(character);
    await Navigator.pushNamed(
      context,
      AppRoutes.dialogue,
      arguments: character,
    );
  }

  Future<void> _confirmDeleteCharacter(CharacterProfile character) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ShizukaColors.surface,
        content: Text('确定要删除这个角色吗？', style: ShizukaText.labelLarge),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              '删除',
              style: ShizukaText.labelLarge.copyWith(
                color: ShizukaColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await CharacterStore.delete(character.id);
    if (mounted) {
      await _loadCharacters();
    }
  }

  Future<void> _exportCharacter(CharacterProfile character) async {
    final fileName = _safeExportFileName(character.name);
    try {
      await LocalDataStore.exportMapToDownloads(
        fileName: fileName,
        value: character.toJson(),
      );
      if (mounted) {
        _showEncounterMessage('角色已导出到 Download 文件夹');
      }
    } catch (_) {
      if (mounted) {
        _showEncounterMessage('导出失败，请稍后再试');
      }
    }
  }

  String _safeExportFileName(String name) {
    final cleaned = name.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    return '${cleaned.isEmpty ? '角色' : cleaned}.json';
  }

  void _showEncounterMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: ShizukaText.labelLarge),
          behavior: SnackBarBehavior.floating,
          backgroundColor: ShizukaColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
  }

  void _closeMenu() {
    if (_menuOpen) {
      setState(() => _menuOpen = false);
    }
  }

  Future<void> _openCharacterFilePicker() async {
    _closeMenu();
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: '角色卡',
          extensions: ['json'],
          mimeTypes: ['application/json'],
        ),
      ],
    );

    if (file == null) {
      return;
    }

    try {
      final content = utf8.decode(
        await file.readAsBytes(),
        allowMalformed: true,
      );
      final decoded = jsonDecode(content.replaceFirst('\uFEFF', ''));
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid character json.');
      }

      final character = CharacterProfile.fromJson(decoded);
      await CharacterStore.save(character);
      if (!mounted) {
        return;
      }
      await _loadCharacters();
      _showEncounterMessage('角色导入成功');
    } catch (_) {
      if (mounted) {
        _showEncounterMessage('导入失败，请检查 json 文件');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShizukaScaffold(
      title: '相遇',
      currentTab: 1,
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '搜索角色...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: ShizukaColors.surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: ShizukaColors.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: ShizukaColors.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: _toggleMenu,
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: ShizukaColors.surfaceContainerLow,
                      foregroundColor: ShizukaColors.primary,
                      fixedSize: const Size(48, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: ShizukaColors.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Text(
                _characters.isEmpty ? '还没有遇见任何角色。' : '在宁静的午后，聆听他们的故事',
                textAlign: TextAlign.center,
                style: ShizukaText.labelLarge.copyWith(
                  color: ShizukaColors.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
              if (_characters.isNotEmpty) ...[
                const SizedBox(height: 24),
                for (final character in _characters)
                  CharacterCard(
                    name: character.name.isEmpty ? '未命名角色' : character.name,
                    tag: character.gender.isEmpty ? '角色' : character.gender,
                    desc: character.description,
                    avatar: character.avatar,
                    fallbackText: character.name.isEmpty
                        ? ''
                        : character.name.characters.first,
                    onTap: () => _openCharacterDialogue(character),
                    onEdit: () => _editCharacter(character),
                    onDelete: () => _confirmDeleteCharacter(character),
                    onExport: () => _exportCharacter(character),
                  ),
              ],
            ],
          ),
          if (_menuOpen) ...[
            Positioned(
              left: 0,
              top: 0,
              right: 88,
              height: 80,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeMenu,
              ),
            ),
            Positioned(
              left: 0,
              top: 80,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeMenu,
              ),
            ),
          ],
          Positioned(
            top: 78,
            right: 24,
            width: 176,
            child: IgnorePointer(
              ignoring: !_menuOpen,
              child: AnimatedOpacity(
                opacity: _menuOpen ? 1 : 0,
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                child: AnimatedScale(
                  scale: _menuOpen ? 1 : 0.96,
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topRight,
                  child: EncounterPopupMenu(
                    onNewCharacter: () {
                      _closeMenu();
                      Navigator.pushNamed(
                        context,
                        AppRoutes.newCharacter,
                      ).then((_) => _loadCharacters());
                    },
                    onImportCharacter: _openCharacterFilePicker,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EncounterPopupMenu extends StatelessWidget {
  const EncounterPopupMenu({
    super.key,
    required this.onNewCharacter,
    required this.onImportCharacter,
  });

  final VoidCallback onNewCharacter;
  final VoidCallback onImportCharacter;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          decoration: BoxDecoration(
            color: ShizukaColors.surface.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: ShizukaColors.outlineVariant.withValues(alpha: 0.32),
            ),
            boxShadow: [
              BoxShadow(
                color: ShizukaColors.primary.withValues(alpha: 0.14),
                blurRadius: 34,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _EncounterPopupItem(
                icon: Icons.person_add_alt_1_outlined,
                label: '新建角色',
                onTap: onNewCharacter,
              ),
              Divider(
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
                color: ShizukaColors.outlineVariant.withValues(alpha: 0.18),
              ),
              _EncounterPopupItem(
                icon: Icons.upload_file_outlined,
                label: '导入角色',
                onTap: onImportCharacter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EncounterPopupItem extends StatelessWidget {
  const _EncounterPopupItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: ShizukaColors.primary),
            const SizedBox(width: 12),
            Text(
              label,
              style: ShizukaText.labelLarge.copyWith(
                color: ShizukaColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    super.key,
    required this.name,
    required this.tag,
    required this.desc,
    required this.avatar,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onExport,
    this.fallbackText = '',
  });

  final String name;
  final String tag;
  final String desc;
  final String avatar;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onExport;
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ShizukaColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: ShizukaColors.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            if (avatar.isEmpty)
              CharacterInitialAvatar(text: fallbackText, size: 80)
            else
              Avatar(url: avatar, size: 80, radius: 16),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _compactCharacterName(name),
                        style: ShizukaText.displaySmall.copyWith(
                          color: ShizukaColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: ShizukaColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          tag,
                          style: ShizukaText.labelSmall.copyWith(
                            fontSize: 10,
                            color: ShizukaColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ShizukaText.labelSmall.copyWith(
                      color: ShizukaColors.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    _SmallRoundAction(
                      icon: Icons.edit_outlined,
                      color: ShizukaColors.primary,
                      onTap: onEdit,
                      size: 34,
                      iconSize: 18,
                    ),
                    const SizedBox(width: 6),
                    _SmallRoundAction(
                      icon: Icons.delete_outline,
                      color: ShizukaColors.error,
                      onTap: onDelete,
                      size: 34,
                      iconSize: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _SmallRoundAction(
                  icon: Icons.file_download_outlined,
                  color: ShizukaColors.primary,
                  onTap: onExport,
                  size: 34,
                  iconSize: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _compactCharacterName(String value) {
    final chars = value.characters.toList();
    if (chars.length <= 3) {
      return value;
    }
    return '${chars.take(3).join()}...';
  }
}

class CharacterInitialAvatar extends StatelessWidget {
  const CharacterInitialAvatar({
    super.key,
    required this.text,
    required this.size,
  });

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ShizukaColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        text.isEmpty ? '角' : text,
        style: ShizukaText.displaySmall.copyWith(
          color: ShizukaColors.primary,
          fontSize: 24,
        ),
      ),
    );
  }
}

class _SmallRoundAction extends StatelessWidget {
  const _SmallRoundAction({
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 40,
    this.iconSize = 20,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: iconSize),
      style: IconButton.styleFrom(
        backgroundColor: ShizukaColors.surface.withValues(alpha: 0.8),
        foregroundColor: color,
        fixedSize: Size(size, size),
        shape: const CircleBorder(side: BorderSide(color: Color(0x4DC1C8C9))),
      ),
    );
  }
}

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  UserProfile _profile = UserProfile.defaults;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileStore.load();
    if (!mounted) {
      return;
    }
    setState(() => _profile = profile);
  }

  Future<void> _openProfile() async {
    await Navigator.pushNamed(context, AppRoutes.profile);
    if (mounted) {
      await _loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _profile.name.trim();
    final hasBasicProfile =
        _profile.name.trim().isNotEmpty &&
        _profile.age.trim().isNotEmpty &&
        _profile.gender.trim().isNotEmpty;

    return ShizukaScaffold(
      title: '静谧之声',
      currentTab: 2,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          Column(
            children: [
              Avatar(url: _profile.avatarUrl, size: 96),
              const SizedBox(height: 24),
              Text(
                displayName.isEmpty ? '未设置名称' : displayName,
                style: ShizukaText.display,
              ),
              const SizedBox(height: 8),
              Text(
                hasBasicProfile ? '在静谧中寻找故事的回声' : '个人资料未填写',
                style: ShizukaText.system.copyWith(
                  color: ShizukaColors.onSurfaceVariant.withValues(alpha: 0.7),
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 64),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  MineMenuItem(
                    icon: Icons.manage_accounts_outlined,
                    label: '个人资料',
                    onTap: _openProfile,
                  ),
                  MineMenuItem(
                    icon: Icons.tune_rounded,
                    label: 'API设置',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.api),
                  ),
                  MineMenuItem(
                    icon: Icons.info_outline,
                    label: '关于',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.about),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MineMenuItem extends StatelessWidget {
  const MineMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ShizukaColors.secondaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: ShizukaColors.primary),
            ),
            const SizedBox(width: 24),
            Expanded(child: Text(label, style: ShizukaText.dialogue)),
            Icon(
              Icons.chevron_right_rounded,
              color: ShizukaColors.outlineVariant.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _ageController = TextEditingController(text: '');
  final TextEditingController _genderController = TextEditingController(
    text: '',
  );
  final TextEditingController _bioController = TextEditingController(text: '');
  final List<ProfileCustomFieldController> _customFields = [];
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _bioController.dispose();
    for (final field in _customFields) {
      field.dispose();
    }
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileStore.load();
    if (!mounted) {
      return;
    }

    setState(() {
      _nameController.text = profile.name;
      _ageController.text = profile.age;
      _genderController.text = profile.gender;
      _bioController.text = profile.bio;
      _avatarUrl = profile.avatarUrl;
      for (final field in _customFields) {
        field.dispose();
      }
      _customFields
        ..clear()
        ..addAll([
          for (final field in profile.customFields)
            ProfileCustomFieldController.fromField(field),
        ]);
    });
  }

  Future<void> _saveProfile() async {
    await ProfileStore.save(
      UserProfile(
        name: _nameController.text.trim(),
        age: _ageController.text.trim(),
        gender: _genderController.text.trim(),
        bio: _bioController.text.trim(),
        avatarUrl: _avatarUrl,
        customFields: [
          for (final field in _customFields)
            ProfileCustomField(
              label: field.labelController.text.trim(),
              value: field.valueController.text.trim(),
            ),
        ],
      ),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('保存成功', style: ShizukaText.labelLarge),
          behavior: SnackBarBehavior.floating,
          backgroundColor: ShizukaColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _chooseAvatar() async {
    final file = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(
          label: 'Images',
          extensions: ['png', 'jpg', 'jpeg', 'webp'],
          mimeTypes: ['image/png', 'image/jpeg', 'image/webp'],
        ),
      ],
    );

    if (file == null || !mounted) {
      return;
    }

    final extension = file.name.contains('.')
        ? file.name.split('.').last.toLowerCase()
        : 'png';
    final savedPath = await LocalDataStore.writeBytes(
      'profile_avatar.$extension',
      await file.readAsBytes(),
    );

    if (!mounted) {
      return;
    }

    setState(() => _avatarUrl = savedPath ?? file.path);
  }

  void _addCustomField() {
    setState(() {
      _customFields.add(ProfileCustomFieldController(label: '', value: ''));
    });
  }

  void _removeCustomField(ProfileCustomFieldController field) {
    setState(() => _customFields.remove(field));
    field.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShizukaScaffold(
      title: '个人资料',
      primaryTitle: false,
      showBottomNav: false,
      leading: SoftIconButton(
        icon: Icons.chevron_left,
        onTap: () => Navigator.pop(context),
      ),
      trailing: TextButton(
        onPressed: _saveProfile,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          '保存',
          maxLines: 1,
          softWrap: false,
          style: ShizukaText.labelLarge.copyWith(color: ShizukaColors.primary),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          ProfileAvatarBlock(avatarUrl: _avatarUrl, onTap: _chooseAvatar),
          const SizedBox(height: 48),
          MinimalInput(
            label: '姓名',
            initialValue: '',
            hintText: '请输入姓名',
            controller: _nameController,
          ),
          MinimalInput(
            label: '年龄',
            initialValue: '',
            hintText: '请输入年龄',
            controller: _ageController,
          ),
          MinimalInput(
            label: '性别',
            initialValue: '',
            hintText: '请输入性别',
            controller: _genderController,
          ),
          MinimalInput(
            label: '基本信息',
            initialValue: '',
            hintText: '请输入个人简介',
            controller: _bioController,
            maxLines: 4,
          ),
          for (final field in _customFields)
            ProfileCustomFieldEditor(
              field: field,
              onDelete: () => _removeCustomField(field),
            ),
          const SizedBox(height: 32),
          Center(child: AddFieldButton(onPressed: _addCustomField)),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '角色会在未来的故事中记住这些内容',
              textAlign: TextAlign.center,
              style: TextStyle(color: ShizukaColors.outlineVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.age,
    required this.gender,
    required this.bio,
    required this.avatarUrl,
    required this.customFields,
  });

  final String name;
  final String age;
  final String gender;
  final String bio;
  final String avatarUrl;
  final List<ProfileCustomField> customFields;

  static const defaults = UserProfile(
    name: '',
    age: '',
    gender: '',
    bio: '',
    avatarUrl: '',
    customFields: [],
  );

  factory UserProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return defaults;
    }

    return UserProfile(
      name: json['name'] as String? ?? defaults.name,
      age: json['age'] as String? ?? defaults.age,
      gender: json['gender'] as String? ?? defaults.gender,
      bio: json['bio'] as String? ?? defaults.bio,
      avatarUrl: json['avatarUrl'] as String? ?? defaults.avatarUrl,
      customFields:
          (json['customFields'] as List?)
              ?.whereType<Map>()
              .map(
                (field) => ProfileCustomField.fromJson(
                  Map<String, dynamic>.from(field),
                ),
              )
              .toList() ??
          defaults.customFields,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'gender': gender,
    'bio': bio,
    'avatarUrl': avatarUrl,
    'customFields': [for (final field in customFields) field.toJson()],
  };
}

class ProfileCustomField {
  const ProfileCustomField({required this.label, required this.value});

  final String label;
  final String value;

  factory ProfileCustomField.fromJson(Map<String, dynamic> json) {
    return ProfileCustomField(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'label': label, 'value': value};
}

class ProfileCustomFieldController {
  ProfileCustomFieldController({required String label, required String value})
    : labelController = TextEditingController(text: label),
      valueController = TextEditingController(text: value);

  factory ProfileCustomFieldController.fromField(ProfileCustomField field) {
    return ProfileCustomFieldController(label: field.label, value: field.value);
  }

  final TextEditingController labelController;
  final TextEditingController valueController;

  void dispose() {
    labelController.dispose();
    valueController.dispose();
  }
}

class ProfileStore {
  static const _path = 'profile.json';

  static Future<UserProfile> load() async {
    return UserProfile.fromJson(await LocalDataStore.readMap(_path));
  }

  static Future<void> save(UserProfile profile) async {
    await LocalDataStore.writeMap(_path, profile.toJson());
  }
}

class ProfileAvatarBlock extends StatelessWidget {
  const ProfileAvatarBlock({
    super.key,
    required this.avatarUrl,
    required this.onTap,
  });

  final String avatarUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ShizukaColors.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Avatar(url: avatarUrl, size: 128),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: ShizukaColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '点击更换头像',
          style: ShizukaText.labelSmall.copyWith(
            color: ShizukaColors.onSurfaceVariant.withValues(alpha: 0.6),
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}

class MinimalInput extends StatelessWidget {
  const MinimalInput({
    super.key,
    required this.label,
    required this.initialValue,
    this.hintText,
    this.controller,
    this.maxLines = 1,
    this.maxLength,
  });

  final String label;
  final String initialValue;
  final String? hintText;
  final TextEditingController? controller;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: maxLength == null
            ? null
            : [LengthLimitingTextInputFormatter(maxLength)],
        style: ShizukaText.dialogue.copyWith(color: ShizukaColors.onSurface),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          counterText: '',
          labelStyle: ShizukaText.displaySmall.copyWith(
            fontSize: 14,
            color: ShizukaColors.onSurfaceVariant.withValues(alpha: 0.8),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ShizukaColors.outlineVariant),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ShizukaColors.primary),
          ),
        ),
      ),
    );
  }
}

class ProfileCustomFieldEditor extends StatelessWidget {
  const ProfileCustomFieldEditor({
    super.key,
    required this.field,
    required this.onDelete,
  });

  final ProfileCustomFieldController field;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              MinimalInput(
                label: '字段名称',
                initialValue: '',
                hintText: '请输入字段名称',
                controller: field.labelController,
              ),
              MinimalInput(
                label: '字段内容',
                initialValue: '',
                hintText: '请输入字段内容',
                controller: field.valueController,
                maxLines: 3,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: _SmallRoundAction(
            icon: Icons.delete_outline,
            color: ShizukaColors.error,
            onTap: onDelete,
          ),
        ),
      ],
    );
  }
}

class AddFieldButton extends StatelessWidget {
  const AddFieldButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed ?? () {},
      icon: const Icon(Icons.add, size: 18),
      label: const Text('添加自定义字段'),
      style: TextButton.styleFrom(
        foregroundColor: ShizukaColors.primary,
        textStyle: ShizukaText.labelSmall,
      ),
    );
  }
}

class ApiSettingsPage extends StatefulWidget {
  const ApiSettingsPage({super.key});

  @override
  State<ApiSettingsPage> createState() => _ApiSettingsPageState();
}

class _ApiSettingsPageState extends State<ApiSettingsPage> {
  final TextEditingController _urlController = TextEditingController(text: '');
  final TextEditingController _apiKeyController = TextEditingController();
  bool _testing = false;
  String _selectedModel = '';
  List<String> _models = const [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final settings = await ApiSettingsStore.load();
    final savedUrl = settings.url;
    final savedApiKey = settings.apiKey;
    final savedModel = settings.model;
    final savedModels = settings.models;

    if (!mounted) {
      return;
    }

    setState(() {
      if (savedUrl != null && savedUrl.isNotEmpty) {
        _urlController.text = savedUrl;
      }
      if (savedApiKey != null) {
        _apiKeyController.text = savedApiKey;
      }
      if (savedModels != null && savedModels.isNotEmpty) {
        _models = savedModels;
      }
      if (savedModel != null && savedModel.isNotEmpty) {
        if (!_models.contains(savedModel)) {
          _models = [..._models, savedModel];
        }
        _selectedModel = savedModel;
      }
    });
  }

  Future<void> _saveSettings() async {
    final baseUrl = _normalizeBaseUrl(_urlController.text);

    if (baseUrl == null) {
      _showMessage('请输入有效的 OpenAI URL');
      return;
    }

    await ApiSettingsStore.save(
      ApiSettings(
        url: baseUrl,
        apiKey: _apiKeyController.text.trim(),
        model: _selectedModel,
        models: _models,
      ),
    );

    if (!mounted) {
      return;
    }

    _urlController.text = baseUrl;
    _showMessage('保存成功');
  }

  Future<void> _testConnection() async {
    final baseUrl = _normalizeBaseUrl(_urlController.text);
    final apiKey = _apiKeyController.text.trim();

    if (baseUrl == null) {
      _showMessage('请输入有效的 OpenAI URL');
      return;
    }

    if (apiKey.isEmpty) {
      _showMessage('请填写 API Key');
      return;
    }

    setState(() => _testing = true);
    try {
      final backend = ChatBackendFactory.create(
        baseUrl: baseUrl,
        apiKey: apiKey,
      );
      final fetchedModels = await backend.listModels();

      if (!mounted) {
        return;
      }

      setState(() {
        if (fetchedModels.isNotEmpty) {
          _models = fetchedModels;
          if (!_models.contains(_selectedModel)) {
            _selectedModel = _models.first;
          }
        }
      });
      _showMessage('连接成功');
    } catch (_) {
      if (mounted) {
        _showMessage('连接失败，请检查 URL 或密钥');
      }
    } finally {
      if (mounted) {
        setState(() => _testing = false);
      }
    }
  }

  String? _normalizeBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return null;
    }
    return trimmed.endsWith('/')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: ShizukaText.labelLarge),
          behavior: SnackBarBehavior.floating,
          backgroundColor: ShizukaColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ShizukaScaffold(
      title: 'API 设置',
      primaryTitle: false,
      showBottomNav: false,
      leading: SoftIconButton(
        icon: Icons.arrow_back,
        onTap: () => Navigator.pop(context),
      ),
      trailing: TextButton(
        onPressed: _saveSettings,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          '保存',
          maxLines: 1,
          softWrap: false,
          style: ShizukaText.labelLarge.copyWith(color: ShizukaColors.primary),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          Text(
            'Configuration',
            textAlign: TextAlign.center,
            style: ShizukaText.system.copyWith(
              color: ShizukaColors.onSurfaceVariant.withValues(alpha: 0.7),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 48,
              height: 1,
              color: ShizukaColors.primaryContainer,
            ),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ShizukaColors.outlineVariant.withValues(alpha: 0.2),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D41646B),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                SoftFilledInput(
                  label: 'OpenAI URL',
                  hint: '请输入 API 地址',
                  controller: _urlController,
                ),
                const SizedBox(height: 32),
                SoftFilledInput(
                  label: 'API Key',
                  hint: 'sk-...',
                  obscure: true,
                  controller: _apiKeyController,
                ),
                const SizedBox(height: 32),
                SoftModelDropdown(
                  models: _models,
                  value: _selectedModel,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedModel = value);
                    }
                  },
                ),
                const SizedBox(height: 28),
                TestConnectionButton(
                  testing: _testing,
                  onPressed: _testing ? null : _testConnection,
                ),
              ],
            ),
          ),
          const SizedBox(height: 56),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class ApiSettings {
  const ApiSettings({
    required this.url,
    required this.apiKey,
    required this.model,
    required this.models,
  });

  final String? url;
  final String? apiKey;
  final String? model;
  final List<String>? models;
}

class ApiSettingsStore {
  static const _path = 'api_settings.json';

  static Future<ApiSettings> load() async {
    final result = await LocalDataStore.readMap(_path);
    return ApiSettings(
      url: result?['url'] as String?,
      apiKey: result?['apiKey'] as String?,
      model: result?['model'] as String?,
      models: (result?['models'] as List?)?.whereType<String>().toList(),
    );
  }

  static Future<void> save(ApiSettings settings) async {
    await LocalDataStore.writeMap(_path, {
      'url': settings.url,
      'apiKey': settings.apiKey,
      'model': settings.model,
      'models': settings.models,
    });
  }
}

class SoftFilledInput extends StatelessWidget {
  const SoftFilledInput({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscure = false,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: ShizukaText.labelLarge.copyWith(
          color: ShizukaColors.onSurfaceVariant,
        ),
        filled: true,
        fillColor: ShizukaColors.surfaceContainerLowest.withValues(alpha: 0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ShizukaColors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ShizukaColors.primaryContainer),
        ),
      ),
    );
  }
}

class SoftModelDropdown extends StatelessWidget {
  const SoftModelDropdown({
    super.key,
    required this.models,
    required this.value,
    required this.onChanged,
  });

  final List<String> models;
  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      initialValue: models.contains(value) ? value : models.firstOrNull,
      hint: Text(
        '请输入模型名称',
        style: ShizukaText.dialogue.copyWith(
          color: ShizukaColors.outline.withValues(alpha: 0.7),
        ),
      ),
      selectedItemBuilder: (context) => [
        for (final model in models)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              model,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
      ],
      items: [
        for (final model in models)
          DropdownMenuItem<String>(
            value: model,
            child: Text(
              model,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: '模型选择',
        labelStyle: ShizukaText.labelLarge.copyWith(
          color: ShizukaColors.onSurfaceVariant,
        ),
        filled: true,
        fillColor: ShizukaColors.surfaceContainerLowest.withValues(alpha: 0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ShizukaColors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ShizukaColors.primaryContainer),
        ),
      ),
      dropdownColor: ShizukaColors.surface,
      style: ShizukaText.dialogue.copyWith(color: ShizukaColors.onSurface),
      iconEnabledColor: ShizukaColors.onSurfaceVariant,
      borderRadius: BorderRadius.circular(12),
    );
  }
}

class TestConnectionButton extends StatelessWidget {
  const TestConnectionButton({
    super.key,
    required this.testing,
    required this.onPressed,
  });

  final bool testing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(testing ? Icons.refresh : Icons.bolt, size: 20),
      label: Text(testing ? '正在测试...' : '测试连接'),
      style: OutlinedButton.styleFrom(
        foregroundColor: ShizukaColors.primary,
        backgroundColor: ShizukaColors.primaryContainer.withValues(alpha: 0.1),
        side: BorderSide(
          color: ShizukaColors.primaryContainer.withValues(alpha: 0.4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: ShizukaText.labelLarge,
      ),
    );
  }
}

class MemoriesPage extends StatelessWidget {
  const MemoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShizukaScaffold(
      title: '回忆',
      showBottomNav: false,
      leading: SoftIconButton(
        icon: Icons.chevron_left,
        onTap: () => Navigator.pop(context),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          const SizedBox(height: 120),
          Text(
            '还没有留下回忆。',
            textAlign: TextAlign.center,
            style: ShizukaText.system.copyWith(
              color: ShizukaColors.outline.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class MemoryCard extends StatelessWidget {
  const MemoryCard({
    super.key,
    required this.chapter,
    required this.title,
    required this.body,
    required this.icon,
  });

  final String chapter;
  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 48),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ShizukaColors.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: ShizukaColors.primary.withValues(alpha: 0.05),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: ShizukaColors.secondaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: ShizukaColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              chapter,
              style: ShizukaText.labelSmall.copyWith(
                color: ShizukaColors.primary,
                letterSpacing: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: ShizukaText.displaySmall.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 14),
          Text(
            body,
            textAlign: TextAlign.center,
            style: ShizukaText.dialogue.copyWith(
              color: ShizukaColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Line(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(icon, size: 15, color: ShizukaColors.outline),
              ),
              _Line(),
            ],
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 1,
      color: ShizukaColors.outlineVariant.withValues(alpha: 0.5),
    );
  }
}

class DialoguePage extends StatefulWidget {
  const DialoguePage({super.key});

  @override
  State<DialoguePage> createState() => _DialoguePageState();
}

class _DialoguePageState extends State<DialoguePage> {
  final TextEditingController _inputController = TextEditingController();
  CharacterProfile? _character;
  String _userAvatarUrl = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    ChatSessionStore.instance.addListener(_refresh);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is CharacterProfile && _character?.id != arguments.id) {
      _loadCharacter(arguments);
    }
  }

  @override
  void dispose() {
    ChatSessionStore.instance.removeListener(_refresh);
    _inputController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadCharacter(CharacterProfile initialCharacter) async {
    final latest = await CharacterStore.load(initialCharacter.id);
    final profile = await ProfileStore.load();
    if (!mounted) {
      return;
    }
    final character = latest ?? initialCharacter;
    setState(() {
      _character = character;
      _userAvatarUrl = profile.avatarUrl;
    });
    ChatSessionStore.instance.ensureOpeningMessage(character);
  }

  Future<void> _sendMessage() async {
    final character = _character;
    final text = _inputController.text.trim();
    if (character == null || text.isEmpty || _loading) {
      return;
    }

    _inputController.clear();
    ChatSessionStore.instance.touchCharacter(character);
    ChatSessionStore.instance.addMessage(
      character.id,
      DialogueMessage(role: ChatRole.user, content: text),
    );

    setState(() => _loading = true);
    try {
      final settings = await ApiSettingsStore.load();
      final baseUrl = settings.url?.trim() ?? '';
      final apiKey = settings.apiKey?.trim() ?? '';
      final model = settings.model?.trim() ?? '';
      if (baseUrl.isEmpty || model.isEmpty) {
        throw const ChatApiException('Missing API settings');
      }

      final backend = ChatBackendFactory.create(
        baseUrl: baseUrl,
        apiKey: apiKey,
      );
      final response = await backend.createChatCompletion(
        ChatRequest(
          model: model,
          messages: [
            ChatMessage(
              role: ChatRole.system,
              content: _buildSystemPrompt(character),
            ),
            for (final message in ChatSessionStore.instance.messagesFor(
              character.id,
            ))
              ChatMessage(role: message.role, content: message.content),
          ],
        ),
      );
      final reply = response.text.trim();
      if (reply.isNotEmpty) {
        ChatSessionStore.instance.addMessage(
          character.id,
          DialogueMessage(role: ChatRole.assistant, content: reply),
        );
      }
    } catch (_) {
      if (mounted) {
        _showDialogueMessage('连接似乎暂时没有回应。');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _buildSystemPrompt(CharacterProfile character) {
    return '''
你正在扮演一个角色。

角色姓名：${character.name}
性别：${character.gender}
年龄：${character.age}

角色人设：
${character.persona}

背景设定：
${character.background}

行为偏好：
${character.behaviorPreference}

对话示例：
${character.dialogueExamples}

请始终保持角色身份、语气和行为方式。
不要跳出角色。
不要提及你是 AI 或语言模型。
根据用户输入自然回应。''';
  }

  void _showDialogueMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: ShizukaText.labelLarge),
          behavior: SnackBarBehavior.floating,
          backgroundColor: ShizukaColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final character = _character;
    final messages = character == null
        ? const <DialogueMessage>[]
        : ChatSessionStore.instance.messagesFor(character.id);
    return ShizukaScaffold(
      title: character?.name.isNotEmpty == true ? character!.name : '角色对话',
      showBottomNav: false,
      leading: SoftIconButton(
        icon: Icons.arrow_back,
        onTap: () => Navigator.pop(context),
      ),
      trailing: SoftIconButton(
        icon: Icons.person_outline,
        onTap: () => Navigator.pushNamed(context, AppRoutes.memories),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              children: [
                if (messages.isEmpty) ...[
                  const SizedBox(height: 120),
                  Text(
                    '还没有对话内容。',
                    textAlign: TextAlign.center,
                    style: ShizukaText.system.copyWith(
                      color: ShizukaColors.outline.withValues(alpha: 0.6),
                    ),
                  ),
                ] else ...[
                  for (final message in messages)
                    MessageBubble(
                      sender: message.mine ? '我' : character?.name ?? '',
                      body: message.content,
                      avatar: message.mine
                          ? _userAvatarUrl
                          : character?.avatar ?? '',
                      mine: message.mine,
                    ),
                ],
              ],
            ),
          ),
          DialogueInputBar(
            controller: _inputController,
            loading: _loading,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sender,
    required this.body,
    required this.avatar,
    this.mine = false,
  });

  final String sender;
  final String body;
  final String avatar;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mine
            ? ShizukaColors.primaryContainer
            : ShizukaColors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(mine ? 24 : 4),
          topRight: Radius.circular(mine ? 4 : 24),
          bottomLeft: const Radius.circular(24),
          bottomRight: const Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: ShizukaColors.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        body,
        style: ShizukaText.dialogue.copyWith(
          color: mine
              ? ShizukaColors.onPrimaryContainer
              : ShizukaColors.onSurface,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: mine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!mine) Avatar(url: avatar, size: 40),
          if (!mine) const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: mine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    sender,
                    style: ShizukaText.labelSmall.copyWith(
                      fontFamily: mine ? 'Plus Jakarta Sans' : 'Noto Serif SC',
                      color: ShizukaColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                bubble,
              ],
            ),
          ),
          if (mine) const SizedBox(width: 16),
          if (mine) Avatar(url: avatar, size: 40),
        ],
      ),
    );
  }
}

class DialogueInputBar extends StatelessWidget {
  const DialogueInputBar({
    super.key,
    required this.controller,
    required this.loading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool loading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            24,
            16,
            24,
            16 + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: BoxDecoration(
            color: ShizukaColors.surface.withValues(alpha: 0.82),
            border: Border(
              top: BorderSide(
                color: ShizukaColors.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !loading,
                  minLines: 1,
                  maxLines: 3,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) {
                    if (!loading) {
                      onSend();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '请输入消息',
                    filled: true,
                    fillColor: ShizukaColors.surfaceContainerLow,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                      borderSide: BorderSide(
                        color: ShizukaColors.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                      borderSide: BorderSide(
                        color: ShizukaColors.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: loading ? null : onSend,
                icon: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
                style: IconButton.styleFrom(
                  foregroundColor: ShizukaColors.primary,
                  backgroundColor: ShizukaColors.primary.withValues(alpha: 0.1),
                  fixedSize: const Size(52, 52),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewCharacterPage extends StatefulWidget {
  const NewCharacterPage({super.key});

  @override
  State<NewCharacterPage> createState() => _NewCharacterPageState();
}

class _NewCharacterPageState extends State<NewCharacterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _personaController = TextEditingController();
  final TextEditingController _backgroundController = TextEditingController();
  final TextEditingController _behaviorController = TextEditingController();
  final TextEditingController _dialogueExamplesController =
      TextEditingController();
  String _avatar = '';
  CharacterProfile? _editingCharacter;
  bool _loadedArguments = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedArguments) {
      return;
    }
    _loadedArguments = true;
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is CharacterProfile) {
      _editingCharacter = arguments;
      _nameController.text = arguments.name;
      _genderController.text = arguments.gender;
      _ageController.text = arguments.age;
      _descriptionController.text = arguments.description;
      _personaController.text = arguments.persona;
      _backgroundController.text = arguments.background;
      _behaviorController.text = arguments.behaviorPreference;
      _dialogueExamplesController.text = arguments.dialogueExamples;
      _avatar = arguments.avatar;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _personaController.dispose();
    _backgroundController.dispose();
    _behaviorController.dispose();
    _dialogueExamplesController.dispose();
    super.dispose();
  }

  Future<void> _chooseAvatar() async {
    final file = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(
          label: 'Images',
          extensions: ['png', 'jpg', 'jpeg', 'webp'],
          mimeTypes: ['image/png', 'image/jpeg', 'image/webp'],
        ),
      ],
    );

    if (file == null || !mounted) {
      return;
    }

    final extension = file.name.contains('.')
        ? file.name.split('.').last.toLowerCase()
        : 'png';
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final savedPath = await LocalDataStore.writeBytes(
      'characters/$id.$extension',
      await file.readAsBytes(),
    );

    if (!mounted) {
      return;
    }

    setState(() => _avatar = savedPath ?? file.path);
  }

  Future<void> _saveCharacter() async {
    final now = DateTime.now().toIso8601String();
    final existing = _editingCharacter;
    final id = existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString();

    await CharacterStore.save(
      CharacterProfile(
        id: id,
        name: _nameController.text.trim(),
        avatar: _avatar,
        gender: _genderController.text.trim(),
        age: _ageController.text.trim(),
        description: _descriptionController.text.trim(),
        persona: _personaController.text.trim(),
        background: _backgroundController.text.trim(),
        behaviorPreference: _behaviorController.text.trim(),
        dialogueExamples: _dialogueExamplesController.text.trim(),
        firstMessage: existing?.firstMessage ?? '',
        tags: existing?.tags ?? const [],
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShizukaScaffold(
      title: _editingCharacter == null ? '新建角色' : '修改角色',
      primaryTitle: false,
      showBottomNav: false,
      leading: SoftIconButton(
        icon: Icons.arrow_back_ios_new,
        onTap: () => Navigator.pop(context),
      ),
      trailing: TextButton(
        onPressed: _saveCharacter,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          '保存',
          maxLines: 1,
          softWrap: false,
          style: ShizukaText.labelLarge.copyWith(color: ShizukaColors.primary),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: _Glow(color: ShizukaColors.primaryContainer),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: _Glow(color: ShizukaColors.secondaryContainer),
          ),
          ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            children: [
              AvatarUpload(avatar: _avatar, onTap: _chooseAvatar),
              const SizedBox(height: 40),
              MinimalInput(
                label: '角色姓名',
                initialValue: '',
                hintText: '请输入角色名',
                controller: _nameController,
              ),
              MinimalInput(
                label: '性别',
                initialValue: '',
                hintText: '请输入性别',
                controller: _genderController,
              ),
              MinimalInput(
                label: '年龄',
                initialValue: '',
                hintText: '请输入年龄',
                controller: _ageController,
              ),
              MinimalInput(
                label: '简介',
                initialValue: '',
                hintText: '请输入角色简介',
                controller: _descriptionController,
                maxLines: 2,
                maxLength: 120,
              ),
              const SectionDivider(label: '详细设定'),
              EditorBlock(
                icon: Icons.auto_awesome,
                title: '角色人设',
                hint: '描述这个角色的身份、性格特质、说话方式。',
                controller: _personaController,
                maxLength: 1200,
              ),
              EditorBlock(
                icon: Icons.history_edu,
                title: '背景设定',
                hint: '补充世界观、来历、关键经历，可留空。',
                controller: _backgroundController,
                maxLength: 1200,
                lines: 4,
              ),
              EditorBlock(
                icon: Icons.chat_bubble_outline,
                title: '行为偏好',
                hint: '说话风格、习惯用语、避免提到的话题，可留空。',
                controller: _behaviorController,
                maxLength: 1000,
              ),
              EditorBlock(
                icon: Icons.forum_outlined,
                title: '对话示例',
                hint: '可选。给模型1-3段示例对话锚定语气。建议格式：\n用户：今天好累不想上班\n你：那就早点睡，明天再说',
                controller: _dialogueExamplesController,
                maxLength: 800,
                lines: 4,
              ),
              const SizedBox(height: 16),
              const Center(child: AddFieldButton()),
            ],
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.24),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 120),
        ],
      ),
    );
  }
}

class AvatarUpload extends StatelessWidget {
  const AvatarUpload({super.key, this.avatar = '', this.onTap});

  final String avatar;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            color: ShizukaColors.surfaceContainerLowest,
            shape: BoxShape.circle,
            border: Border.all(
              color: ShizukaColors.outlineVariant,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: avatar.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      color: ShizukaColors.outlineVariant,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '点击上传',
                      style: ShizukaText.labelSmall.copyWith(
                        color: ShizukaColors.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                )
              : Avatar(url: avatar, size: 112),
        ),
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(height: 1, color: ShizukaColors.outlineVariant),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: ShizukaText.labelSmall.copyWith(
                fontFamily: 'Noto Serif SC',
                letterSpacing: 2.4,
                color: ShizukaColors.onSurfaceVariant.withValues(alpha: 0.45),
              ),
            ),
          ),
          Expanded(
            child: Container(height: 1, color: ShizukaColors.outlineVariant),
          ),
        ],
      ),
    );
  }
}

class EditorBlock extends StatefulWidget {
  const EditorBlock({
    super.key,
    required this.icon,
    required this.title,
    required this.hint,
    required this.controller,
    required this.maxLength,
    this.lines = 3,
  });

  final IconData icon;
  final String title;
  final String hint;
  final TextEditingController controller;
  final int maxLength;
  final int lines;

  @override
  State<EditorBlock> createState() => _EditorBlockState();
}

class _EditorBlockState extends State<EditorBlock> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refreshCount);
  }

  @override
  void didUpdateWidget(EditorBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_refreshCount);
      widget.controller.addListener(_refreshCount);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refreshCount);
    super.dispose();
  }

  void _refreshCount() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          Row(
            children: [
              Icon(widget.icon, size: 18, color: ShizukaColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: ShizukaText.labelLarge.copyWith(
                    color: ShizukaColors.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                '${widget.controller.text.length}/${widget.maxLength}',
                style: ShizukaText.labelSmall.copyWith(
                  color: ShizukaColors.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: widget.controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.maxLength),
            ],
            minLines: widget.lines,
            maxLines: widget.lines,
            decoration: InputDecoration(
              hintText: widget.hint,
              filled: true,
              fillColor: ShizukaColors.surfaceContainerLowest.withValues(
                alpha: 0.5,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: ShizukaColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShizukaScaffold(
      title: '关于',
      primaryTitle: false,
      showBottomNav: false,
      leading: SoftIconButton(
        icon: Icons.arrow_back,
        onTap: () => Navigator.pop(context),
        color: ShizukaColors.onSurfaceVariant,
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ShizukaColors.primaryContainer.withValues(alpha: 0.08),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '这是一份只属于你的故事',
                    textAlign: TextAlign.center,
                    style: ShizukaText.display.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 4.5,
                      color: ShizukaColors.primary.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '愿每一次相遇，都能成为值得回忆的故事。',
                    textAlign: TextAlign.center,
                    style: ShizukaText.display.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 4.5,
                      color: ShizukaColors.primary.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Column(
              children: [
                Text(
                  'Version 1.0.0',
                  style: ShizukaText.labelSmall.copyWith(
                    color: ShizukaColors.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'GitHub',
                  style: ShizukaText.labelSmall.copyWith(
                    color: ShizukaColors.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
