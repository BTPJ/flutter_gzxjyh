import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// 图片查看画廊
class PhotoGallery extends StatefulWidget {
  final List<String> pictureUrls;

  final int currentIndex;

  PhotoGallery({Key key, this.pictureUrls = const [], this.currentIndex})
      : super(key: key);

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  int _currentIndex;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    /// AppBar
    var appBar = AppBar(
      backgroundColor: Colors.black26,
      title: Text('${_currentIndex + 1}/${widget.pictureUrls.length}'),
      centerTitle: true,
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        child: PhotoViewGallery(
          pageOptions: _buildPhotoPageOptions(),
          enableRotation: true,
          pageController: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  List<PhotoViewGalleryPageOptions> _buildPhotoPageOptions() {
    List<PhotoViewGalleryPageOptions> list = List();
    for (int i = 0; i < widget.pictureUrls.length; i++) {
      list.add(PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(widget.pictureUrls[i]), heroTag: '$i'));
    }
    return list;
  }
}
