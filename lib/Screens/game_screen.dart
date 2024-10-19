import 'package:flutter/material.dart';
import 'dart:math';  // Import for generating random numbers
import '../Game Logic/basra.dart';
import '../Game Logic/card.dart' as cd;
import '../Game Logic/deck.dart';
import '../Game Logic/floor.dart';
import '../Game Logic/player.dart';
import '../Widgets/card_widget.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;
  final Floor floor;
  final Deck deck;

  const GameScreen({
    super.key,
    required this.players,
    required this.floor,
    required this.deck,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int currentPlayerIndex;
  late Player currentPlayer;

  @override
  void initState() {
    super.initState();
    currentPlayerIndex = 0;
    currentPlayer = widget.players[currentPlayerIndex];

    // Deal initial cards to players
    widget.deck.deal(widget.players, 4);  // Deal 4 cards per player initially
  }

  // Method to randomly pick a card for Player 1 (Bot)
  void playRandomCard(Player player) {
    final random = Random();
    int randomIndex = random.nextInt(player.hand.length);  // Pick a random card index
    playCard(player, player.hand[randomIndex]);
  }

  // Method to determine the winner and show the dialog
  void showWinnerDialog() {
    String winner;
    if (widget.players[0].totalScore > widget.players[1].totalScore) {
      winner = widget.players[0].name;
    } else if (widget.players[1].totalScore > widget.players[0].totalScore) {
      winner = widget.players[1].name;
    } else {
      winner = "It's a tie!";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Congratulations $winner, you are the winner'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back or restart the game
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Handles player playing a card
  void playCard(Player player, cd.Card playedCard) {
    if (player == currentPlayer) {  // Only allow play on the current player's turn
      setState(() {
        Basra.playCard(player, playedCard, widget.floor);

        // Check if the players need more cards from the deck after playing
        if (widget.players[0].hand.isEmpty && widget.players[1].hand.isEmpty &&
            widget.deck.cards.isNotEmpty && widget.deck.cards.length >= widget.players.length*4) {
          widget.deck.deal(widget.players, 4);  // Deal 4 more cards to the players
        }
        else if((widget.deck.cards.isEmpty || widget.deck.cards.length < widget.players.length*4) && (widget.players[0].hand.isEmpty && widget.players[1].hand.isEmpty)){
          showWinnerDialog();
        }

        // Switch to the next player
        currentPlayerIndex = (currentPlayerIndex + 1) % widget.players.length;
        currentPlayer = widget.players[currentPlayerIndex];

        // Automatically play for Player 1 if it's their turn (Bot)
        if (currentPlayerIndex == 1) {
          Future.delayed(Duration(seconds: 1), () {
            playRandomCard(widget.players[1]);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basra Game'),
      ),
      body: Column(
        children: [
          // Display scores of both players
          const Text('Scores', style: TextStyle(fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.players.map((player) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('Score: ${player.totalScore}'),  // Display the player's score
                  ],
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Player 1's cards (Bot)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.players[1].hand.map((card) {
                    return CardWidget(
                      card: card,
                      showBack: true,  // Always show the back of the bot's cards
                      isHighlighted: currentPlayerIndex == 1,  // Highlight Player 1's cards if it's their turn
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),  // Spacing between player 1 and floor

                // Display floor cards in the middle
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.floor.cardsOnFloor
                        .map((card) => CardWidget(card: card))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 30),  // Spacing between floor and player 0

                // Player 0's cards (at the bottom)
                const Text('Your Cards', style: TextStyle(fontSize: 18)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.players[0].hand.map((card) {
                    // Add shadow to indicate it's Player 0's turn
                    return GestureDetector(
                      onTap: () => playCard(widget.players[0], card),  // Play card on tap
                      child: CardWidget(
                        card: card,
                        isHighlighted: currentPlayerIndex == 0,  // Highlight Player 0's cards if it's their turn
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Display remaining cards in the deck
          Text('Cards left in deck: ${widget.deck.cards.length}'),
        ],
      ),
    );
  }
}
