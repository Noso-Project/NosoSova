class PathAppRpcUtil {
  static String seedFilePath = "${getAppPath()}/seeds.txt";
  static String rpcConfigFilePath = "rpc_config.yaml";

  static getAppPath() {
    return "sovaData/";
  }
}
