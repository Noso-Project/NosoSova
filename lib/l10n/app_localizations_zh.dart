import 'app_localizations.dart';

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get incoming => '转入';

  @override
  String get outgoing => '转出';

  @override
  String get wallets => '钱包';

  @override
  String get payments => '付款';

  @override
  String get node => '节点';

  @override
  String get myAddresses => '地址';

  @override
  String get genNewKeyPair => '生成新地址';

  @override
  String get scanQrCode => '扫描二维码';

  @override
  String get historyPayments => '最近的交易';

  @override
  String get titleScannerCode => '二维码扫描器';

  @override
  String get foundAddresses => '找到的地址';

  @override
  String get cancel => '取消';

  @override
  String get addToWallet => '添加到钱包';

  @override
  String get titleInfoNetwork => '节点信息';

  @override
  String get debugInfo => '调试窗口';

  @override
  String get connections => '连接';

  @override
  String get lastBlock => '最后一个区块';

  @override
  String get pendings => '待处理';

  @override
  String get branch => '分支';

  @override
  String get version => '版本';

  @override
  String get utcTime => 'UTC时间';

  @override
  String get pingMs => 'ms';

  @override
  String get ping => 'Ping';

  @override
  String get activeConnect => '已连接';

  @override
  String get connection => '搜索可用节点..';

  @override
  String get errorConnection => '连接错误';

  @override
  String get address => '地址';

  @override
  String get keys => '密钥';

  @override
  String get sendFromAddress => '从该地址发送';

  @override
  String get removeAddress => '从钱包中删除地址';

  @override
  String get importFile => '从文件中导入';

  @override
  String get importFileSubtitle => '选择 .pkw 或 .nososova 格式的钱包文件';

  @override
  String get exportFile => '导出到文件';

  @override
  String get exportFileSubtitle => '将钱包文件保存为 .pkw 或 .nososova 格式';

  @override
  String get fileWallet => '钱包文件';

  @override
  String get searchAddressResult => '找到的地址';

  @override
  String get billAction => 'Bill to this address';

  @override
  String get addressesAdded => '为钱包添加新地址';

  @override
  String get settings => '设置';

  @override
  String get sync => '同步';

  @override
  String get information => '信息';

  @override
  String get masternodes => '主节点';

  @override
  String get blocksRemaining => '剩余区块';

  @override
  String get daysUntilNextHalving => '距离下一次减半的天数';

  @override
  String get numberOfMinedCoins => '已开采的硬币';

  @override
  String get coinsLocked => '锁定的硬币';

  @override
  String get marketcap => '市值';

  @override
  String get tvl => '锁定的资产';

  @override
  String get maxPriceStory => 'Maximum price per story';

  @override
  String get activeNodes => '活动节点';

  @override
  String get nbr => '一个区块';

  @override
  String get nr24 => '24小时';

  @override
  String get nr7 => '7天';

  @override
  String get nr30 => '30天';

  @override
  String get nosoPrice => 'Noso 价格';

  @override
  String get rewardNode => '主节点奖励:';

  @override
  String get launched => '运行';

  @override
  String get available => '可用的';

  @override
  String get masternode => '主节点';

  @override
  String get empty => '空的';

  @override
  String get hintAddress => '显示地址详情';

  @override
  String get hintStatusNodeRun => '节点已在线';

  @override
  String get hintStatusNodeNonRun => '节点已离线';

  @override
  String get emptyNodesError => '您没有启动主节点所需的地址..';

  @override
  String get importKeysPair => '从密钥对中导入';

  @override
  String get catHistoryTransaction => '交易记录';

  @override
  String get transactionInfo => '交易信息';

  @override
  String get block => '区块';

  @override
  String get orderId => '订单编号';

  @override
  String get receiver => '接收方';

  @override
  String get commission => '手续费';

  @override
  String get openToExplorer => '打开区块浏览器';

  @override
  String get shareTransaction => '分享该交易记录';

  @override
  String get message => '留言';

  @override
  String get editCustom => '更改别名';

  @override
  String get errorLoading => '服务器错误';

  @override
  String get catActionAddress => '地址操作';

  @override
  String get customNameAdd => '设置别名';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get sender => '发送人';

  @override
  String get confirmDelete => '确认删除地址';

  @override
  String get aliasNameAddress => '更改别名';

  @override
  String get alias => '别名';

  @override
  String get consensusCheck => '协商一致的解决方案';

  @override
  String get save => '保存';

  @override
  String get nodeType => '节点类型';

  @override
  String get status => '状态';

  @override
  String get balance => '余额';

  @override
  String get actionWallet => '对钱包的操作';

  @override
  String get confirm => '确认';

  @override
  String get createPayment => '创建付款';

  @override
  String get amount => '数量';

  @override
  String get send => '发送';

  @override
  String get chanceNode => '更改节点';

  @override
  String get viewQr => '查看二维码';

  @override
  String get infoTotalPriceUst => '余额估值≈';

  @override
  String get updateInfo => '更新信息';

  @override
  String get copyAddress => '复制地址';

  @override
  String get informMyNodes => '您的节点状态';

  @override
  String get getKeysPair => '查看密钥';

  @override
  String get reward => '奖励';

  @override
  String get online => '在线';

  @override
  String get sendCoins => '发送资金';

  @override
  String get sellAddress => '选择一个地址';

  @override
  String get offline => '离线';

  @override
  String get pnlDay => 'PnL/天';

  @override
  String get successSaveExportFile => '您的钱包已成功导出';

  @override
  String get displayPendingTransactions => '这里显示您的待处理交易';

  @override
  String get updatePriceMinute => '信息每分钟更新一次';

  @override
  String get pendingTransaction => '待处理的交易';

  @override
  String get updateTim => '更新';

  @override
  String get hintConnectStop => '由于主网不稳定，连接已中断。要继续使用，请单击 \"更改 \"节点';

  @override
  String get emptyListAddress => '创建或生成新地址供您使用';

  @override
  String get aliasMessage => '别名长度可设置为 3 至 32 个字符。此外，不要忘记，设置别名需要支付交易费.';

  @override
  String get errorNoFoundCoinsTransaction => '没有足够的硬币进行交易';

  @override
  String get errorInformationIncorrect => '传输信息不正确';

  @override
  String get errorImportAddresses => '由于地址重复，因此未添加地址';

  @override
  String get errorDefaultErrorAlias => '尝试设置别名时出错';

  @override
  String get priceInfoErrorServer => '价格信息不可用';

  @override
  String get errorEmptyHistoryTransactions => '该地址无交易记录';

  @override
  String get errorNoValidAddress => '错误，地址无效';

  @override
  String get errorNoSync => '应用程序与主网络不同步';

  @override
  String get errorAddressBlock => '地址被锁定，付款被取消';

  @override
  String get errorAddressFound => '接收方不存在';

  @override
  String get sendProcess => '付款正在等待确认';

  @override
  String get errorSendOrderDefault => '发送付款出错，请稍后再试';

  @override
  String get warringMessageSetAlias => '该操作只能进行一次';

  @override
  String get successSetAlias => '您的请求已成功处理';

  @override
  String get errorEmptyListWallet => '该文件不包含地址';

  @override
  String get errorNotSupportedWallet => '不支持该文件';

  @override
  String get errorLastTime => '您的时间已落后，请更新您的时间';

  @override
  String get errorPathSaveAddress => '错误： 地址无效或没有写入文件的权限';

  @override
  String get errorStopSync => '由于错误而失去连接';

  @override
  String get stopSync => '连接丢失';

  @override
  String get unknownError => '出现错误';

  @override
  String get appVersions => '应用程序版本';

  @override
  String get developer => '开发人员';

  @override
  String get socialLinks => '社交网络链接';

  @override
  String get openSettings => '打开设置';

  @override
  String get mainSet => '主要设置';

  @override
  String get darkTheme => '深色主题';

  @override
  String get selLanguage => '选择语言';

  @override
  String get nodeInfo => '节点的相关信息';

  @override
  String get consecutivePayments => '连续支付';

  @override
  String get uptimePercent => '正常运行时间';

  @override
  String get monthlyEarning => '月收入';

  @override
  String get openNodeInfo => '节点的相关信息';

  @override
  String get errorConnectionApi => '很抱歉，我们目前无法处理您的请求';

  @override
  String get contact => '联系方式';

  @override
  String get contactEmpty => '您的联系人将显示在此处';

  @override
  String get newContact => '创建联系人';

  @override
  String get addContact => '添加到联系人';

  @override
  String get tooltipSelMyWallet => '从我的钱包中选择';

  @override
  String get tooltipSelContact => '从联系人中选择';

  @override
  String get tooltipPasteFromBuffer => '粘贴';

  @override
  String get secretKeys => '密钥';

  @override
  String get showMoreInfo => '显示其他信息';

  @override
  String get hideMoreInfo => '隐藏信息';

  @override
  String get yes => '是';

  @override
  String get no => '不';

  @override
  String get issueDialogDeleteContact => '您真的要删除联系人吗？';

  @override
  String get whatGvt => '什么是 GVT?';

  @override
  String get gvtAbout => 'Noso 的治理代币（GVT）赋予持有者对项目相关事项进行投票的权力，使他们能够提议并参与投票活动。一个 GVT 相当于一票。今后，个人可以通过 NosoSova 钱包内的 Noso/GVT 交易获得 GVT 代币.';

  @override
  String get myListGvts => '我的GvT';

  @override
  String get viewGvtsList => '概述';

  @override
  String get emptyGvts => '您的钱包中未找到 GVT';

  @override
  String get viewAddressItem => '地址元素的样式';

  @override
  String get interface => '接口';

  @override
  String get lockedCoins => '锁定的硬币';

  @override
  String get exchanges => '交易所';

  @override
  String get errorImportNoPassword => '注意！在导入前，请解锁您在NosoLite应用中用密码锁定的地址。否则，它们将被忽略。';

  @override
  String get thanksTranslate => '感谢您的翻译';

  @override
  String get resetNetwork => 'Reset network data';

  @override
  String get resetNetworkDescrpt => 'Reset network settings to help with sync freezes';

  @override
  String get resetNetworkDialog => 'Are you confirming the reset of the network connection data?';

  @override
  String get resetNetworkSuccess => 'Yes, RESET!';

  @override
  String get setVerNodes => 'Change verified nodes';

  @override
  String get setVerNodesDesc => 'You can change the verified nodes, do it at the moment when the application cannot establish a connection to the blockchain.';

  @override
  String get addDescription => '添加描述';

  @override
  String get editDescription => '编辑描述';

  @override
  String get descrDescription => '您可以为您的地址添加描述，它将本地存储在NosoSova应用程序中';

  @override
  String get description => '您的地址描述';
}
