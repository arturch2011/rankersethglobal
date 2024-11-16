// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// import "./INFTBackedToken.sol";
import "./RankersToken.sol";

contract Rankers {
    address public owner;
    RankersToken public token;

    struct Ranker {
        uint256 id;
        string name;
        string description;
        string category;
        string frequency;
        uint256 targetFreq;
        uint256 minimumBet;
        uint256 startDate;
        uint256 endDate;
        bool isStarted;
        bool isCompleted;
        bool isPublic;
        address creator;
        uint256 totalBet;
        uint256 preFund;
        uint256 totalParticipants;
        uint256 maxParticipants;
        string[] URI; // IPFS URIs
        string typeTragetFreq;
        uint256 quantity;
        uint256 numFreq;
    }

    Ranker[] public rankers;

    mapping(uint256 => address[]) public participants; //Link ranker id to participants
    mapping(uint256 => mapping(address => uint256)) public bets; // Link ranker id to participants and their bets
    mapping(uint256 => mapping(address => bool)) public isParticipant; // Link ranker id to participants and their status
    mapping(uint256 => mapping(address => uint256)) public participantsFreq; // Link ranker id to participants and their frequency
    mapping(uint256 => mapping(address => string[])) public participantsURI; // Link ranker id to participants and their image URIs
    mapping(uint256 => mapping(address => uint256))
        public participantsAutenticatedFreq; // Link ranker id to the number of times a participant had their frequency authenticated
    mapping(uint256 => mapping(address => uint256[])) public validatedURI; // Link ranker id to participants and their validated URIs

    mapping(address => uint[]) public myRankers; // Link participant to their rankers
    mapping(address => uint[]) public myEnteredRankers; // Link participant to the rankers they have entered
    // INFTBackedToken immutable public nftBackedToken;
    constructor(
        address _rankersTokenAddr
        // address _nftBackedTokenAddr
    ) {
        token = RankersToken(_rankersTokenAddr);
        owner = msg.sender;
        // nftBackedToken = INFTBackedToken(_nftBackedTokenAddr);
    }

    function changeOwner(address _newOwner) public {
        require(msg.sender == owner, "You are not the owner");
        owner = _newOwner;
    }

    function createGoal(
        string memory _name,
        string memory _description,
        string memory _category,
        string memory _frequency,
        uint256 _target,
        uint256 _minimumBet,
        uint256 _startDate,
        uint256 _endDate,
        bool _isPublic,
        uint256 _preFund,
        uint256 _maxParticipants,
        string[] memory _URI,
        string memory _typeTragetFreq,
        uint256 _quantity,
        uint256 _numFreq
    ) public {
        require(_startDate < _endDate, "Start date must be before end date");
        require(_target > 0, "Target must be greater than 0");
        require(
            _maxParticipants > 0,
            "Max participants must be greater than 0"
        );
        require(_URI.length > 0, "URI must not be empty");
        require(token.balanceOf(msg.sender) >= _preFund, "Insufficient funds");
        myRankers[msg.sender].push(rankers.length);
        rankers.push(
            Ranker({
                id: rankers.length, // ID of the ranker
                name: _name, // Name of the ranker
                description: _description, // Description of the ranker
                category: _category, // Category of the ranker
                frequency: _frequency, // Tipo da frequencia (diario, semanal, mensal, anual, etc.)
                targetFreq: _target, // Numero de vezes para atingir 100% do objetivo
                minimumBet: _minimumBet, // Aposta minima para entrar no ranker
                startDate: _startDate, // Data de inicio do ranker
                endDate: _endDate, // Data de fim do ranker
                isStarted: false, // Indica se o ranker ja comecou
                isCompleted: false, // Indica se o ranker ja foi completado
                isPublic: _isPublic, // Indica se o ranker é publico
                creator: msg.sender, // Endereco do criador do ranker
                totalBet: _preFund, // Total de apostas feitas no ranker
                preFund: _preFund, // Valor adicionado como bonus no momento de criação do ranker
                totalParticipants: 0, // Total de participantes no ranker
                maxParticipants: _maxParticipants, // Numero maximo de participantes no ranker
                URI: _URI, // URIs das imagens para fazer o display do ranker
                typeTragetFreq: _typeTragetFreq, // Tipo de objetivo (Km, Litros, Repetições, etc.)
                quantity: _quantity, // Numero de vezes por semana, ou mes. Se a frequencia for diaria é uma vez por dia
                numFreq: _numFreq // Metrica maxima atingida ex: devo correr 5 km por semana durante 1 mes, o nuFreq é 20 km
            })
        );
        token.transferFrom(msg.sender, address(this), _preFund);
    }

    function startGoal(uint256 _goalId) public {
        require(
            rankers[_goalId].creator == msg.sender,
            "You are not the creator of this ranker"
        );
        require(rankers[_goalId].isStarted == false, "Ranker has already started");
        require(
            rankers[_goalId].totalParticipants > 0,
            "No participants in this ranker"
        );
        rankers[_goalId].isStarted = true;
    }

    function enterGoal(uint256 _goalId, uint256 _bet) public {
        require(
            _bet >= rankers[_goalId].minimumBet,
            "Bet must be greater than minimum bet"
        );
        require(token.balanceOf(msg.sender) >= _bet, "Insufficient funds");
        require(
            rankers[_goalId].totalParticipants < rankers[_goalId].maxParticipants,
            "Ranker is full"
        );
        require(
            rankers[_goalId].isCompleted == false,
            "Ranker has already been completed"
        );
        require(
            isParticipant[_goalId][msg.sender] == false,
            "You have already entered this ranker"
        );
        require(rankers[_goalId].isStarted == false, "Ranker has already started");
        bets[_goalId][msg.sender] = _bet;
        rankers[_goalId].totalBet += _bet;
        rankers[_goalId].totalParticipants += 1;
        participants[_goalId].push(msg.sender);
        isParticipant[_goalId][msg.sender] = true;
        token.transferFrom(msg.sender, address(this), _bet);
        myEnteredRankers[msg.sender].push(_goalId);
    }

    function updateFrequency(uint256 _goalId, string memory _imgaeURI) public {
        require(
            isParticipant[_goalId][msg.sender] == true,
            "You are not a participant of this ranker"
        );
        require(
            rankers[_goalId].isCompleted == false,
            "Ranker has already been completed"
        );
        require(rankers[_goalId].isStarted == true, "Ranker has not started yet");
        // require(rankers[_goalId].endDate > block.timestamp, "Ranker has ended");
        require(
            participantsFreq[_goalId][msg.sender] < rankers[_goalId].targetFreq,
            "You have reached the maximum number of frequencies"
        );

        participantsURI[_goalId][msg.sender].push(_imgaeURI);
        participantsFreq[_goalId][msg.sender] += 1;
    }

    function autenticateFrequency(
        uint256 _goalId,
        address _participant,
        uint _number,
        uint[] memory _uriIndex
    ) public {
        require(
            rankers[_goalId].creator == msg.sender || owner == msg.sender,
            "You are not the creator of this ranker"
        );
        require(
            isParticipant[_goalId][_participant] == true,
            "The address is not a participant of this ranker"
        );
        require(
            rankers[_goalId].isCompleted == false,
            "Ranker has already been completed"
        );
        require(rankers[_goalId].isStarted == true, "Ranker has not started yet");
        // require(rankers[_goalId].endDate > block.timestamp, "Ranker has ended");
        require(
            participantsAutenticatedFreq[_goalId][_participant] <
                rankers[_goalId].targetFreq,
            "This participant has reached the maximum number of frequencies"
        );
        // require(participantsURI[_goalId][_participant].length > _uriIndex.length, "URI index out of range");

        for (uint i = 0; i < _uriIndex.length; i++) {
            validatedURI[_goalId][_participant].push(_uriIndex[i]);
        }

        participantsAutenticatedFreq[_goalId][_participant] += _number;
    }

    function completeGoal(uint256 _goalId) public {
        require(
            rankers[_goalId].creator == msg.sender,
            "You are not the creator of this ranker"
        );
        require(
            rankers[_goalId].isCompleted == false,
            "Ranker has already been completed"
        );

        rankers[_goalId].isCompleted = true;

        uint rankerFreq = rankers[_goalId].targetFreq;
        uint rankerFreq85 = (rankerFreq * 85) / 100;

        uint totalParticipants = rankers[_goalId].totalParticipants;
        uint numPremParts = 0;
        uint premPremParts = 0;
        uint premCompParts = 0;
        uint premNParts = 0;

        for (uint i = 0; i < totalParticipants; i++) {
            uint partFreq = participantsAutenticatedFreq[_goalId][
                participants[_goalId][i]
            ];
            if (partFreq >= rankerFreq) {
                numPremParts = numPremParts + 1;
                uint va = bets[_goalId][participants[_goalId][i]];
                premPremParts = premPremParts + va;

                token.transfer(participants[_goalId][i], va);
            } else if (rankerFreq85 <= partFreq && partFreq < rankerFreq) {
                uint val = bets[_goalId][participants[_goalId][i]];
                // numCompParts = numCompParts + 1;
                premCompParts = premCompParts + val;
                token.transfer(participants[_goalId][i], val);
            } else {
                uint v = ((bets[_goalId][participants[_goalId][i]] * partFreq) /
                    rankerFreq); // Aqui o negocio pega,
                premNParts = premNParts + v;
                token.transfer(participants[_goalId][i], v);
            }
        }

        uint prize = rankers[_goalId].totalBet; //300
        uint prizeRankers = (prize - premCompParts - premNParts - premPremParts) /
            2; //300 - 100 = 200
        uint prizePerPart;
        if (numPremParts == 0) {
            prizePerPart = prizeRankers;
            token.transfer(payable(owner), prizeRankers * 2);
        } else {
            prizePerPart = prizeRankers / numPremParts;

            for (uint i = 0; i < totalParticipants; i++) {
                uint partFreq = participantsFreq[_goalId][
                    participants[_goalId][i]
                ];
                if (partFreq == rankerFreq) {
                    token.transfer(participants[_goalId][i], prizePerPart);
                }
            }
            token.transfer(payable(owner), prizeRankers);
        }
    }

    function getGoal() public view returns (Ranker[] memory) {
        return rankers;
    }

    function getMyProgress(uint256 _goalId) public view returns (uint256) {
        require(
            isParticipant[_goalId][msg.sender] == true,
            "You are not a participant of this ranker"
        );
        return participantsAutenticatedFreq[_goalId][msg.sender];
    }

    function getMyBets(uint256 _goalId) public view returns (uint256) {
        require(
            isParticipant[_goalId][msg.sender] == true,
            "You are not a participant of this ranker"
        );
        return bets[_goalId][msg.sender];
    }

    function getMyGoals() public view returns (uint[] memory) {
        return myRankers[msg.sender];
    }

    function getMyEnteredGoals() public view returns (uint[] memory) {
        return myEnteredRankers[msg.sender];
    }

    function getParticipants(
        uint256 _goalId
    ) public view returns (address[] memory) {
        return participants[_goalId];
    }

    function getParticipantsUri(
        uint256 _goalId,
        address _participant
    ) public view returns (string[] memory) {
        return participantsURI[_goalId][_participant];
    }

    function getAutenticatedUri(
        uint256 _goalId,
        address _participant
    ) public view returns (uint[] memory) {
        return validatedURI[_goalId][_participant];
    }
}