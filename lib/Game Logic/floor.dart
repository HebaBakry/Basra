import 'package:basra/Game%20Logic/player.dart';
import 'card.dart';

class Floor {
  List<Card> cardsOnFloor = [];

  void addCard(Card card) {
    cardsOnFloor.add(card);
  }

  // Check if the played card can capture cards from the table
  List<Card> checkForMatch(Player player, Card playedCard, Floor floor) {
    List<Card> matchedCards = [];

    // Case 1: Capture cards by the same rank
    for (var card in cardsOnFloor) {
      if (card.rank == playedCard.rank) {
        matchedCards.add(card);
        // Remove matched cards from the floor and give them to the player
        player.collectCards(matchedCards, isBasra: floor.isEmpty());
        floor.cardsOnFloor.removeWhere((card) => matchedCards.contains(card));
        return matchedCards;
      }
    }

    // Case 2: Capture cards by summing up to the card value (for number cards only)
    if (playedCard.rank.index <= 9) {
      List<Card> numberCards = cardsOnFloor.where((card) => card.rank.index <= 9).toList();
      print("numberCards $numberCards");
      List<Card> sumMatches = _getCaptureCardsBySum(numberCards, playedCard.rank.index+1);
      print("sumMatches $sumMatches");
      matchedCards.addAll(sumMatches);
      print("matchedCards $matchedCards");

      // Remove matched cards from the floor and give them to the player
      player.collectCards(matchedCards, isBasra: floor.isEmpty());
      floor.cardsOnFloor.removeWhere((card) => matchedCards.contains(card));
      return matchedCards;

    }
    return matchedCards;
  }

  // Check if number cards on the floor can sum up to a value
  List<Card> _getCaptureCardsBySum(List<Card> cards, int targetSum) {
    List<List<Card>> combinations = _findCombinations(cards, targetSum);
    // Return the first valid combination that matches the sum
    return combinations.isNotEmpty ? combinations.first : [];
  }

  // Find all combinations of cards that sum to the target sum
  List<List<Card>> _findCombinations(List<Card> cards, int targetSum) {
    List<List<Card>> results = [];
    _findCombinationsHelper(cards, targetSum, [], 0, results);
    return results;
  }

  void _findCombinationsHelper(List<Card> cards, int targetSum, List<Card> current, int start, List<List<Card>> results) {
    print("current $current");
    int currentSum = current.fold(0, (sum, card) => sum + card.rank.index+1);
    print("currentSum $currentSum");

    if (currentSum == targetSum) {
      results.add(List.from(current));
      return;
    }

    for (int i = start; i < cards.length; i++) {
      if (currentSum + cards[i].rank.index + 1 > targetSum) continue;
      current.add(cards[i]);
      _findCombinationsHelper(cards, targetSum, current, i + 1, results);
      current.removeLast();
    }
  }

  bool isEmpty() {
    return cardsOnFloor.isEmpty;
  }
}
