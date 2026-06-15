import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api/chat_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

const _avatarAyane =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBOQ6MNr4jpNI_EbHaYpHU-Upy_-0o06WYbiUTbhCHJTT9NufTW-mLoFv7ORBht6ivbQ13Z7xiwuZIThRJO7X7NyenNBUcEd2PS2echMZuj0BHFvaFRCBLzxPWEnd2nDb53ZAdXp4wuQkEXEZj2gODmPXGUoN4MRC-QyDfHskzgtxNfuIhcXBlPn_Qx9pxxdQ3aqdZE9mKiBfJNCqYOLmmknyuhpl9Uc3v5eex-oGpZtwKs4eYIWgZ2RVmxRre_FdkGjSNozdofng8';
const _avatarSousuke =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAb0KqjHQYRSOszbIjn2Ort7MTVaXOOLuL26S-VXXHsqyd4arh0nOD4ioOGRHzmH7nS3I_9rqh1jrqL_VoHPJcqYtxPxl2nquJBgQzyO2v6J0b3YOOFAMB8p5_8XyHAMVeWpDpUlvBX9TUxMINPLH4ZIZ0V34ORPdwZVQUVz4Q_HG82cdZSqAUdSav52n02-7JRe1Et3A2eVijIqkGxsXLQzHX3tRKSNSz1DkdiCLOSI9gG28kZz0BrP9v5XmH94f8tWW2HDRjdvjM';
const _avatarYui =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDWCrKGRsS0pAAo_PyXk7ZTY6nGFig61BE_Suu9TmxsVsxk33rkjz2ohFFq1tIOxqqr5EIY-usDza-pjzAD-57r9hEt_is8kFI7cwusWrl7ali4nzo6B1ozaGuWhPAECm7cs5LZgXOdN0ruK5r9lgUfBIvr5WBnYVBqi66YHI9WlpX6p7JoO9jD_72244Em3GenHn48tGq0MJA6rdbApLlVcqNpexj76WNeGNnyE76H2hRwl_obLD4gHoBdrzvKv01ZPRdgFsrvahk';
const _avatarRui =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuB2857dp382p-feA4dZi1DR7KyY7sOVQmPrg8Tfys54o8iH1MgBc-v-fVp3xVF3LjH0kqUQXxdq87x_uByzqco__OE6_3Hlp6OmN86Y2xQhBkUFS-RTQ81LhzVX2wU2w-xC40pXqzdwEbyqoAhQl8bwlVJPti1KSE6qezh4KQg4NXdYtQaxSdaeaVodtUIOU-DX-NEvMdX02G9Cted72y8q-ArPySiy9g_jwjV919lJ4ZVnhWz-TXI-JE0Qi_22zwLZfZpDVwNoV9U';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? size / 2),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: size,
          height: size,
          color: ShizukaColors.surfaceContainerHigh,
          child: Icon(
            Icons.person,
            color: ShizukaColors.outline,
            size: size / 2,
          ),
        ),
      ),
    );
  }
}

