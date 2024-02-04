import 'app_localizations.dart';

<<<<<<< HEAD
/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);
=======
/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get incoming => 'Recebendo';

  @override
  String get outgoing => 'Enviando';

  @override
  String get wallets => 'Carteira';

  @override
  String get payments => 'Pagamentos';

  @override
  String get node => 'Nó';

  @override
  String get myAddresses => 'Contas';

  @override
  String get genNewKeyPair => 'Criar nova conta';

  @override
<<<<<<< HEAD
  String get scanQrCode => 'Ler código Code';

  @override
  String get historyPayments => 'Transacções recentes';

  @override
  String get titleScannerCode => 'Leitor de códigod Qr';
=======
  String get scanQrCode => 'Ler código QR';

  @override
  String get historyPayments => 'Transações recentes';

  @override
  String get titleScannerCode => 'Leitor de código QR';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get foundAddresses => 'Contas encontradas';

  @override
  String get cancel => 'Cancelar';

  @override
  String get addToWallet => 'Adicionar à carteira';

  @override
  String get titleInfoNetwork => 'Informação sobre o nó';

  @override
  String get debugInfo => 'Depurar';

  @override
  String get connections => 'Conexões';

  @override
<<<<<<< HEAD
  String get lastBlock => 'Último Block';
=======
  String get lastBlock => 'Último Bloco';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get pendings => 'Pendentes';

  @override
  String get branch => 'Ramo';

  @override
  String get version => 'Versão';

  @override
  String get utcTime => 'Horário UTC';

  @override
  String get pingMs => 'ms';

  @override
  String get ping => 'Ping';

  @override
  String get activeConnect => 'Connectado';

  @override
  String get connection => 'Procurando nó...';

  @override
<<<<<<< HEAD
  String get errorConnection => 'Erro de connexão';
=======
  String get errorConnection => 'Erro de conexão';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get address => 'Conta';

  @override
  String get keys => 'Chaves';

  @override
  String get sendFromAddress => 'Enviar desta conta';

  @override
  String get removeAddress => 'Remover conta da carteira';

  @override
  String get importFile => 'Importar de um ficheiro';

  @override
  String get importFileSubtitle => 'Escolher um ficheiro de carteira em formato .pkw ou .nososova';

  @override
  String get exportFile => 'Exportar para ficheiro';

  @override
  String get exportFileSubtitle => 'Gravar a carteira em formato .pkw ou .nososova';

  @override
  String get fileWallet => 'Ficheiro da carteira';

  @override
  String get searchAddressResult => 'Conta encontrada';

  @override
  String get billAction => 'Deduzir desta conta';

  @override
  String get addressesAdded => 'Adicionar novas contas à sua carteira';

  @override
  String get settings => 'Configuração';

  @override
  String get sync => 'Sincronização';

  @override
  String get information => 'Informação';

  @override
  String get masternodes => 'MasterNodes';

  @override
  String get blocksRemaining => 'Blocos Restantes';

  @override
<<<<<<< HEAD
  String get daysUntilNextHalving => 'Dias para o próximo "Halving"';
=======
  String get daysUntilNextHalving => 'Dias para o próximo \'Halving\'';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get numberOfMinedCoins => 'Moedas minadas';

  @override
  String get coinsLocked => 'Moedas bloqueadas';

  @override
  String get marketcap => 'Noso Marketcap';

  @override
  String get tvl => 'Valor Total Bloqueado';

  @override
  String get maxPriceStory => 'Preço máximo por artigo';

  @override
  String get activeNodes => 'Nós ativos';

  @override
<<<<<<< HEAD
  String get tmr => 'Recompensa Total MasterNode';

  @override
  String get nbr => 'Recompensa Bloco de Nó';

  @override
  String get nr24 => 'Recompensa em 24 horas';

  @override
  String get nr7 => 'Recompensa em 7 dias';

  @override
  String get nr30 => 'Recompensa em 30 diaa';
=======
  String get nbr => 'Bloco de Nó';

  @override
  String get nr24 => 'Em 24 horas';

  @override
  String get nr7 => 'Em 7 dias';

  @override
  String get nr30 => 'Em 30 dias';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get nosoPrice => 'Preço de Noso';

  @override
