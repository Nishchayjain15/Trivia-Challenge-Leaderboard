# TriviaLeaderboard Smart Contract

## Project Title
TriviaLeaderboard Smart Contract

## Project Description
The TriviaLeaderboard smart contract is a decentralized trivia game on the Ethereum blockchain that allows players to register, answer trivia questions, accumulate scores, and compete for prizes. Players pay a small game fee to participate, and correct answers earn them points that contribute to the leaderboard. The prize pool is funded by the game fees, and winners are rewarded directly from the pool. This contract also includes functionality for the owner to manage questions, prize distributions, and fees.

The contract leverages Solidity and Ethereum's decentralized ledger to ensure fair play, transparency, and immutability in the trivia game.

## Contract Address
0x16850f2bA126Ee80a39b7d2aFDb4339CD260B627

## Project Vision
The vision of TriviaLeaderboard is to provide an engaging, secure, and transparent trivia game experience where participants are rewarded based on their performance. By using blockchain technology, the game ensures fairness, as all actions are recorded on the blockchain and cannot be tampered with. Over time, the platform aims to expand to more questions, different game modes, and a broader community of players.

## Key Features

1. **Player Registration and Stats:**
   - Players can register with a unique name and are assigned a player profile containing their score, number of games played, and correct answers.
   - Players can view their individual statistics at any time.

2. **Question Management:**
   - The contract owner can add new trivia questions with multiple-choice options, one of which is correct.
   - Questions have a point value and can be deactivated once they are no longer active.

3. **Gameplay and Scoring:**
   - Players participate by answering trivia questions for a small game fee.
   - Players' scores are updated in real-time based on the correctness of their answers.
   - A leaderboard is maintained, where players are ranked by their scores.

4. **Prize Pool:**
   - Each game requires a minimum fee to participate. The fees collected from players contribute to a prize pool.
   - Players can earn a portion of the prize pool by answering questions correctly.
   
5. **Prize Distribution:**
   - The contract allows the owner to distribute prizes to the top players or selected winners from the prize pool.
   - The total prize amount must not exceed the available funds in the prize pool.

6. **Leaderboard:**
   - Players can view the leaderboard, which is sorted by score in descending order.
   - The leaderboard lists player addresses, names, and their respective scores.

7. **Owner Functions:**
   - The contract owner has the ability to:
     - Add new questions to the game.
     - Deactivate questions.
     - Update the minimum game fee.
     - Award prizes from the prize pool.
     - Withdraw unused funds, excluding the prize pool.

8. **Security and Validations:**
   - Players must pay the required game fee to participate.
   - All actions, including prize distributions and withdrawals, are logged with events to ensure transparency.
   - There are checks in place to ensure that only registered players can participate, and only the owner can modify key contract parameters.

9. **Transparent Game Play:**
   - Since all player interactions are recorded on the Ethereum blockchain, the contract ensures a fair and transparent gaming experience.

