class Urls {
  static const base = 'http://192.168.1.2/api_travel';

  static String image(String imageName) {
    return '$base/images/$imageName';
  }
}
