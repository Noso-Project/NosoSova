/// Connected - підключено (Connected)
/// Error - помилка (Error)
/// SearchNode - пошук вузла (Search for node)
/// Sync - синхронізація (Synchronization)
enum StatusConnectNodes { connected, error, searchNode, sync, consensus }

enum ApiStatus { connected, loading, error, result }

enum ConsensusStatus { sync, error }

enum InitialNodeAlgorithm { listenDefaultNodes, connectLastNode, listenUserNodes }

enum ActionsFileWallet {
  walletOpen,
  walletExportDialog,
  fileNotSupported,
  isFileEmpty,
  addressAdded
}

enum FormatWalletFile { pkw, nososova }

enum AddressTileStyle { sDefault, sCustom }

enum TypeQrCode {
  qrAddress,
  qrKeys,
  none
}