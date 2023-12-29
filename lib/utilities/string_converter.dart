String capitalize(String word) => word[0].toUpperCase() + word.substring(1);

String formatUserTopGameMode (String word){
  if(word == 'WHOISWHO'){
    return 'Who is Who';
  }else if(word == 'QUICK_GAME'){
    return 'Quick Game';
  }else if (word == 'PILGRIM_PROGRESS'){
    return 'Pilgrim Progress';
  }else {
    return '4 Scriptures 1 Word';
  }
}

String formatUserTopGameModeImage (String word){
  if(word == 'WHOISWHO'){
    return 'assets/images/aesthetics/wiw_recap_img.png';
  }else if(word == 'QUICK_GAME'){
    return 'assets/images/aesthetics/quick_game_recap.png';
  }else if (word == 'PILGRIM_PROGRESS'){
    return 'assets/images/aesthetics/pilgrim_progress_recap.png';
  }else {
    return 'assets/images/aesthetics/four_scriptures_recap.png';
  }
}

String formatBiblePersonality (int percentile){
  if(percentile >= 1 && percentile <= 10){
    return 'David';
  }else if(percentile >= 11 && percentile <= 30){
    return 'Moses';
  }else if (percentile >= 31 && percentile <= 50){
    return 'Daniel';
  } else if(percentile >= 51 && percentile <= 70){
     return 'Jacob';
  }else {
    return 'Onesimus';
  }
}

String formatBiblePersonalityPhrase (int percentile){
  if(percentile >= 1 && percentile <= 10){
    return 'The Zeal of the Lord \nconsumed you.';
  }else if(percentile >= 11 && percentile <= 30){
    return 'You definitely lead the crowd';
  }else if (percentile >= 31 && percentile <= 50){
    return 'You really know the books!';
  } else if(percentile >= 51 && percentile <= 70){
    return 'You really love the inheritance.';
  }else {
    return 'Your Journey only just began.';
  }
}

String formatBiblePersonalityBackgroundImage (int percentile){
  if(percentile >= 1 && percentile <= 10){
    return 'assets/images/aesthetics/david_recap_bg.png';
  }else if(percentile >= 11 && percentile <= 30){
    return 'assets/images/aesthetics/moses_recap_bg.png';
  }else if (percentile >= 31 && percentile <= 50){
    return 'assets/images/aesthetics/daniel_recap_bg.png';
  } else if(percentile >= 51 && percentile <= 70){
    return 'assets/images/aesthetics/jacob_recap_bg.png';
  }else {
    return 'assets/images/aesthetics/onesimus_recap_bg.png';
  }
}

String formatBiblePersonalityImage (int percentile){
  if(percentile >= 1 && percentile <= 10){
    return 'assets/images/aesthetics/david_recap.png';
  }else if(percentile >= 11 && percentile <= 30){
    return 'assets/images/aesthetics/moses_recap.png';
  }else if (percentile >= 31 && percentile <= 50){
    return 'assets/images/aesthetics/daniel_recap.png';
  } else if(percentile >= 51 && percentile <= 70){
    return 'assets/images/aesthetics/jacob_recap.png';
  }else {
    return 'assets/images/aesthetics/onesimus_recap.png';
  }
}

 int formatBiblePersonalityPhraseColor (int percentile){
  if(percentile >= 1 && percentile <= 10){
    return 0xFFFFD817;
  }else if(percentile >= 11 && percentile <= 30){
    return 0xFF252423;
  }else if (percentile >= 31 && percentile <= 50){
    return 0xFF252423;
  } else if(percentile >= 51 && percentile <= 70){
    return 0xFFFFD817;
  }else {
    return 0xFF252423;
  }
}