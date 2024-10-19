
import 'card.dart';
import 'floor.dart';
import 'player.dart';

class Basra{
  static void handleJackCard(Player player, Card playedCard, Floor floor) {
    if (floor.isEmpty()) {
      floor.addCard(playedCard);  // Jack on empty table, no capture
    } else {
      // Capture all cards on the table
      player.collectCards(List.from(floor.cardsOnFloor));
      floor.cardsOnFloor.clear();  // Clear the table
      print('${player.name} played a Jack and captured all cards on the table!');
    }
  }


  static void handleSevenOfDiamonds(Player player, Card playedCard, Floor floor) {
    int sumOfNumberCards = floor.cardsOnFloor
        .where((card) => card.rank.index <= 10)
        .fold(0, (sum, card) => sum + card.rank.index);
    if (sumOfNumberCards <= 10) {
      player.collectCards(List.from(floor.cardsOnFloor),isBasra: true);

      print('${player.name} made a Basra with the 7 of Diamonds!');
    } else {
      player.collectCards(List.from(floor.cardsOnFloor));
      print('${player.name} captured all cards with the 7 of Diamonds, but no Basra.');
    }
    floor.cardsOnFloor.clear();

  }



  static void handleKingOrQueen(Player player, Card playedCard, Floor floor) {
    List<Card> matchedCards = floor.cardsOnFloor
        .where((card) => card.rank == playedCard.rank)
        .toList();

    if (matchedCards.isNotEmpty) {
      player.collectCards(matchedCards);
      floor.cardsOnFloor.removeWhere((card) => matchedCards.contains(card));
      print('${player.name} captured ${matchedCards.length} card(s) with their ${playedCard.rank}.');
    } else {
      floor.addCard(playedCard);  // Add the King or Queen to the table
    }
  }


  static void playCard(Player player, Card playedCard, Floor floor) {
    print('\n${player.name} played: ${playedCard.rank} of ${playedCard.rank.index}');

    // Remove the card from the player's hand
    player.playCard(playedCard);

    if (playedCard.rank == Rank.jack) {
      print('1 ');
      handleJackCard(player, playedCard, floor);
    } else if (playedCard.rank == Rank.seven && playedCard.suit == Suit.diamonds) {
      print('2 ');
      handleSevenOfDiamonds(player, playedCard, floor);
    }
    else if (playedCard.rank == Rank.king || playedCard.rank == Rank.queen) {
      print('3 ');
      handleKingOrQueen(player, playedCard, floor);
    } else {
      List<Card> matchedCards = floor.checkForMatch(player,playedCard,floor);
      print('matchedCards: $matchedCards');
      if (matchedCards.isNotEmpty) {
        bool isBasra = floor.isEmpty();
        if (isBasra) {
          print('${player.name} made a Basra!');
        }
      } else {
        floor.addCard(playedCard);
      }
    }
  }






}