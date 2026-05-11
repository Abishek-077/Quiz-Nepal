/// Pages where banner ads are allowed.
enum BannerAdPlacement {
  home,
  category,
}

/// The only app moment where an interstitial may be requested.
enum InterstitialAdPlacement {
  quizResultScreenOpened,
}

/// User-initiated rewarded ad actions.
enum RewardedAdTrigger {
  unlockFullExplanation,
  continueQuiz,
  doubleCoins,
}
