import 'app_localizations.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get incoming => 'Входящие';

  @override
  String get outgoing => 'Исходящие';

  @override
  String get wallets => 'Кошелёк';

  @override
  String get payments => 'Платежи';

  @override
  String get node => 'Нода';

  @override
  String get myAddresses => 'Адреса';

  @override
  String get genNewKeyPair => 'Создать новый адрес';

  @override
  String get scanQrCode => 'Сканировать QR код';

  @override
  String get historyPayments => 'История транзакций';

  @override
  String get titleScannerCode => 'QR Сканнер';

  @override
  String get foundAddresses => 'Найти адрес';

  @override
  String get cancel => 'Отмена';

  @override
  String get addToWallet => 'Добавить в кошелёк';

  @override
  String get titleInfoNetwork => 'Подключение к сети';

  @override
  String get debugInfo => 'Отладка';

  @override
  String get connections => 'Соединения';

  @override
  String get lastBlock => 'Блок:';

  @override
  String get pendings => 'В процессе';

  @override
  String get branch => 'Ветвь';

  @override
  String get version => 'Версия:';

  @override
  String get utcTime => 'Время (UTC):';

  @override
  String get pingMs => 'мс';

  @override
  String get ping => 'Пинг';

  @override
  String get activeConnect => 'Подключено';

  @override
  String get connection => 'Поиск доступной ноды...';

  @override
  String get errorConnection => 'Ошибка при подключении';

  @override
  String get address => 'Адрес';

  @override
  String get keys => 'Ключи';

  @override
  String get sendFromAddress => 'Отправить монеты с этого адреса';

  @override
  String get removeAddress => 'Удалить адрес из кошелька';

  @override
  String get importFile => 'Импорт из файла';

  @override
  String get importFileSubtitle => 'Выберите файл кошелька: .pkw или .nososova.';

  @override
  String get exportFile => 'Экспорт в файл';

  @override
  String get exportFileSubtitle => 'Сохранить кошелёк в файл .pkw или .nososova';

  @override
  String get fileWallet => 'Файл кошелька';

  @override
  String get searchAddressResult => 'Адрес найден';

  @override
  String get billAction => 'Счёт на этот адрес';

  @override
  String get addressesAdded => 'Добавьте новые адреса в свой кошелек';

  @override
  String get settings => 'Настройки';

  @override
  String get sync => 'Синхронизация';

  @override
  String get information => 'Информация';

  @override
  String get masternodes => 'Мастерноды';

  @override
  String get blocksRemaining => 'Осталось блоков';

  @override
  String get daysUntilNextHalving => 'Дней до следующего Халвинга';

  @override
  String get numberOfMinedCoins => 'Добыто монет';

  @override
  String get coinsLocked => 'Монет заблокировано';

  @override
  String get marketcap => 'Капитализация';

  @override
  String get tvl => 'Заблокированно (USDT)';

  @override
  String get maxPriceStory => 'Максимальная цена';

  @override
  String get activeNodes => 'Активные ноды';

  @override
  String get nbr => 'За блок';

  @override
  String get nr24 => 'За сутки';

  @override
  String get nr7 => 'За неделю';

  @override
  String get nr30 => 'За 30 дней';

  @override
  String get nosoPrice => 'Стоимость NOSO';

  @override
  String get rewardNode => 'Вознаграждение за мастерноду:';

  @override
  String get launched => 'Запущено';

  @override
  String get available => 'Доступно';

  @override
  String get masternode => 'Мастернода';

  @override
  String get empty => 'Пусто';

  @override
  String get hintAddress => 'Показать детали адреса';

  @override
  String get hintStatusNodeRun => 'Нода онлайн';

  @override
  String get hintStatusNodeNonRun => 'Нода офлайн';

  @override
  String get emptyNodesError => 'У Вас нет подходящих адресов для запуска Мастерноды.';

  @override
  String get importKeysPair => 'Импорт из Key Pair';

  @override
  String get catHistoryTransaction => 'История транзакций';

  @override
  String get transactionInfo => 'Данные транзакции';

  @override
  String get block => 'Блок:';

  @override
  String get orderId => 'Order ID';

  @override
  String get receiver => 'Получатель';

  @override
  String get commission => 'Комиссия';

  @override
  String get openToExplorer => 'Открыть в Explorer-e';

  @override
  String get shareTransaction => 'Поделиться';

  @override
  String get message => 'Сообщение';

  @override
  String get editCustom => 'Смена псевдонима';

  @override
  String get errorLoading => 'Ошибка';

  @override
  String get catActionAddress => 'Что Вы хотите сделать?';

  @override
  String get customNameAdd => 'Задать псевдоним';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get sender => 'Отправитель';

  @override
  String get confirmDelete => 'Подтвердить удаление адреса';

  @override
  String get aliasNameAddress => 'Изменить псевдоним';

  @override
  String get alias => 'Псевдоним';

  @override
  String get consensusCheck => 'Консенсус';

  @override
  String get save => 'Сохранить';

  @override
  String get nodeType => 'Тип:';

  @override
  String get status => 'Статус:';

  @override
  String get balance => 'Баланс';

  @override
  String get actionWallet => 'Что Вы хотите сделать?';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get createPayment => 'Сделать перевод';

  @override
  String get amount => 'Количество';

  @override
  String get send => 'Отправить';

  @override
  String get chanceNode => 'Сменить ноду';

  @override
  String get viewQr => 'Открыть QR код';

  @override
  String get infoTotalPriceUst => 'Баланс в USDT';

  @override
  String get updateInfo => 'Обновить данные';

  @override
  String get copyAddress => 'Скопировать адрес';

  @override
  String get informMyNodes => 'Ваши мастерноды';

  @override
  String get getKeysPair => 'Просмотр ключей';

  @override
  String get reward => 'Прибыль';

  @override
  String get online => 'В сети';

  @override
  String get sendCoins => 'Отправить средства';

  @override
  String get sellAddress => 'Выберите адрес';

  @override
  String get offline => 'Не в сети';

  @override
  String get pnlDay => 'PnL за сутки';

  @override
  String get successSaveExportFile => 'Ваш кошелек был успешно экспортирован';

  @override
  String get displayPendingTransactions => 'Здесь будут ваши отложенные транзакции';

  @override
  String get updatePriceMinute => 'Обновление информации происходит каждую минуту';

  @override
  String get pendingTransaction => 'Незавершенные сделки';

  @override
  String get updateTim => 'Обновлено';

  @override
  String get hintConnectStop => 'Соединение прервано из-за нестабильности основной сети. Чтобы продолжить его использование, нажмите на кнопку Изменить узел';

  @override
  String get emptyListAddress => 'Создать или сгенерировать новые адреса';

  @override
  String get aliasMessage => 'Псевдоним может быть длиной от 3 до 32 символов. Также не забывайте, что за создание псевдонима взимается комиссия.';

  @override
  String get errorNoFoundCoinsTransaction => 'Недостаточно монет';

  @override
  String get errorInformationIncorrect => 'Некоректная информация';

  @override
  String get errorImportAddresses => 'Адреса не добавлены, так как обнаружены дубликаты';

  @override
  String get errorDefaultErrorAlias => 'Ошибка при попытке установить псевдоним';

  @override
  String get priceInfoErrorServer => 'Информация о цене недоступна';

  @override
  String get errorEmptyHistoryTransactions => 'По этому адресу транзакций не найдено';

  @override
  String get errorNoValidAddress => 'Ошибка, неверный адрес';

  @override
  String get errorNoSync => 'Приложение не синхронизировано с основной сетью';

  @override
  String get errorAddressBlock => 'Адрес заблокирован, платеж отменен';

  @override
  String get errorAddressFound => 'Получатель не существует';

  @override
  String get sendProcess => 'Платеж ожидает подтверждения';

  @override
  String get errorSendOrderDefault => 'Ошибка при отправке платежа. Повторите попытку позже.';

  @override
  String get warringMessageSetAlias => 'Операция доступна только один раз';

  @override
  String get successSetAlias => 'Ваш запрос обработан и успешно выполнен';

  @override
  String get errorEmptyListWallet => 'Этот файл не содержит адреса';

  @override
  String get errorNotSupportedWallet => 'Этот файл не поддерживается';

  @override
  String get errorLastTime => 'Ваше время отстает, обновите ваше время';

  @override
  String get errorPathSaveAddress => 'Ошибка: Неверный адрес или нет разрешения на запись файла';

  @override
  String get errorStopSync => 'Соединение потеряно из-за ошибок';

  @override
  String get stopSync => 'Соединение потеряно';

  @override
  String get unknownError => 'Произошла ошибка';

  @override
  String get appVersions => 'Версия приложения';

  @override
  String get developer => 'Разработчик';

  @override
  String get socialLinks => 'Ссылки на социальные сети';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get mainSet => 'Основные настройки';

  @override
  String get darkTheme => 'Темная тема';

  @override
  String get selLanguage => 'Выбрать язык';

  @override
  String get nodeInfo => 'Информация об узле';

  @override
  String get consecutivePayments => 'Последовательные платежи';

  @override
  String get uptimePercent => 'Безотказная работа';

  @override
  String get monthlyEarning => 'Ежемесячный заработок';

  @override
  String get openNodeInfo => 'Информация о Node';

  @override
  String get errorConnectionApi => 'Извините, мы не можем обработать ваш запрос в данный момент';

  @override
  String get contact => 'Контакты';

  @override
  String get contactEmpty => 'Здесь будут отображаться ваши контакты';

  @override
  String get newContact => 'Создать контакт';

  @override
  String get addContact => 'Добавить в контакты';

  @override
  String get tooltipSelMyWallet => 'Выбрать из моего кошелька';

  @override
  String get tooltipSelContact => 'Выбрать из списка контактов';

  @override
  String get tooltipPasteFromBuffer => 'Вставить из буфера';

  @override
  String get secretKeys => 'Секретные ключи';

  @override
  String get showMoreInfo => 'Отображать дополнительную информацию';

  @override
  String get hideMoreInfo => 'Скрыть информацию';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get issueDialogDeleteContact => 'Вы действительно хотите удалить контакт?';

  @override
  String get whatGvt => 'Что такое GVT?';

  @override
  String get gvtAbout => 'Токен управления (GVT) от Noso предоставляет владельцам возможность голосовать по вопросам, касающимся проекта, позволяя им предлагать и участвовать в голосовании. Один GVT равен одному голосу. В будущем люди смогут приобретать токены GVT через торговлю Noso/GVT в кошельке NosoSova.';

  @override
  String get myListGvts => 'Мои GvT';

  @override
  String get viewGvtsList => 'Обзор';

  @override
  String get emptyGvts => 'В вашем кошельке нет GVT';

  @override
  String get viewAddressItem => 'Стиль элемента адреса';

  @override
  String get interface => 'Интерфейс';

  @override
  String get lockedCoins => 'Заблокированные монеты';

  @override
  String get exchanges => 'Биржи';

  @override
  String get errorImportNoPassword => 'Внимание! Перед импортом разблокируйте ваши адреса, которые вы заблокировали паролем в приложении NosoLite. В противном случае они будут проигнорированы.';

  @override
  String get thanksTranslate => 'Спасибо за перевод';

  @override
  String get addDescription => 'Добавить описание';

  @override
  String get editDescription => 'Редактировать описание';

  @override
  String get descrDescription => 'Вы можете добавить описание для вашего адреса, оно будет храниться локально в приложении NosoSova';

  @override
  String get description => 'Описание для вашего адреса';

  @override
  String get resetNetwork => 'Сбросить данные сети';

  @override
  String get resetNetworkDescrpt => 'Сбросить настройки сети, чтобы помочь с зависаниями синхронизации';

  @override
  String get resetNetworkDialog => 'Вы подтверждаете сброс данных сетевого подключения?';

  @override
  String get resetNetworkSuccess => 'Да, СБРОСИТЬ!';

  @override
  String get setVerNodes => 'Изменить проверенные ноды';

  @override
  String get setVerNodesDesc => 'Вы можете изменить проверенные ноды, сделайте это, когда приложение не может установить соединение с блокчейном.';

  @override
  String get testVerSeeds => 'Протестировать проверенные ноды';

  @override
  String get testVerSeedsDesc => 'Сделайте это, если не можете подключиться к сети';

  @override
  String get verfNodes => 'Verified nodes';
}
