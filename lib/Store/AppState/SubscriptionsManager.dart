
class SubscriptionsManager {
  final bool news;
  final bool mensScores;
  final bool womensScores;

  SubscriptionsManager(this.news, this.mensScores, this.womensScores);

  factory SubscriptionsManager.initial() => SubscriptionsManager(false, false, false);
}