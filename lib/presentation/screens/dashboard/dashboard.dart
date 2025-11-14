import '/export.dart';
import 'widgets/dashboard_content.dart';

/// 中央のメーター（車＋円＋バッテリーバー）全体の縮小率
/// ※ 今は 0.75（元の 75% の大きさ）
const double kDashboardScale = 0.75;

class DasboardPage extends ConsumerWidget {
  const DasboardPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: DasboardPage());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // 中央のグリッドっぽい背景テクスチャ
        Align(
          alignment: Alignment.center,
          child: Padding(
            // もとの 150 から 110 に減らして、全体を少し上に寄せる
            padding: const EdgeInsets.only(top: 110.0),
            child: SvgPicture.asset(
              'assets/dashboardTextures.svg',
              alignment: Alignment.center,
            ),
          ),
        ),

        // 中央のメーター本体（ここをまとめて縮小＋上に寄せる）
        Padding(
          // もとの vertical: 50 を 10 にして、下の余白をかなり減らす
          padding: const EdgeInsets.fromLTRB(140.0, 10.0, 140.0, 0.0),
          child: Transform.scale(
            scale: kDashboardScale,
            alignment: Alignment.center,
            child: const DashBoard(),
          ),
        ),
      ],
    );
  }
}
