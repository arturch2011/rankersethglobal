import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

// import 'package:provider/provider.dart';
// import 'package:goals_flutter/providers/user_info_provider.dart';

// late String privKey;

// getPrivKey(key) {
//   privKey = key;
//   return privKey;
// }

// var getPrivKeys = getPrivKey;

class BlockchainProvider extends ChangeNotifier {
  // BlockchainProvider() {
  //   initialSetup();
  // }

  // String address = UserProvider().userInfos[0]['privKey'];
  Web3Client? _ethClient;
  bool isLoading = true;
  String? _abi;
  String? _abiToken;
  EthereumAddress? _contractAddress;
  EthereumAddress? _contractAddressToken;
  Credentials? _credentials;
  DeployedContract? _contract;
  DeployedContract? _contractToken;
  EthereumAddress? address;

  // ContractFunction? _userName;
  // ContractFunction? _setName;

  ContractFunction? _createGoal;
  ContractFunction? _startGoal;
  ContractFunction? _enterGoal;
  ContractFunction? _updateFrequency;
  ContractFunction? _autenticateFrequency;
  ContractFunction? _completeGoal;
  ContractFunction? _getGoal;
  ContractFunction? _getMyProgress;
  ContractFunction? _getMyBets;
  ContractFunction? _participants;
  ContractFunction? _bets;
  ContractFunction? _myGoals;
  ContractFunction? _myEnteredGoals;
  ContractFunction? _getParticipantsUri;

  ContractFunction? _approve;
  ContractFunction? _burn;
  ContractFunction? _burnFrom;
  ContractFunction? _mint;
  ContractFunction? _pause;
  ContractFunction? _permit;
  ContractFunction? _renounceOwnership;
  ContractFunction? _transfer;
  ContractFunction? _transferFrom;
  ContractFunction? _transferOwnership;
  ContractFunction? _unpause;
  ContractFunction? _allowance;
  ContractFunction? _balanceOf;
  ContractFunction? _decimals;
  ContractFunction? _DOMAIN_SEPARATOR;
  ContractFunction? _eip712Domain;
  ContractFunction? _name;
  ContractFunction? _nonces;
  ContractFunction? _owner;
  ContractFunction? _paused;
  ContractFunction? _symbol;
  ContractFunction? _totalSupply;
  late String privKey;

  getPrivKey(key) async {
    privKey = key;
    return privKey;
  }

  List<dynamic> goals = [];
  List<dynamic> unstartedGoals = [];
  List<dynamic> publicGoals = [];
  List<dynamic> myEnteredGoals = [];
  List<dynamic> myCreatedGoals = [];
  List<dynamic> balance = [];
  double balanceEth = 0;
  String publicAddr = '';

  final String addr = dotenv.env['CONTRACT_ADDRESS']!;
  final String addrToken = dotenv.env['CONTRACT_ADDRESS_TOKEN']!;
  final String projectId = dotenv.env['NEXT_PUBLIC_PROJECT_ID']!;

  final String _rpcUrl =
      'https://base-sepolia.infura.io/v3/147fb0a1da714235aa6cc639d09020db';

  initialSetup() async {
    http.Client httpClient = http.Client();
    _ethClient = Web3Client(_rpcUrl, httpClient);

    await getAbi();
    await getCredential();
    await getDeployedContract();
    await getGoals();
    await getMyEnteredGoals();
    await getMyGoals();
    balance = await balanceOf(address!);
    balanceEth = await weiToEth(balance[0]);
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("artifacts/contracts/Goals.sol/Goals.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abi = jsonEncode(jsonAbi['abi']);

    String abiStringFileToken = await rootBundle
        .loadString("artifacts/contracts/GoalsToken.sol/GoalsToken.json");
    var jsonAbiToken = jsonDecode(abiStringFileToken);
    _abiToken = jsonEncode(jsonAbiToken['abi']);

    _contractAddress = EthereumAddress.fromHex(addr);
    _contractAddressToken = EthereumAddress.fromHex(addrToken);
  }

  Future<void> getCredential() async {
    _credentials = EthPrivateKey.fromHex(privKey);
    publicAddr = _credentials!.address.toString();
    address = _credentials!.address;
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abi!, "Goals"), _contractAddress!);

