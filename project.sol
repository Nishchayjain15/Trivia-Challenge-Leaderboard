// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TriviaLeaderboard {
    struct Player {
        string name;
        uint256 score;
        uint256 gamesPlayed;
        uint256 correctAnswers;
        bool isRegistered;
    }

    struct Question {
        string question;
        string[] options;
        uint8 correctOptionIndex;
        uint256 points;
        bool isActive;
    }

    address public owner;
    mapping(address => Player) public players;
    address[] public playerAddresses;
    Question[] public questions;
    
    uint256 public minGameFee = 0.001 ether;
    uint256 public prizePools;

    event PlayerRegistered(address indexed player, string name);
    event QuestionAdded(uint256 questionId);
    event QuestionAnswered(address indexed player, uint256 questionId, bool correct);
    event ScoreUpdated(address indexed player, uint256 newScore);
    event PrizeAwarded(address indexed player, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyRegistered() {
        require(players[msg.sender].isRegistered, "Player not registered");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerPlayer(string memory _name) external {
        require(!players[msg.sender].isRegistered, "Player already registered");
        require(bytes(_name).length > 0, "Name cannot be empty");

        players[msg.sender] = Player({
            name: _name,
            score: 0,
            gamesPlayed: 0,
            correctAnswers: 0,
            isRegistered: true
        });

        playerAddresses.push(msg.sender);
        emit PlayerRegistered(msg.sender, _name);
    }

    function addQuestion(
        string memory _question,
        string[] memory _options,
        uint8 _correctOptionIndex,
        uint256 _points
    ) external onlyOwner {
        require(_options.length >= 2, "Minimum 2 options required");
        require(_correctOptionIndex < _options.length, "Invalid correct option index");
        require(_points > 0, "Points must be greater than 0");

        questions.push(Question({
            question: _question,
            options: _options,
            correctOptionIndex: _correctOptionIndex,
            points: _points,
            isActive: true
        }));

        emit QuestionAdded(questions.length - 1);
    }

    function answerQuestion(uint256 _questionId, uint8 _selectedOption) external payable onlyRegistered {
        require(msg.value >= minGameFee, "Insufficient game fee");
        require(_questionId < questions.length, "Invalid question ID");
        require(questions[_questionId].isActive, "Question is not active");
        require(_selectedOption < questions[_questionId].options.length, "Invalid option selected");

        bool isCorrect = (_selectedOption == questions[_questionId].correctOptionIndex);
        
        if (isCorrect) {
            players[msg.sender].score += questions[_questionId].points;
            players[msg.sender].correctAnswers++;
            prizePools += msg.value;
        }

        players[msg.sender].gamesPlayed++;
        
        emit QuestionAnswered(msg.sender, _questionId, isCorrect);
        emit ScoreUpdated(msg.sender, players[msg.sender].score);
    }

    function getLeaderboard() external view returns (
        address[] memory addresses,
        string[] memory names,
        uint256[] memory scores
    ) {
        uint256 count = playerAddresses.length;
        addresses = new address[](count);
        names = new string[](count);
        scores = new uint256[](count);

        // Create temporary arrays for sorting
        address[] memory tempAddresses = playerAddresses;
        uint256[] memory tempScores = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            tempScores[i] = players[tempAddresses[i]].score;
        }

        // Simple bubble sort
        for (uint256 i = 0; i < count - 1; i++) {
            for (uint256 j = 0; j < count - i - 1; j++) {
                if (tempScores[j] < tempScores[j + 1]) {
                    // Swap scores
                    (tempScores[j], tempScores[j + 1]) = (tempScores[j + 1], tempScores[j]);
                    // Swap addresses
                    (tempAddresses[j], tempAddresses[j + 1]) = (tempAddresses[j + 1], tempAddresses[j]);
                }
            }
        }

        // Fill return arrays
        for (uint256 i = 0; i < count; i++) {
            addresses[i] = tempAddresses[i];
            names[i] = players[tempAddresses[i]].name;
            scores[i] = players[tempAddresses[i]].score;
        }

        return (addresses, names, scores);
    }

    function awardPrizes(address[] calldata _winners, uint256[] calldata _amounts) external onlyOwner {
        require(_winners.length == _amounts.length, "Arrays length mismatch");
        uint256 totalAmount = 0;
        
        for (uint256 i = 0; i < _amounts.length; i++) {
            totalAmount += _amounts[i];
        }
        
        require(totalAmount <= prizePools, "Insufficient prize pool");

        for (uint256 i = 0; i < _winners.length; i++) {
            require(players[_winners[i]].isRegistered, "Winner not registered");
            payable(_winners[i]).transfer(_amounts[i]);
            emit PrizeAwarded(_winners[i], _amounts[i]);
        }
        
        prizePools -= totalAmount;
    }

    function getPlayerStats(address _player) external view returns (
        string memory name,
        uint256 score,
        uint256 gamesPlayed,
        uint256 correctAnswers
    ) {
        require(players[_player].isRegistered, "Player not registered");
        Player memory player = players[_player];
        return (player.name, player.score, player.gamesPlayed, player.correctAnswers);
    }

    function updateGameFee(uint256 _newFee) external onlyOwner {
        require(_newFee > 0, "Fee must be greater than 0");
        minGameFee = _newFee;
    }

    function deactivateQuestion(uint256 _questionId) external onlyOwner {
        require(_questionId < questions.length, "Invalid question ID");
        questions[_questionId].isActive = false;
    }

    function withdrawUnusedFunds() external onlyOwner {
        payable(owner).transfer(address(this).balance - prizePools);
    }
}