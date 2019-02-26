import 'package:flutter/material.dart';
import 'package:multi_image_picker/asset.dart';

/// 选择图片后的展示Widget
class AssetView extends StatefulWidget {
  final Asset _asset;

  AssetView(
    this._asset, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AssetState(this._asset);
}

class AssetState extends State<AssetView> {
  Asset _asset;

  AssetState(this._asset);

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    await this._asset.requestThumbnail(300, 300, quality: 50);

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (null != this._asset.thumbData) {
      return Image.memory(
        this._asset.thumbData.buffer.asUint8List(),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        height: 100.0,
      );
    }
    return Container();
  }
}
