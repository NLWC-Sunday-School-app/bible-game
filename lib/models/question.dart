
class Question {
  int id, answer;
  final String question;
  final List<String> options;

  Question({
    required this.id,
    required this.answer,
    required this.question,
    required this.options,
  });
}

const List questionsData = [
  {
    "id": 1,
    "question": "I am come in my Father's name, and ye receive me not: if another shall come in his own name, him ye will receive.",
    "options": ['James 4:1', 'James 4:1', 'James 4:1', 'James 4:1'],
    "answer_index": 0,
  },
  {
    "id": 2,
    "question": "That the righteousness of the law might be fulfilled in us, who walk not after the flesh, but after the Spirit",
    "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
    "answer_index": 1,
  },
  {
    "id": 3,
    "question": "Then Jesus said unto them, Verily, verily, I say unto you, Except ye eat the flesh of the Son of man, and drink his blood, ye have no life in you.",
    "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
    "answer_index": 2,
  },
  {
    "id": 4,
    "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
    "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
    "answer_index": 3,
  },
];
