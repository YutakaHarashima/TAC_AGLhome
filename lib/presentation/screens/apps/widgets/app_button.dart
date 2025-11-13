import 'package:flutter_ics_homescreen/core/utils/helpers.dart';
import 'package:flutter_ics_homescreen/export.dart';
import 'package:mime/mime.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.image,
    required this.title,
    required this.onPressed,
  });

  /// アイコン画像のパス（例: 'assets/icons/browser.svg' など）
  final String image;

  /// ボタンタイトル
  final String title;

  /// タップ時コールバック
  final VoidCallback onPressed;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  /// 画像の描画（SVG or PNG/JPG）
  Widget _buildImage() {
    final mimeType = lookupMimeType(widget.image);
    final isSvg = mimeType == 'image/svg+xml' ||
        widget.image.toLowerCase().endsWith('.svg');

    if (isSvg) {
      // SVG は asset として読む
      return SvgPicture.asset(
        widget.image,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      );
    } else {
      // それ以外は通常の画像 asset として読む
      return Image.asset(
        widget.image,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
        // 読み込み失敗時はプレースホルダ
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.apps,
            size: 96,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: [Helpers.boxDropShadowRegular],
        border: Border.all(color: AGLDemoColors.neonBlueColor),
        color: AGLDemoColors.buttonFillEnabledColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 画像
                Expanded(
                  child: Center(child: _buildImage()),
                ),
                const SizedBox(height: 12),
                // タイトル
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    shadows: [Helpers.dropShadowRegular],
                    color: AGLDemoColors.periwinkleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
