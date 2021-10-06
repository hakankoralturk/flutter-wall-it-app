import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallitapp/data/data.dart';
import 'package:wallitapp/model/wallpaper_model.dart';
import 'package:wallitapp/widgets/loader.dart';
import 'package:wallitapp/widgets/widget.dart';
import 'package:http/http.dart' as http;

class Category extends StatefulWidget {
  final String categoryName;
  Category({this.categoryName});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  ScrollController _controller = ScrollController();
  List<WallpaperModel> wallpapers = [];
  String pageUrl =
      "https://api.pexels.com/v1/search/?page=1&per_page=10&query=";
  bool _loading, _upButtonVisible = false;

  getWallpapersForCategory([String query]) async {
    print(pageUrl);

    String url;

    query == null ? url = pageUrl : url = (pageUrl + query);

    print(url);

    var response =
        await http.get(Uri.parse(url), headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {
      pageUrl = jsonData["next_page"];
    });
  }

  Future<void> getFirstPage(query) async {
    setState(() {
      _loading = true;
    });

    await getWallpapersForCategory(query);

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    getFirstPage(widget.categoryName);
    super.initState();

    _controller.addListener(() async {
      double maxScroll = _controller.position.maxScrollExtent;
      double currentScroll = _controller.position.pixels;
      double delta = MediaQuery.of(context).size.height;
      print(_loading);
      if (currentScroll > delta) {
        setState(() {
          _upButtonVisible = true;
        });
        if (currentScroll == maxScroll) {
          setState(() {
            _loading = true;
            print(_loading);
          });

          await getWallpapersForCategory();

          setState(() {
            _loading = false;
            print(_loading);
          });
        }
      } else {
        setState(() {
          _upButtonVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: AnimatedOpacity(
        opacity: _upButtonVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: FloatingActionButton(
          mini: true,
          child: Icon(Icons.arrow_upward),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(27),
              topRight: Radius.circular(27),
              bottomRight: Radius.circular(27),
            ),
          ),
          backgroundColor: Colors.black,
          onPressed: () => _controller.animateTo(
            _controller.position.minScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          ),
        ),
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.categoryName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Container(
          child: Column(
            children: [
              WallpapersList(wallpapers, context),
              _loading
                  ? Column(
                      children: [
                        Center(
                          child: ColorLoader5(
                            dotOneColor: Colors.black,
                            dotTwoColor: Colors.grey[700],
                            dotThreeColor: Colors.black26,
                            dotType: DotType.circle,
                            dotIcon: Icon(Icons.adjust),
                            duration: Duration(seconds: 1),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    )
                  : SizedBox(
                      width: 0,
                      height: 50,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
