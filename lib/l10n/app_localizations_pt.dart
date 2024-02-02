import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get scanQrCode => 'Ler código Code';

  @override
  String get historyPayments => 'Transacções recentes';

  @override
  String get titleScannerCode => 'Leitor de códigod Qr';

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
  String get lastBlock => 'Último Block';

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
  String get errorConnection => 'Erro de connexão';

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
  String get daysUntilNextHalving => 'Dias para o próximo "Halving"';

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
  String get tmr => 'Recompensa Total MasterNode';

  @override
  String get nbr => 'Recompensa Bloco de Nó';

  @override
  String get nr24 => 'Recompensa em 24 horas';

  @override
  String get nr7 => 'Recompensa em 7 dias';

  @override
  String get nr30 => 'Recompensa em 30 diaa';

  @override
  String get nosoPrice => 'Preço de Noso';

  @override
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
  String get catHistoryTransaction => 'Histórico de Transacções';

  @override
  String get transactionInfo => 'Informação sobre Transacções';

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
  String get shareTransaction => 'Partilhar Transacção';

  @override
  String get message => 'Mensagem';

  @override
  String get editCustom => 'Alterar o pseudónimo';

  @override
  String get errorLoading => 'Erro do servidor';

  @override
  String get catActionAddress => 'Acções para contas';

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
  String get consensusCheck => 'Resoluçaão de consenso';

  @override
  String get save => 'Gravar';

  @override
  String get nodeType => 'Typo do Nó';

  @override
  String get status => 'Estado';

  @override
  String get balance => 'Saldo';

  @override
  String get actionWallet => 'Acções para contas';

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
  String get viewQr => 'Mostrar o código Qr';

  @override
  String get infoTotalPriceUst => 'Slado USDT';

  @override
  String get updateInfo => 'Actualizar informação';

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
  String get sellAddress => 'Seleccionar uma conta';

  @override
  String get offline => 'Offline';

  @override
  String get pnlDay => 'PnL por dia';

  @override
  String get successSaveExportFile => 'A sua carteira foi exportada com sucesso';

  @override
  String get displayPendingTransactions => 'Transacções pendentes são listadas aqui';

  @override
  String get updatePriceMinute => 'Informações actualizada a cada minuto';

  @override
  String get pendingTransaction => 'Transacções Pendentes';

  @override
  String get updateTim => 'Atualizado';

  @override
  String get hintConnectStop => 'Devido a flutuações na rede principal a conexão pode ser perdida. Para continuação de uso, é favor cliquar em "Mudar o nó"';

  @override
  String get emptyListAddress => 'Gerar novas contas para seu uso';

  @override
  String get aliasMessage => 'O pseudónimo pode ser definido de 3 a 32 caracteres. É favor não esquecer que esta acção custa uma taxa de transacção.';

  @override
  String get errorNoFoundCoinsTransaction => 'O seu saldo não permite esta transacção';

  @override
  String get errorInformationIncorrect => 'Os dados introduzidos estão incorrectos';

  @override
  String get errorImportAddresses => 'Devido à existência de duplição não foi possível addicionar as contas';

  @override
  String get errorDefaultErrorAlias => 'Erro ao tentar definir o pseudónimo';

  @override
  String get priceInfoErrorServer => 'Informação de preço não disponível';

  @override
  String get errorEmptyHistoryTransactions => 'Não existe informação sobre transacções nesta conta';

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
  String get successSetAlias => 'O seu pedido foi efectuado com sucesso e foi processado';

  @override
  String get errorEmptyListWallet => 'O ficheoro não contêm contas';

  @override
  String get errorNotSupportedWallet => 'Este tipo de ficheiro não é suportado';

  @override
  String get errorLastTime => 'Existe uma diferença no relógio do sistema, por favor atualize o relógio do sistema';

  @override
  String get errorPathSaveAddress => 'Erro: Conta inválida pu falta de permissões para alterar o ficheiro';

  @override
  String get errorStopSync => 'Conexão perdida devido a erros';

  @override
  String get stopSync => 'Conexão perdida';

  @override
  String get unknownError => 'Ocurreu um erro';
}
