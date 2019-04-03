class SharedPrefs {
  List<String> favouriteLeagues;

  SharedPrefs(this.favouriteLeagues);

  factory SharedPrefs.initial() => SharedPrefs(List());
}
