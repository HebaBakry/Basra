import 'card.dart';

class Player {
  final String name;
  List<Card> hand = [];
  List<Card> collectedCards = []; // Tracks collected cards
  int basraCount = 0;  // Basra bonus count
  int totalScore = 0;

  Player({required this.name});

  void receiveCard(Card card) {
    hand.add(card);
  }

  void playCard(Card card) {
    hand.remove(card);
  }

  void collectCards(List<Card> cards, {bool isBasra = false}) {
    collectedCards.addAll(cards);
    if(cards.isNotEmpty){
      totalScore++;
    }
    print("cards: ${cards.length}");
    for (var _ in cards) {
     totalScore++;
    }
    if (isBasra) {
      basraCount++;
      // Add 10 points for each Basra
      totalScore += 10;
    }
    print('totalScore $totalScore');
  }


  int calculateScore() {
    int score = 0;

    for (var card in collectedCards) {
      // Jacks and Aces are worth 1 point each
      if (card.rank == Rank.jack || card.rank == Rank.ace) {
        score += 1;
      }

      // 2 of Clubs is worth 2 points
      if (card.rank == Rank.two && card.suit == Suit.clubs) {
        score += 2;
      }

      // 10 of Diamonds is worth 3 points
      if (card.rank == Rank.ten && card.suit == Suit.diamonds) {
        score += 3;
      }
    }

    // Add 10 points for each Basra
    score += basraCount * 10;

    return score;
  }

  @override
  String toString() {
    return '$name\'s hand: ${hand.join(', ')}\nCollected cards: ${collectedCards.join(', ')}';
  }
}