<<<<<<< HEAD
=======
  String get rewardNode => 'Recompensa para masternode:';

  @override
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)
  String get launched => 'Correndo';

  @override
  String get available => 'Disponível';

  @override
  String get masternode => 'MasterNode';

  @override
  String get empty => 'Vazio';

  @override
  String get hintAddress => 'Mostrar detalhes da conta';

  @override
  String get hintStatusNodeRun => 'Nó está online';

  @override
  String get hintStatusNodeNonRun => 'Nó está offline';

  @override
  String get emptyNodesError => 'Falta de contas com condições para iniciar MasterNode...';

  @override
  String get importKeysPair => 'Importar de par de chaves';

  @override
<<<<<<< HEAD
  String get catHistoryTransaction => 'Histórico de Transacções';

  @override
  String get transactionInfo => 'Informação sobre Transacções';
=======
  String get catHistoryTransaction => 'Histórico de Transações';

  @override
  String get transactionInfo => 'Informação sobre Transações';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get block => 'Bloco';

  @override
  String get orderId => 'ID da Ordem';

  @override
  String get receiver => 'Recipiente';

  @override
  String get commission => 'Comissão';

  @override
  String get openToExplorer => 'Abrir no Explorador Noso';

  @override
<<<<<<< HEAD
  String get shareTransaction => 'Partilhar Transacção';
=======
  String get shareTransaction => 'Partilhar Transação';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get message => 'Mensagem';

  @override
  String get editCustom => 'Alterar o pseudónimo';

  @override
  String get errorLoading => 'Erro do servidor';

  @override
<<<<<<< HEAD
  String get catActionAddress => 'Acções para contas';
=======
  String get catActionAddress => 'Ações para contas';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get customNameAdd => 'Definir Pseudónimo';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get sender => 'Emissor';

  @override
  String get confirmDelete => 'Comfirme a remoção da conta';

  @override
  String get aliasNameAddress => 'Mudar Pseudónimo';

  @override
  String get alias => 'Pseudónimo';

  @override
<<<<<<< HEAD
  String get consensusCheck => 'Resoluçaão de consenso';
=======
  String get consensusCheck => 'Resolução de consenso';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get save => 'Gravar';

  @override
<<<<<<< HEAD
  String get nodeType => 'Typo do Nó';
=======
  String get nodeType => 'Tipo do Nó';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get status => 'Estado';

  @override
  String get balance => 'Saldo';

  @override
<<<<<<< HEAD
  String get actionWallet => 'Acções para contas';
=======
  String get actionWallet => 'Ações para contas';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get confirm => 'Confirmar';

  @override
  String get createPayment => 'Criar pagamento';

  @override
  String get amount => 'Montante';

  @override
  String get send => 'Enviar';

  @override
  String get chanceNode => 'Mudar o nó';

  @override
<<<<<<< HEAD
  String get viewQr => 'Mostrar o código Qr';

  @override
  String get infoTotalPriceUst => 'Slado USDT';

  @override
  String get updateInfo => 'Actualizar informação';
=======
  String get viewQr => 'Mostrar o código QR';

  @override
  String get infoTotalPriceUst => 'Saldo USDT';

  @override
  String get updateInfo => 'Atualizar informação';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get copyAddress => 'Copiar a conta';

  @override
  String get informMyNodes => 'Estado dos seus nós';

  @override
  String get getKeysPair => 'Mostrar chaves';

  @override
  String get reward => 'Recompensa';

  @override
  String get online => 'Online';

  @override
  String get sendCoins => 'Enviar fundos';

  @override
<<<<<<< HEAD
  String get sellAddress => 'Seleccionar uma conta';
=======
  String get sellAddress => 'Selecionar uma conta';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get offline => 'Offline';

  @override
  String get pnlDay => 'PnL por dia';

  @override
  String get successSaveExportFile => 'A sua carteira foi exportada com sucesso';

  @override
<<<<<<< HEAD
  String get displayPendingTransactions => 'Transacções pendentes são listadas aqui';

  @override
  String get updatePriceMinute => 'Informações actualizada a cada minuto';

  @override
  String get pendingTransaction => 'Transacções Pendentes';
=======
  String get displayPendingTransactions => 'Transações pendentes são listadas aqui';

  @override
  String get updatePriceMinute => 'Informações atualizadas a cada minuto';

  @override
  String get pendingTransaction => 'Transações Pendentes';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get updateTim => 'Atualizado';

  @override
