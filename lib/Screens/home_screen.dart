import 'dart:math';
import 'package:flutter/material.dart';
import '../Game Logic/card.dart' as cd;
import '../Game Logic/deck.dart';
import '../Game Logic/player.dart';
import '../Game Logic/floor.dart'; // Import Floor class
import 'game_screen.dart';

// Function to generate a shuffled deck of 52 cards
Deck generateDeck() {
  Deck deck = Deck();
  deck.shuffle(Random());
  return deck;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basra Game')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Generate a shuffled deck of cards
            Deck deck = generateDeck();

            // Create 2 players
            Player player1 = Player(name: 'Player 1');
            Player player2 = Player(name: 'Player 2');

            // Create a Floor and assign 4 cards to it (next 4 cards from the deck)
            Floor floor = Floor();
            floor.cardsOnFloor = deck.cards.sublist(0, 4); // Take 4 cards for the floor
            deck.cards.removeRange(0, 4); // Remove the dealt cards from the deck

            // Navigate to GameScreen with the players and table cards from the floor
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameScreen(
                  players: [player1, player2],
                  floor: floor, deck: deck, // Pass the Floor object instead of a list of cards
                ),
              ),
            );
          },
          child: const Text('Start Game'),
        ),
      ),
    );
  }
}
