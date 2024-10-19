import 'package:flutter/material.dart';
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

  // Handles player playing a card
  void playCard(Player player, cd.Card playedCard) {
    if (player == currentPlayer) {  // Only allow play on the current player's turn
      setState(() {
        Basra.playCard(player, playedCard, widget.floor);

        // Check if the players need more cards from the deck after playing
        if (widget.players[0].hand.isEmpty && widget.players[1].hand.isEmpty &&
            widget.deck.cards.isNotEmpty && widget.deck.cards.length >= 8) {
          widget.deck.deal(widget.players, 4);  // Deal 4 more cards to the players
        }

        // Switch to the next player
        currentPlayerIndex = (currentPlayerIndex + 1) % widget.players.length;
        currentPlayer = widget.players[currentPlayerIndex];
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
          const SizedBox(height: 40),

        Expanded(child: Column(
          children: [
            // Player 1's cards (Bot)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.players[1].hand.map((card) {
                // Show the back of the card if it's not Player 1's turn
                return CardWidget(
                  card: card,
                  showBack:true,  // Show back if it's not Player 1's turn
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
        )),
          const SizedBox(height: 20),

          // Display remaining cards in the deck
          Text('Cards left in deck: ${widget.deck.cards.length}'),
        ],
      ),
    );
  }
}
