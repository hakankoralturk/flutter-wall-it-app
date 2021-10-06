import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:like_button/like_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallitapp/views/home.dart';

class ImageView extends StatefulWidget {
  final int id;
  final String imgUrl;
  final String photographer;

  const ImageView({
    @required this.id,
    @required this.imgUrl,
    this.photographer,
  });

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  final _likeKey = GlobalKey<LikeButtonState>();
  bool isLiked = true;
  final int likeCount = 999;

  // _pressed() {
  //   setState(() {
  //     isLiked = !isLiked;
  //     print(isLiked);
  //   });
  // }

  // findWallpaperId() async {
  //   String data = await DefaultAssetBundle.of(context)
  //       .loadString("assets/favorites.json");

  //   final jsonDecode = json.decode(data);

  //   print(jsonDecode);
  // }

  @override
  void initState() {
    super.initState();
    // findWallpaperId();

    print(widget.id);
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: widget.imgUrl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // child: Image.network(
              //   widget.imgUrl,
              //   fit: BoxFit.cover,
              // ),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: 50, left: 20),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                        bottomRight: Radius.circular(22),
                      ),
                    ),
                    child: Icon(Icons.clear, size: 30, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: IconButton(
                          iconSize: 44,
                          icon: Icon(Icons.share, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _save();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 14, left: 18, right: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.black12,
                                    Colors.black54,
                                  ]),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.save_alt,
                                    size: 44, color: Colors.white),
                                Text(
                                  "Kaydet",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: LikeButton(
                          size: 44,
                          likeCount: likeCount,
                          key: _likeKey,
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite,
                              color: isLiked ? Colors.pinkAccent : Colors.white,
                              size: 44,
                            );
                          },
                          countBuilder: (int count, bool isLiked, String text) {
                            final Color color =
                                isLiked ? Colors.pinkAccent : Colors.white;
                            Widget result;
                            if (count == 0) {
                              result = Text(
                                text,
                                style: TextStyle(color: color),
                              );
                            } else
                              result = Text(
                                count >= 1000
                                    ? (count / 1000.0).toStringAsFixed(1) + 'k'
                                    : text,
                                style: TextStyle(color: color),
                              );
                            print(isLiked);
                            return result;
                          },
                          countPostion: CountPostion.right,
                          likeCountPadding: const EdgeInsets.only(left: 5.0),
                          onTap: onLikeButtonTapped,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  widget.photographer,
                  style: TextStyle(
                      color: Color(0xFFD04A4B), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        // title: Text("Dialog Title"),
        content: Text("Fotoğraflar'a kaydedildi."),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text("Tamam"),
            isDefaultAction: true,
            onPressed: () async {
              await Future.delayed(Duration(seconds: 1));
              // Navigator.of(context).pop();
              // setState(() {
              //   Navigator.of(context, rootNavigator: true).pop();
              // });
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => Home()));
              print("geri");
            },
          ),
        ],
      ),
    );
  }

  _save() async {
    await _askPermission();
    String path = widget.imgUrl;

    var response = await http.get(Uri.parse(path));

    print(path);
    final result = await ImageGallerySaver.saveImage(response.bodyBytes);

    // result == true ? _showDialog(context) : null;

    result == true ? Navigator.pop(context, 'Yep!') : null;
  }

  _askPermission() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) {
        print("izin ok");
      }
    } else {
      if (await Permission.storage.request().isGranted) {
        print("izin ok");
      }
    }
  }
}
