import 'package:flutter_ics_homescreen/export.dart';

import '../../common_widget/voice_assistant_button.dart';
// import 'package:media_kit_video/media_kit_video.dart';

/// 背景画像（静止画）
final bkgImageProvider = Provider((ref) {
  return Container(
    width: 1080,
    height: 1920,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/BG_Sequence_00000.png"),
        fit: BoxFit.cover,
      ),
    ),
  );
});

/// 背景アニメーション（Lottie）
final bkgAnimationProvider = Provider((ref) {
  return Lottie.asset(
    'animations/BG-dotwaveform.json',
    fit: BoxFit.cover,
    repeat: true,
  );
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    ref.read(appLauncherProvider).run();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appProvider);
        final bool disableBkgAnimation =
            ref.watch(appConfigProvider).disableBkgAnimation;
        final bool plainBackground =
            ref.watch(appConfigProvider).plainBackground;

        // デザイン上の想定サイズ（この枠の中に全部レイアウトする）
        // ★ ここを 1280 x 960 にして「縦方向に余裕を持たせる」
        const designSize = Size(1280, 960);

        return Scaffold(
          key: homeScaffoldKey,
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: const CustomTopBar(),
          body: LayoutBuilder(
            builder: (context, constraints) {
              // 1280x960 の画面をまるごと縮小して収める
              return FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: designSize.width,
                  height: designSize.height,
                  child: Stack(
                    children: [
                      // 背景
                      if (!disableBkgAnimation)
                        ref.watch(bkgAnimationProvider)
                      else if (!plainBackground)
                        ref.watch(bkgImageProvider),

                      // 画面内容（ページ遷移）
                      FlowBuilder<AppState>(
                        state: appState,
                        onGeneratePages: onGenerateAppViewPages,
                        observers: [
                          HeroController(),
                        ],
                      ),

                      // 左側のボリューム & ファン
                      if (appState != AppState.splash)
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.only(left: 8),
                            height: 500,
                            child: const VolumeFanControl(),
                          ),
                        ),

                      // ボイスアシスタントボタン
                      if (appState != AppState.splash &&
                          ref.watch(
                            voiceAssistantStateProvider.select(
                              (value) => value.isVoiceAssistantEnable,
                            ),
                          ))
                        Positioned(
                          // 設計サイズ 960 の 82% 位置に配置
                          top: designSize.height * 0.82,
                          left: 8,
                          child: const VoiceAssistantButton(),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar:
              appState == AppState.splash ? null : const CustomBottomBar(),
        );
      },
    );
  }
}
