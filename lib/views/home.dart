import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallitapp/data/data.dart';
import 'package:wallitapp/model/categories_model.dart';
import 'package:wallitapp/model/wallpaper_model.dart';
import 'package:wallitapp/widgets/loader.dart';
import 'package:wallitapp/widgets/widget.dart';
import 'package:http/http.dart' as http;

import 'package:wallitapp/views/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _controller = ScrollController();
  TextEditingController _searchController = TextEditingController();
  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];
  String pageUrl = "https://api.pexels.com/v1/curated/?page=4&per_page=10";
  bool _loading, _wasEmpty, _upButtonVisible = false;
  bool _titleGame = true;

  getTrendingWallpapers(url) async {
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

  Future<void> getFirstPage() async {
    setState(() {
      _loading = true;
    });

    await getTrendingWallpapers(pageUrl);

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    getFirstPage();
    categories = getCategories();
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

          await getTrendingWallpapers(pageUrl);

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

    _wasEmpty = _searchController.text.isEmpty;

    _searchController.addListener(() {
      if (_wasEmpty != _searchController.text.isEmpty) {
        setState(() => {_wasEmpty = _searchController.text.isEmpty});
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // const BoxConstraints(
    //   maxWidth: 375,
    //   maxHeight: 892,
    // );

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 892),
        orientation: Orientation.portrait);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        // systemNavigationBarColor: Colors.white, // navigation bar color
        systemNavigationBarIconBrightness: Brightness.dark,
        // statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
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
      body: SafeArea(
        bottom: false,
        top: false,
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              pinned: false,
              snap: false,
              floating: false,
              elevation: 0.0,
              //expandedHeight: ScreenUtil().setHeight(100),
              expandedHeight: 100,
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(30),
                    top: ScreenUtil().setHeight(15),
                  ),
                  child: AnimatedOpacity(
                    opacity: _titleGame ? 0.1 : 0.9,
                    duration: Duration(milliseconds: 400),
                    child: GestureDetector(
                      child: FaIcon(
                        FontAwesomeIcons.ghost,
                        color: Colors.black87,
                        size: 32,
                      ),
                      onTap: () {
                        print("dark mode on/off");
                        setState(() {
                          _titleGame = !_titleGame;
                        });
                      },
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      height: 20,
                      child: AnimatedOpacity(
                        opacity: _titleGame ? 0 : 1,
                        duration: Duration(milliseconds: 400),
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Rubik'),
                              children: [
                                TextSpan(
                                  text: "powered by ",
                                  style: TextStyle(color: Colors.black87),
                                ),
                                TextSpan(
                                  text: "pexels",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      child: GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            _titleGame = !_titleGame;
                          });
                        },
                        child: BrandName(Colors.black87, Colors.redAccent),
                      ),
                      duration: Duration(milliseconds: 500),
                      bottom: _titleGame ? 0 : 20,
                    ),
                  ],
                ),
                titlePadding: EdgeInsets.zero,
                centerTitle: true,
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(30)),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_searchController.text != "") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Search(
                                          searchQuery: _searchController.text),
                                    ),
                                  );
                                } else {
                                  print("Search null");
                                }
                              },
                              child: Container(
                                child: Icon(Icons.search),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                textInputAction: TextInputAction.search,
                                onSubmitted: (_) {
                                  if (_searchController.text != "") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Search(
                                            searchQuery:
                                                _searchController.text),
                                      ),
                                    );
                                  } else {
                                    print("Search null");
                                  }
                                },
                                controller: _searchController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: "Search anything",
                                  border: InputBorder.none,
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    print(text);
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: _searchController.text.isNotEmpty,
                              child: GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                },
                                child: Container(
                                  child: Icon(Icons.backspace),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pinned: false,
              floating: true,
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    CategoriesList(categories: categories),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
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
          ],
        ),
      ),
    );
  }

  _showSnackBar(BuildContext context) async {
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SelectionScreen()),
    // );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("asd")));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._container);

  final Container _container;

  @override
  double get minExtent => 80;
  @override
  double get maxExtent => 90;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      // color: Colors.pink,
      // color: overlapsContent ? Colors.red : Colors.lightBlue,
      child: _container,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
