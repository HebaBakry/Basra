enum Suit { hearts, diamonds, clubs, spades }
enum Rank { ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king }

class Card {
  final Suit suit;
  final Rank rank;

  Card({required this.suit, required this.rank});

  @override
  String toString() {
    return '${rankToString(rank)} of ${suitToString(suit)}';
  }

  // Utility methods to convert enums to readable strings
  String suitToString(Suit suit) {
    switch (suit) {
      case Suit.hearts:
        return 'Hearts';
      case Suit.diamonds:
        return 'Diamonds';
      case Suit.clubs:
        return 'Clubs';
      case Suit.spades:
        return 'Spades';
    }
  }

  String rankToString(Rank rank) {
    switch (rank) {
      case Rank.ace:
        return 'Ace';
      case Rank.two:
        return '2';
      case Rank.three:
        return '3';
      case Rank.four:
        return '4';
      case Rank.five:
        return '5';
      case Rank.six:
        return '6';
      case Rank.seven:
        return '7';
      case Rank.eight:
        return '8';
      case Rank.nine:
        return '9';
      case Rank.ten:
        return '10';
      case Rank.jack:
        return 'Jack';
      case Rank.queen:
        return 'Queen';
      case Rank.king:
        return 'King';
    }
  }
}