<<<<<<< HEAD
  String get hintConnectStop => 'Devido a flutuações na rede principal a conexão pode ser perdida. Para continuação de uso, é favor cliquar em "Mudar o nó"';
=======
  String get hintConnectStop => 'Devido a flutuações na rede principal, a conexão pode ser perdida. Para continuação de uso, é favor clicar em \'Mudar o nó\'';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get emptyListAddress => 'Gerar novas contas para seu uso';

  @override
<<<<<<< HEAD
  String get aliasMessage => 'O pseudónimo pode ser definido de 3 a 32 caracteres. É favor não esquecer que esta acção custa uma taxa de transacção.';

  @override
  String get errorNoFoundCoinsTransaction => 'O seu saldo não permite esta transacção';

  @override
  String get errorInformationIncorrect => 'Os dados introduzidos estão incorrectos';

  @override
  String get errorImportAddresses => 'Devido à existência de duplição não foi possível addicionar as contas';
=======
  String get aliasMessage => 'O pseudónimo pode ser definido de 3 a 32 caracteres. É favor não esquecer que esta ação custa uma taxa de transação.';

  @override
  String get errorNoFoundCoinsTransaction => 'O seu saldo não permite esta transação';

  @override
  String get errorInformationIncorrect => 'Os dados introduzidos estão incorretos';

  @override
  String get errorImportAddresses => 'Devido à existência de duplicação, não foi possível adicionar as contas';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get errorDefaultErrorAlias => 'Erro ao tentar definir o pseudónimo';

  @override
  String get priceInfoErrorServer => 'Informação de preço não disponível';

  @override
<<<<<<< HEAD
  String get errorEmptyHistoryTransactions => 'Não existe informação sobre transacções nesta conta';
=======
  String get errorEmptyHistoryTransactions => 'Não existe informação sobre transações nesta conta';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get errorNoValidAddress => 'Erro, conta inválida';

  @override
  String get errorNoSync => 'A aplicação não está sincronizada com a rede principal';

  @override
  String get errorAddressBlock => 'Conta bloqueada, pagamento cancelado';

  @override
  String get errorAddressFound => 'Recipiente não existe';

  @override
  String get sendProcess => 'Pagamento à espera de confirmação';

  @override
  String get errorSendOrderDefault => 'Erro ao enviar pagamento, por favor tente mais tarde';

  @override
  String get warringMessageSetAlias => 'Esta operação só pode ser feita uma única vez';

  @override
<<<<<<< HEAD
  String get successSetAlias => 'O seu pedido foi efectuado com sucesso e foi processado';

  @override
  String get errorEmptyListWallet => 'O ficheoro não contêm contas';
=======
  String get successSetAlias => 'O seu pedido foi efetuado com sucesso e foi processado';

  @override
  String get errorEmptyListWallet => 'O ficheiro não contêm contas';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get errorNotSupportedWallet => 'Este tipo de ficheiro não é suportado';

  @override
  String get errorLastTime => 'Existe uma diferença no relógio do sistema, por favor atualize o relógio do sistema';

  @override
<<<<<<< HEAD
  String get errorPathSaveAddress => 'Erro: Conta inválida pu falta de permissões para alterar o ficheiro';
=======
  String get errorPathSaveAddress => 'Erro: Conta inválida ou falta de permissões para alterar o ficheiro';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)

  @override
  String get errorStopSync => 'Conexão perdida devido a erros';

  @override
  String get stopSync => 'Conexão perdida';

  @override
<<<<<<< HEAD
  String get unknownError => 'Ocurreu um erro';
=======
  String get unknownError => 'Ocorreu um erro';

  @override
  String get appVersions => 'Versão do App';

  @override
  String get developer => 'Desenvolvedor';

  @override
  String get socialLinks => 'Links para redes sociais';

  @override
  String get openSettings => 'Abrir Configurações';

  @override
  String get mainSet => 'Configurações Principais';

  @override
  String get darkTheme => 'Tema Escuro';

  @override
  String get selLanguage => 'Selecionar Idioma';

  @override
  String get nodeInfo => 'Informações sobre o Nó';

  @override
  String get consecutivePayments => 'Pagamentos Consecutivos';

  @override
  String get uptimePercent => 'Tempo de Atividade';

  @override
  String get monthlyEarning => 'Ganhos Mensais';
>>>>>>> 3961876 (feat: Add Spain && Portugal Language)
}