    _contractToken = DeployedContract(
        ContractAbi.fromJson(_abiToken!, "GoalsToken"), _contractAddressToken!);

    // _userName = _contract!.function("userName");
    // _setName = _contract!.function("setName");

    _createGoal = _contract!.function("createGoal");
    _startGoal = _contract!.function("startGoal");
    _enterGoal = _contract!.function("enterGoal");
    _updateFrequency = _contract!.function("updateFrequency");
    _autenticateFrequency = _contract!.function("autenticateFrequency");
    _completeGoal = _contract!.function("completeGoal");
    _getGoal = _contract!.function("getGoal");
    _getMyProgress = _contract!.function("getMyProgress");
    _getMyBets = _contract!.function("getMyBets");
    _participants = _contract!.function("participants");
    _bets = _contract!.function("bets");
    _myGoals = _contract!.function("getMyGoals");
    _myEnteredGoals = _contract!.function("getMyEnteredGoals");
    _getParticipantsUri = _contract!.function("getParticipantsUri");

    _approve = _contractToken!.function("approve");
    _burn = _contractToken!.function("burn");
    _burnFrom = _contractToken!.function("burnFrom");
    _mint = _contractToken!.function("mint");
    _pause = _contractToken!.function("pause");
    _permit = _contractToken!.function("permit");
    _renounceOwnership = _contractToken!.function("renounceOwnership");
    _transfer = _contractToken!.function("transfer");
    _transferFrom = _contractToken!.function("transferFrom");
    _transferOwnership = _contractToken!.function("transferOwnership");
    _unpause = _contractToken!.function("unpause");
    _allowance = _contractToken!.function("allowance");
    _balanceOf = _contractToken!.function("balanceOf");
    _decimals = _contractToken!.function("decimals");
    _DOMAIN_SEPARATOR = _contractToken!.function("DOMAIN_SEPARATOR");
    _eip712Domain = _contractToken!.function("eip712Domain");
    _name = _contractToken!.function("name");
    _nonces = _contractToken!.function("nonces");
    _owner = _contractToken!.function("owner");
    _paused = _contractToken!.function("paused");
    _symbol = _contractToken!.function("symbol");
    _totalSupply = _contractToken!.function("totalSupply");

