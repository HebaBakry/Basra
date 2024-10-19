
import 'dart:math';

import 'package:basra/Game%20Logic/player.dart';

import 'card.dart';

class Deck {
  List<Card> cards = [];

  Deck() {
    // Generate the 52 cards (13 ranks × 4 suits)
    for (var suit in Suit.values) {
      for (var rank in Rank.values) {
        cards.add(Card(suit: suit, rank: rank));
      }
    }
  }

  void shuffle(Random random) {
    cards.shuffle(random);
  }

  void deal(List<Player> players, int cardsPerPlayer) {
    print('kk');
    for (int i = 0; i < cardsPerPlayer; i++) {
      for (var player in players) {
        if (cards.isNotEmpty) {
          player.receiveCard(cards.removeLast());
        }
      }
    }
  }

}
