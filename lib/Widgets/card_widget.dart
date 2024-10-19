import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import '../Game Logic/card.dart' as cd;

class CardWidget extends StatelessWidget {
  final cd.Card card;
  final bool showBack;
  final bool isHighlighted;

  const CardWidget({super.key, required this.card,  this.showBack = false,this.isHighlighted = false, });

  // Map your custom `cd.Card` suit and rank to PlayingCard suit and rank
  PlayingCard getPlayingCard(cd.Card card) {
    Suit suit;
    switch (card.suit) {
      case cd.Suit.hearts:
        suit = Suit.hearts;
        break;
      case cd.Suit.diamonds:
        suit = Suit.diamonds;
        break;
      case cd.Suit.clubs:
        suit = Suit.clubs;
        break;
      case cd.Suit.spades:
        suit = Suit.spades;
        break;
    }

    // Map your ranks
    CardValue rank;
    switch (card.rank) {
      case cd.Rank.ace:
        rank = CardValue.ace;
        break;
      case cd.Rank.two:
        rank = CardValue.two;
        break;
      case cd.Rank.three:
        rank = CardValue.three;
        break;
      case cd.Rank.four:
        rank = CardValue.four;
        break;
      case cd.Rank.five:
        rank = CardValue.five;
        break;
      case cd.Rank.six:
        rank = CardValue.six;
        break;
      case cd.Rank.seven:
        rank = CardValue.seven;
        break;
      case cd.Rank.eight:
        rank = CardValue.eight;
        break;
      case cd.Rank.nine:
        rank = CardValue.nine;
        break;
      case cd.Rank.ten:
        rank = CardValue.ten;
        break;
      case cd.Rank.jack:
        rank = CardValue.jack;
        break;
      case cd.Rank.queen:
        rank = CardValue.queen;
        break;
      case cd.Rank.king:
        rank = CardValue.king;
        break;
    }

    return PlayingCard(suit, rank);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: isHighlighted
            ? [const BoxShadow(color: Colors.grey, blurRadius: 10)]  // Add shadow if highlighted
            : [],
      ),
      width: 60,
      height: 100,
      child: PlayingCardView(
        card: getPlayingCard(card),
        showBack: showBack,
      ),
    );
  }
}