    getGoals();
  }

  getGoals() async {
    try {
      final fetchedgoals = await _ethClient!.call(
          contract: _contract!,
          function: _getGoal!,
          params: [],
          sender: _credentials!.address);
      if (fetchedgoals.isNotEmpty) {
        print('aaaaaaaaaaaaaaa');
        final List<dynamic> goal = fetchedgoals[0];
        goals = goal;
        unstartedGoals = goal
            .where((element) =>
                (element[7].toInt() - DateTime.now().millisecondsSinceEpoch) /
                    (1000 * 60 * 60 * 24) >
                0)
            .toList();
        publicGoals =
            unstartedGoals.where((element) => element[11] == true).toList();
      }
    } catch (e) {
      print(e);
    }

    return goals;
  }

  createGoal(
    String name,
    String description,
    String category,
    String frequency,
    BigInt target,
    double minimumbet,
    BigInt startDate,
    BigInt endDate,
    bool isPublic,
    double preFund,
    BigInt maxParticipants,
    List<String> uris,
    String typeTarqueFreq,
    BigInt quantity,
    BigInt numFreq,
  ) async {
    BigInt bigPreFund = BigInt.from(preFund * 10e17);
    if (bigPreFund > BigInt.zero) {
      await approve(_contractAddress!, bigPreFund);
    }

    await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _createGoal!,
        parameters: [
          name,
          description,
          category,
          frequency,
          target,
          BigInt.from(minimumbet * 10e17),
          startDate,
          endDate,
          isPublic,
          bigPreFund,
          maxParticipants,
          uris,
          typeTarqueFreq,
          quantity,
          numFreq,
        ],
        from: _credentials!.address,
      ),
      chainId: 84532,
    );

    getGoals();
  }

  startGoal(BigInt goalId) async {
    await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _startGoal!,
        parameters: [goalId],
        from: _credentials!.address,
      ),
      chainId: 84532,
    );

    getGoals();
  }

  enterGoal(BigInt goalId, double bet) async {
    BigInt bigBet = BigInt.from(bet * 10e17);
    await approve(_contractAddress!, bigBet);

    await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _enterGoal!,
        parameters: [goalId, bigBet],
        from: _credentials!.address,
      ),
      chainId: 84532,
    );

    getGoals();
  }

  updateFrequency(BigInt goalId, String frequency) async {
    await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _updateFrequency!,
        parameters: [goalId, frequency],
        from: _credentials!.address,
      ),
      chainId: 84532,
    );

    getGoals();
  }

  autenticateFrequency(BigInt goalId, String participant) async {
    await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _autenticateFrequency!,
        parameters: [goalId, participant],
        from: _credentials!.address,
      ),
      chainId: 84532,
    );

    getGoals();
  }

  completeGoal(BigInt goalId) async {
    await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _completeGoal!,
        parameters: [goalId],
        from: _credentials!.address,
      ),
      chainId: 84532,
    );

    getGoals();
  }

  getMyProgress(BigInt goalId) async {
    var progress = await _ethClient!.call(
        contract: _contract!,
        function: _getMyProgress!,
        params: [goalId],
        sender: _credentials!.address);
    return progress[0];
  }

  getMyBets(BigInt goalId) async {
    var bets = await _ethClient!.call(
        contract: _contract!,
        function: _getMyBets!,
        params: [goalId],
        sender: _credentials!.address);
    return bets[0];
  }

  getParticipants(BigInt goalId) async {
    var participants = await _ethClient!.call(
        contract: _contract!,
        function: _participants!,
        params: [goalId],
        sender: _credentials!.address);
    return participants;
  }

  getBets(BigInt goalId) async {
    var bets = await _ethClient!.call(
        contract: _contract!,
        function: _bets!,
        params: [goalId],
        sender: _credentials!.address);
    return bets;
  }

  getMyGoals() async {
    try {
      final fetchedmyCreatedGoals = await _ethClient!.call(
          contract: _contract!,
          function: _myGoals!,
          params: [],
          sender: _credentials!.address);

      if (fetchedmyCreatedGoals.isNotEmpty) {
        myCreatedGoals = fetchedmyCreatedGoals[0];
      }
      // return fetchedmyCreatedGoals;
    } catch (e) {
      print(e);
    }
  }

  getMyEnteredGoals() async {
    try {
      final fetchedmyEnteredGoals = await _ethClient!.call(
          contract: _contract!,
          function: _myEnteredGoals!,
          params: [],
          sender: _credentials!.address);

      if (fetchedmyEnteredGoals.isNotEmpty) {
        myEnteredGoals = fetchedmyEnteredGoals[0];
      }
      // return fetchedmyEnteredGoals;
    } catch (e) {
      print(e);
    }
  }

  approve(EthereumAddress spender, BigInt amount) async {
    try {
      await _ethClient!.getGasPrice();
      String tran = await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
          contract: _contractToken!,
          function: _approve!,
          parameters: [spender, amount],
          from: _credentials!.address,
        ),
        chainId: 84532,
      );

      TransactionReceipt? receipt;
      while (true) {
        receipt = await _ethClient!.getTransactionReceipt(tran);
        if (receipt != null) {
          break;
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      print(e);
    }
  }

  balanceOf(EthereumAddress addr) async {
    var balance = await _ethClient!.call(
        contract: _contractToken!,
        function: _balanceOf!,
        params: [addr],
        sender: _credentials!.address);
    return balance;
  }

  transfer(EthereumAddress to, BigInt amount) async {
    BigInt amountInWei =
        EtherAmount.fromBigInt(EtherUnit.ether, amount).getInWei;
    await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contractToken!,
        function: _transfer!,
        parameters: [to, amountInWei],
        from: _credentials!.address,
      ),
      chainId: 84532,
    );
  }

  getParticipantsUri(int goalId, String addr) async {
    EthereumAddress addres = EthereumAddress.fromHex(addr);
    BigInt bigId = BigInt.from(goalId);

    var uris = await _ethClient!.call(
      contract: _contract!,
      function: _getParticipantsUri!,
      params: [bigId, addres],
    );

    return uris;
  }

  weiToEth(BigInt wei) {
    var eth = wei / BigInt.from(10).pow(18);

    return eth;
  }
}