class ChatHomePage extends StatelessWidget {
  const ChatHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShizukaScaffold(
      title: '消息',
      currentTab: 0,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 28),
        children: [
          ChatListTile(
            name: '绫音 (Ayane)',
            time: '刚刚',
            message: '“今天外面的阳光很好，你想一起去散步吗？”',
            avatar: _avatarAyane,
            online: true,
            onTap: () => Navigator.pushNamed(context, AppRoutes.dialogue),
          ),
          const SizedBox(height: 16),
          ChatListTile(
            name: '苍介 (Sousuke)',
            time: '昨天',
            message: '“那本书的结局，确实让人意外。我还需要些时间消化。”',
            avatar: _avatarSousuke,
            unread: true,
            onTap: () => Navigator.pushNamed(context, AppRoutes.dialogue),
          ),
          const SizedBox(height: 16),
          ChatListTile(
            name: '结衣 (Yui)',
            time: '星期二',
            message: '“谢谢你听我抱怨，感觉好多了！”',
            avatar: _avatarYui,
            onTap: () => Navigator.pushNamed(context, AppRoutes.dialogue),
          ),
          const SizedBox(height: 32),
          Text(
            '没有更多回忆了...',
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

class EncounterPage extends StatefulWidget {
  const EncounterPage({super.key});

  @override
  State<EncounterPage> createState() => _EncounterPageState();
}

class _EncounterPageState extends State<EncounterPage> {
  bool _menuOpen = false;

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
    await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: '角色卡',
          extensions: ['png', 'json'],
          mimeTypes: ['image/png', 'application/json'],
        ),
      ],
    );
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
                '在宁静的午后，聆听他们的故事。',
                textAlign: TextAlign.center,
                style: ShizukaText.labelLarge.copyWith(
                  color: ShizukaColors.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 44),
              CharacterCard(
                name: '夏织',
                tag: '温柔',
                desc: '在宁静的午后，聆听她的故事。',
                avatar: _avatarAyane,
              ),
              CharacterCard(
                name: '苍介',
                tag: '冷静',
                desc: '智慧与理性的化身，静候交流。',
                avatar: _avatarSousuke,
              ),
              CharacterCard(
                name: '阳子',
                tag: '开朗',
                desc: '如阳光般灿烂，带给你无尽活力。',
                avatar: _avatarYui,
              ),
              CharacterCard(
                name: '雪绪',
                tag: '神秘',
                desc: '月光下的秘密，等待你来揭开。',
                avatar: _avatarRui,
              ),
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
                      Navigator.pushNamed(context, AppRoutes.newCharacter);
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
  });

  final String name;
  final String tag;
  final String desc;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Avatar(url: avatar, size: 80, radius: 16),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
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
          Row(
            children: [
              _SmallRoundAction(
                icon: Icons.edit_outlined,
                color: ShizukaColors.primary,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.newCharacter),
              ),
              const SizedBox(width: 8),
              _SmallRoundAction(
                icon: Icons.delete_outline,
                color: ShizukaColors.error,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallRoundAction extends StatelessWidget {
  const _SmallRoundAction({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: ShizukaColors.surface.withValues(alpha: 0.8),
        foregroundColor: color,
        fixedSize: const Size(40, 40),
        shape: const CircleBorder(side: BorderSide(color: Color(0x4DC1C8C9))),
      ),
    );
  }
}

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShizukaScaffold(
      title: '静谧之声',
      currentTab: 2,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          Column(
            children: [
              Avatar(url: _avatarAyane, size: 96),
              const SizedBox(height: 24),
              Text('流浪的旅人', style: ShizukaText.display),
              const SizedBox(height: 8),
              Text(
                '在静谧中寻找故事的回声',
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
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.profile),
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
        onPressed: () {},
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
        children: const [
          ProfileAvatarBlock(),
          SizedBox(height: 48),
          MinimalInput(label: '姓名', initialValue: '静花'),
          MinimalInput(label: '年龄', initialValue: '19'),
          MinimalInput(label: '性别', initialValue: '女'),
          MinimalInput(
            label: '基本信息',
            initialValue: '喜欢在午后的图书馆角落看书，享受宁静的时刻。对文字有着天然的亲近感，希望能在这里遇到志同道合的朋友。',
            maxLines: 4,
          ),
          SizedBox(height: 32),
          Center(child: AddFieldButton()),
          SizedBox(height: 20),
          Center(
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

class ProfileAvatarBlock extends StatelessWidget {
  const ProfileAvatarBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
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
              child: const Avatar(url: _avatarAyane, size: 128),
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
    this.maxLines = 1,
  });

  final String label;
  final String initialValue;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        style: ShizukaText.dialogue.copyWith(color: ShizukaColors.onSurface),
        decoration: InputDecoration(
          labelText: label,
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

class AddFieldButton extends StatelessWidget {
  const AddFieldButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
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
  final TextEditingController _urlController = TextEditingController(
    text: 'https://api.openai.com/v1',
  );
  final TextEditingController _apiKeyController = TextEditingController();
  bool _testing = false;
  String _selectedModel = 'gpt-4o';
  List<String> _models = const [
    'gpt-4o',
    'gpt-4.1',
    'gpt-4.1-mini',
    'gpt-4o-mini',
  ];

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
                  hint: 'https://api.openai.com/v1',
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
          Text(
            '“于静谧之中，聆听代码的低语。”',
            textAlign: TextAlign.center,
            style: ShizukaText.displaySmall.copyWith(
              fontSize: 14,
              color: ShizukaColors.onSurfaceVariant.withValues(alpha: 0.4),
              fontStyle: FontStyle.italic,
            ),
          ),
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
  static const _channel = MethodChannel('com.shizuka.app/api_settings');
  static ApiSettings? _fallback;

  static Future<ApiSettings> load() async {
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>('load');
      return ApiSettings(
        url: result?['url'] as String?,
        apiKey: result?['apiKey'] as String?,
        model: result?['model'] as String?,
        models: (result?['models'] as List?)?.whereType<String>().toList(),
      );
    } on MissingPluginException {
      return _fallback ??
          const ApiSettings(url: null, apiKey: null, model: null, models: null);
    }
  }

  static Future<void> save(ApiSettings settings) async {
    _fallback = settings;
    try {
      await _channel.invokeMethod<void>('save', {
        'url': settings.url,
        'apiKey': settings.apiKey,
        'model': settings.model,
        'models': settings.models,
      });
    } on MissingPluginException {
      return;
    }
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
        children: const [
          Text(
            '那些被光影镌刻的无声对白',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Noto Serif SC',
              fontSize: 14,
              letterSpacing: 2.8,
              fontStyle: FontStyle.italic,
              color: Color(0x9941484A),
            ),
          ),
          SizedBox(height: 52),
          MemoryCard(
            chapter: 'Chapter 01',
            title: '尘埃落定的午后',
            body: '阳光穿透了百叶窗的缝隙，在这间只有纸张翻动声的屋子里，时间仿佛失去了流逝的意义。那是我第一次，听懂了沉默。',
            icon: Icons.local_library,
          ),
          MemoryCard(
            chapter: 'Chapter 03',
            title: '雨水模糊的边界',
            body:
                '杯中的咖啡渐渐失去温度，窗外的世界被雨水涂抹成抽象的画作。你没有说话，只是静静地看着玻璃上的倒影，那一刻，世界变得很小。',
            icon: Icons.water_drop_outlined,
          ),
          MemoryCard(
            chapter: 'Chapter 05',
            title: '未奏响的休止符',
            body: '空旷的礼堂里，黑白琴键反射着微弱的光。没有旋律响起，但空气中却弥漫着某种即将倾诉的情感，比任何音乐都更加震耳欲聋。',
            icon: Icons.music_note,
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

class DialoguePage extends StatelessWidget {
  const DialoguePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShizukaScaffold(
      title: '花泽类',
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
              children: const [
                Center(
                  child: Text(
                    '10月15日 下午 4:30',
                    style: TextStyle(color: Color(0x9941484A), fontSize: 13),
                  ),
                ),
                SizedBox(height: 32),
                MessageBubble(
                  sender: '花泽类',
                  body: '窗外的阳光很好，适合安静地看书。\n你今天过得怎么样？',
                  avatar: _avatarRui,
                ),
                MessageBubble(
                  sender: '我',
                  body: '还不错。只是一直在想，如果是你，会推荐我看哪本书。',
                  avatar: _avatarAyane,
                  mine: true,
                ),
                MessageBubble(
                  sender: '花泽类',
                  body: '我会推荐那本关于时间与等待的诗集。\n就像现在的午后一样，静谧而漫长。',
                  avatar: _avatarRui,
                ),
              ],
            ),
          ),
          const DialogueInputBar(),
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
  const DialogueInputBar({super.key});

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
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'ddd',
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
                onPressed: () {},
                icon: const Icon(Icons.send_rounded),
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

class NewCharacterPage extends StatelessWidget {
  const NewCharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShizukaScaffold(
      title: '新建角色',
      primaryTitle: false,
      showBottomNav: false,
      leading: SoftIconButton(
        icon: Icons.arrow_back_ios_new,
        onTap: () => Navigator.pop(context),
      ),
      trailing: TextButton(
        onPressed: () {},
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
            children: const [
              AvatarUpload(),
              SizedBox(height: 40),
              MinimalInput(label: '角色姓名', initialValue: ''),
              MinimalInput(label: '角色称呼 / 头衔', initialValue: ''),
              SectionDivider(label: '详细设定'),
              EditorBlock(
                icon: Icons.auto_awesome,
                title: '角色性格',
                hint: '描述角色的核心气质与性格走向...',
              ),
              EditorBlock(
                icon: Icons.history_edu,
                title: '世界观背景 / 经历',
                hint: '角色从何处来，曾经历过哪些足以改变人生的事件？',
                lines: 4,
              ),
              EditorBlock(
                icon: Icons.chat_bubble_outline,
                title: '语言风格 / 口头禅',
                hint: '角色的说话方式。是温文尔雅，还是充满锐气？',
              ),
              SizedBox(height: 16),
              Center(child: AddFieldButton()),
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
  const AvatarUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
        child: Column(
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
                color: ShizukaColors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
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

class EditorBlock extends StatelessWidget {
  const EditorBlock({
    super.key,
    required this.icon,
    required this.title,
    required this.hint,
    this.lines = 3,
  });

  final IconData icon;
  final String title;
  final String hint;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: ShizukaColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: ShizukaText.labelLarge.copyWith(
                    color: ShizukaColors.onSurfaceVariant,
                  ),
                ),
              ),
              Icon(
                Icons.close,
                size: 20,
                color: ShizukaColors.onSurfaceVariant.withValues(alpha: 0.4),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            minLines: lines,
            maxLines: lines,
            decoration: InputDecoration(
              hintText: hint,
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
