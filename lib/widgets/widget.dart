import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wallitapp/model/wallpaper_model.dart';
import 'package:wallitapp/views/category.dart';
import 'package:wallitapp/views/image.dart';

Widget BrandName(Color mainColor, Color subColor) {
  return RichText(
    text: TextSpan(
        style: TextStyle(
            fontSize: 26, fontWeight: FontWeight.w700, fontFamily: 'Rubik'),
        children: [
          TextSpan(
            text: "Wall.",
            style: TextStyle(color: mainColor),
          ),
          TextSpan(
            text: "it",
            style: TextStyle(
              color: subColor,
            ),
          ),
        ]),
  );
}

Widget WallpapersList(List<WallpaperModel> wallpaperList, context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 14),
    child: GridView.count(
      padding: EdgeInsets.symmetric(vertical: 20),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpaperList.map((wallpaper) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     // transitionDuration: Duration(milliseconds: 800),
              //     pageBuilder: (_, __, ___) => ImageView(
              //       id: wallpaper.id,
              //       imgUrl: wallpaper.src.portrait,
              //       photographer: wallpaper.photographer,
              //     ),
              //   ),
              // );
              _navigateAndDisplaySelection(context, wallpaper);
            },
            child: Hero(
              tag: wallpaper.src.portrait,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: wallpaper.src.medium,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

_navigateAndDisplaySelection(
    BuildContext context, WallpaperModel wallpaper) async {
  final result = await Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => ImageView(
        id: wallpaper.id,
        imgUrl: wallpaper.src.portrait,
        photographer: wallpaper.photographer,
      ),
    ),
  );

  // After the Selection Screen returns a result, hide any previous snackbars
  // and show the new result.
  Scaffold.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text("$result")));
}

Widget CategoriesTile({String imgUrl, String title, context}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Category(
              categoryName: title,
            ),
          ));
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.purple, Colors.redAccent]),
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(27),
            topRight: Radius.circular(27),
            bottomRight: Radius.circular(27),
          ),
        ),
        height: 80,
        width: 80,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.white, width: 4),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
                child: Image.network(
                  imgUrl,
                  height: 66,
                  width: 66,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                height: 66,
                width: 66,
                padding: EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                child: AutoSizeText(
                  title,
                  maxLines: 1,
                  minFontSize: 10,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget CategoriesList({@required categories, context}) {
  return Container(
    // color: Colors.white,
    padding: EdgeInsets.only(top: 10),
    height: 90,
    child: ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemCount: categories.length,
      // shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return CategoriesTile(
            imgUrl: categories[index].imgUrl,
            title: categories[index].categoriesName,
            context: context);
      },
    ),
  );
}
