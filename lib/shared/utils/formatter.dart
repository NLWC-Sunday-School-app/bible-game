bool _isNumeric(String str) {
  return int.tryParse(str) != null;
}

formatScriptureString(text) {
  var splittedText = text.split(' ');
  if (_isNumeric(text[0])) {
    var newText = splittedText[0] + ' ' + splittedText[1];
    return newText + '\n' + splittedText[2];
  } else {
    if (splittedText[0] == 'Song') {
      return splittedText[0] +
          ' ' +
          splittedText[1] +
          '\n' +
          splittedText[2] +
          '\n' +
          splittedText[3];
    } else {
      return splittedText[0] + '\n' + splittedText[1];
    }
  }
}

String capitalizeText(String word) => word[0].toUpperCase() + word.substring(1);

