class WallpaperModel {
  int id;
  String photographer;
  String photographer_url;
  int photographer_id;
  SrcModel src;

  WallpaperModel(
      {this.id,
      this.photographer,
      this.photographer_url,
      this.photographer_id,
      this.src});

  factory WallpaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallpaperModel(
        id: jsonData["id"],
        photographer: jsonData["photographer"],
        photographer_url: jsonData["photographer_url"],
        photographer_id: jsonData["photographer_id"],
        src: SrcModel.fromMap(jsonData["src"]));
  }
}

class SrcModel {
  String original;
  String small;
  String medium;
  String portrait;

  SrcModel({this.original, this.small, this.medium, this.portrait});

  factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
    return SrcModel(
        original: jsonData["original"],
        small: jsonData["small"],
        medium: jsonData["medium"],
        portrait: jsonData["portrait"]);
  }
}

// DEMO DATA
// {
//   "id": 4354389,
//   "width": 2500,
//   "height": 1875,
//   "url": "https://www.pexels.com/photo/brown-rock-formation-near-body-of-water-4354389/",
//   "photographer": "Nikolay Bondarev",
//   "photographer_url": "https://www.pexels.com/@nick-bondarev",
//   "photographer_id": 2766954,
//   "src": {
//       "original": "https://images.pexels.com/photos/4354389/pexels-photo-4354389.jpeg",
//       "large2x": "https://images.pexels.com/photos/4354389/pexels-photo-4354389.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
//       "large": "https://images.pexels.com/photos/4354389/pexels-photo-4354389.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
//       "medium": "https://images.pexels.com/photos/4354389/pexels-photo-4354389.jpeg?auto=compress&cs=tinysrgb&h=350",
//       "small": "https://images.pexels.com/photos/4354389/pexels-photo-4354389.jpeg?auto=compress&cs=tinysrgb&h=130",
//       "portrait": "https://images.pexels.com/photos/4354389/pexels-photo-4354389.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
//       "landscape": "https://images.pexels.com/photos/4354389/pexels-photo-4354389.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
//       "tiny": "https://images.pexels.com/photos/4354389/pexels-photo-4354389.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
//   },
//   "liked": false
// },
