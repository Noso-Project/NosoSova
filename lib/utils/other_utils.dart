class OtherUtils {
  static String hashObfuscation(String hash) {
    if (hash.length >= 25) {
      return "${hash.substring(0, 9)}...${hash.substring(hash.length - 9)}";
    }
    return hash;
  }

  static String hashObfuscationLong(String hash) {
    if (hash.length >= 25) {
      return "...${hash.substring(10, hash.length)}";
    }


    return hash;
  }
}
