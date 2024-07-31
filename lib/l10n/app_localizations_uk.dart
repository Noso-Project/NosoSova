import 'app_localizations.dart';

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get incoming => 'Вхідні';

  @override
  String get outgoing => 'Вихідні';

  @override
  String get wallets => 'Гаманець';

  @override
  String get payments => 'Платежі';

  @override
  String get node => 'Вузол';

  @override
  String get myAddresses => 'Адреси';

  @override
  String get genNewKeyPair => 'Згенерувати нову адресу';

  @override
  String get scanQrCode => 'Відскануйте QR-код';

  @override
  String get historyPayments => 'Останні транзакції';

  @override
  String get titleScannerCode => 'Сканер Qr-коду';

  @override
  String get foundAddresses => 'Знайдені адреси';

  @override
  String get cancel => 'Скасувати';

  @override
  String get addToWallet => 'Додати в гаманець';

  @override
  String get titleInfoNetwork => 'Інформація про вузол';

  @override
  String get debugInfo => 'Налагодження';

  @override
  String get connections => 'Підключеннь';

  @override
  String get lastBlock => 'Останній Блок';

  @override
  String get pendings => 'В очікуванні';

  @override
  String get branch => 'Гілка';

  @override
  String get version => 'Версія';

  @override
  String get utcTime => 'Час за UTC';

  @override
  String get pingMs => 'мс';

  @override
  String get ping => 'Пінг';

  @override
  String get activeConnect => 'Підключенно';

  @override
  String get connection => 'Пошук доступного вузла..';

  @override
  String get errorConnection => 'Помилка при підключені';

  @override
  String get address => 'Адреса';

  @override
  String get keys => 'Ключі';

  @override
  String get sendFromAddress => 'Відправити з цієї адреси';

  @override
  String get removeAddress => 'Видалити адресу з гаманця';

  @override
  String get importFile => 'Імпортувати з файлу';

  @override
  String get importFileSubtitle => 'Виберіть файл гаманця .pkw або .nososova';

  @override
  String get exportFile => 'Експортувати в файл';

  @override
  String get exportFileSubtitle => 'Зебережіть файл гаманця .pkw або .nososova';

  @override
  String get fileWallet => 'Файл гаманця';

  @override
  String get searchAddressResult => 'Знайдено адрес';

  @override
  String get billAction => 'Виставити рахунок на цю адресу';

  @override
  String get addressesAdded => 'У ваш гаманець додано нові адреси';

  @override
  String get settings => 'Налаштування';

  @override
  String get sync => 'Синхронізація';

  @override
  String get information => 'Інформація';

  @override
  String get masternodes => 'Мастерноди';

  @override
  String get blocksRemaining => 'Залишилося блоків';

  @override
  String get daysUntilNextHalving => 'Днів до наступного халвінгу';

  @override
  String get numberOfMinedCoins => 'Видобутих монет';

  @override
  String get coinsLocked => 'Заблоковані монети';

  @override
  String get marketcap => 'Ринкова капіталізація';

  @override
  String get tvl => 'Заблокованих активів';

  @override
  String get maxPriceStory => 'Максимальна ціна в історії';

  @override
  String get activeNodes => 'Активні вузли';

  @override
  String get nbr => 'За блок';

  @override
  String get nr24 => 'За 24 години';

  @override
  String get nr7 => 'За 7 днів';

  @override
  String get nr30 => 'За 30 днів';

  @override
  String get nosoPrice => 'Вартість Noso';

  @override
  String get rewardNode => 'Винагорода за мастерноду:';

  @override
  String get launched => 'Запущені';

  @override
  String get available => 'Доступні';

  @override
  String get masternode => 'Мастерноди';

  @override
  String get empty => 'Порожньо';

  @override
  String get hintAddress => 'Показати деталі адреси';

  @override
  String get hintStatusNodeRun => 'Вузол в мережі';

  @override
  String get hintStatusNodeNonRun => 'Вузол не в мережі';

  @override
  String get emptyNodesError => 'У вас немає доступних адрес для запуску мастерноди';

  @override
  String get importKeysPair => 'Імпортувати з пари ключів';

  @override
  String get catHistoryTransaction => 'Історія транзакцій';

  @override
  String get transactionInfo => 'Інформація про транзакцію';

  @override
  String get block => 'Блок';

  @override
  String get orderId => 'ID Замовлення';

  @override
  String get receiver => 'Одержувач';

  @override
  String get commission => 'Комісія';

  @override
  String get openToExplorer => 'Відкрити в Noso Explorer';

  @override
  String get shareTransaction => 'Поділитися транзакцією';

  @override
  String get message => 'Повідомлення';

  @override
  String get editCustom => 'Зміна назви';

  @override
  String get errorLoading => 'Помилка серверу';

  @override
  String get catActionAddress => 'Дії над адресою';

  @override
  String get customNameAdd => 'Встановити псевдонім';

  @override
  String get today => 'Сьогодні';

  @override
  String get yesterday => 'Вчора';

  @override
  String get sender => 'Відправник';

  @override
  String get confirmDelete => 'Підтвердити вилучення адреси';

  @override
  String get aliasNameAddress => 'Зміна псевдоніма';

  @override
  String get alias => 'Псевдонім';

  @override
  String get consensusCheck => 'Вирішення консенсусу';

  @override
  String get save => 'Зберегти';

  @override
  String get nodeType => 'Тип вузла';

  @override
  String get status => 'Статус';

  @override
  String get balance => 'Баланс';

  @override
  String get actionWallet => 'Дії над гаманцем';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get createPayment => 'Створити платіж';

  @override
  String get amount => 'Сумма';

  @override
  String get send => 'Відправити';

  @override
  String get chanceNode => 'Змінити вузол';

  @override
  String get viewQr => 'Переглянути QR коди';

  @override
  String get infoTotalPriceUst => 'Баланс в USDT';

  @override
  String get updateInfo => 'Оновити інформацію';

  @override
  String get copyAddress => 'Скопіювати адресу';

  @override
  String get informMyNodes => 'Статус ваших вузлів';

  @override
  String get getKeysPair => 'Переглянути ключі';

  @override
  String get reward => 'Винагорода';

  @override
  String get online => 'В мережі';

  @override
  String get sendCoins => 'Відправити кошти';

  @override
  String get sellAddress => 'Виберіть адресу';

  @override
  String get offline => 'Не в мережі';

  @override
  String get pnlDay => 'PnL за добу';

  @override
  String get successSaveExportFile => 'Ваш гаманець успішно експортовано';

  @override
  String get displayPendingTransactions => 'Ваші відкладені транзакції відображатимуться тут';

  @override
  String get updatePriceMinute => 'Оновлення інформації відбується кожну хвилину';

  @override
  String get pendingTransaction => 'Очікувані транзакції';

  @override
  String get updateTim => 'Оновлено';

  @override
  String get hintConnectStop => 'З\'єднання розірвано через нестабільність мережі. Щоб продовжити, натисніть на Змінити вузол';

  @override
  String get emptyListAddress => 'Створіть або згенеруйте нові адреси для вашого використання';

  @override
  String get aliasMessage => 'Псевдонім можна встановити довжиною від 3 до 32 символів. Також не забувайте, що за встановлення псевдоніма знімається комісія за операцію.';

  @override
  String get errorNoFoundCoinsTransaction => 'Недостатньо монет для проведення транзакції';

  @override
  String get errorInformationIncorrect => 'Невірна інформація для доставки';

  @override
  String get errorImportAddresses => 'Адреси не додано тому що вони дублюються';

  @override
  String get errorDefaultErrorAlias => 'Помилка при встановленні псевдоніма';

  @override
  String get priceInfoErrorServer => 'Інформація про ціну недоступна';

  @override
  String get errorEmptyHistoryTransactions => 'Транзакцій за цією адресою не знайдено';

  @override
  String get errorNoValidAddress => 'Помилка, недійсна адреса';

  @override
  String get errorNoSync => 'Додаток не синхронізований з основною мережею';

  @override
  String get errorAddressBlock => 'Адреса заблокована, платіж скасовано';

  @override
  String get errorAddressFound => 'Адреси отримувача не існує';

  @override
  String get sendProcess => 'Платіж чекає підтвердження';

  @override
  String get errorSendOrderDefault => 'Помилка відправки платежа, спробуйте пізніше';

  @override
  String get warringMessageSetAlias => 'Операція доступна лише один раз';

  @override
  String get successSetAlias => 'Ваш запит успішно додано в обробку';

  @override
  String get errorEmptyListWallet => 'Це файл не містить адрес';

  @override
  String get errorNotSupportedWallet => 'Цей файл не підтримується';

  @override
  String get errorLastTime => 'Ваш час відстає, оновіть його будь-ласка';

  @override
  String get errorPathSaveAddress => 'Помилка: Невірна адреса або немає дозволу на запис файлу';

  @override
  String get errorStopSync => 'З\'єднання втрачено через помилки';

  @override
  String get stopSync => 'З\'єднання втрачено';

  @override
  String get unknownError => 'Виникла помилка';

  @override
  String get appVersions => 'Версія програми';

  @override
  String get developer => 'Розробник';

  @override
  String get socialLinks => 'Посилання на соціальні мережі';

  @override
  String get openSettings => 'Відкрити налаштування';

  @override
  String get mainSet => 'Основні налаштування';

  @override
  String get darkTheme => 'Темна тема';

  @override
  String get selLanguage => 'Виберіть мову';

  @override
  String get nodeInfo => 'Інформація про вузол';

  @override
  String get consecutivePayments => 'Послідовні платежі';

  @override
  String get uptimePercent => 'Безвідмовна робота';

  @override
  String get monthlyEarning => 'Щомісячний заробіток';

  @override
  String get openNodeInfo => 'Інформація про вузол';

  @override
  String get errorConnectionApi => 'На жаль, ми не можемо обробити ваш запит в даний час';

  @override
  String get contact => 'Контакти';

  @override
  String get contactEmpty => 'Тут будуть відображені ваші контакти';

  @override
  String get newContact => 'Створити контакт';

  @override
  String get addContact => 'Додати до контактів';

  @override
  String get tooltipSelMyWallet => 'Вибрати з мого гаманця';

  @override
  String get tooltipSelContact => 'Вибрати з контактів';

  @override
  String get tooltipPasteFromBuffer => 'Вставити з буфера';

  @override
  String get secretKeys => 'Секретні ключі';

  @override
  String get showMoreInfo => 'Показати додаткову інформацію';

  @override
  String get hideMoreInfo => 'Приховати інформацію';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get issueDialogDeleteContact => 'Ви дійсно хочете видалити контакт?';

  @override
  String get whatGvt => 'Що таке GVT?';

  @override
  String get gvtAbout => 'Токен управління (GVT) від Noso надає власникам можливість голосувати за питання, пов\'язані з проектом, дозволяючи їм пропонувати та брати участь у голосуванні. Один GVT дорівнює одному голосу. У майбутньому люди матимуть можливість отримувати токени GVT через торгівлю Noso/GVT в межах гаманця NosoSova.';

  @override
  String get myListGvts => 'Мої GvT';

  @override
  String get viewGvtsList => 'Огляд';

  @override
  String get emptyGvts => 'Ваш гаманець не містить жодного GVT';

  @override
  String get viewAddressItem => 'Стиль елементу адреси';

  @override
  String get interface => 'Інтерфейс';

  @override
  String get lockedCoins => 'Заблоковані монети';

  @override
  String get exchanges => 'Біржі';

  @override
  String get errorImportNoPassword => 'Увага! Перед імпортом розблокуйте ваші адреси які ви заблокували паролем у додатку NosoLite. В іншому випадку вони будуть проігноровані.';

  @override
  String get thanksTranslate => 'Дякуємо за переклад';

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
  String get addDescription => 'Додати опис';

  @override
  String get editDescription => 'Редагувати опис';

  @override
  String get descrDescription => 'Ви можете додати опис для вашої адреси, він буде зберігатися локально в додатку NosoSova';

  @override
  String get description => 'Опис для вашо адреси';
}
