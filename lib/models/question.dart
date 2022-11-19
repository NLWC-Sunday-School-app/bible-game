
class Question {
  int id;
  final String answer;
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
    "options": ['John 5:43', 'John 6:1', 'Luke 4:1', 'Mark 6:9'],
    "correct_option": 'John 6:1',
  },
  {
    "id": 2,
    "question": "That the righteousness of the law might be fulfilled in us, who walk not after the flesh, but after the Spirit",
    "options": ['Gen 4:1', 'Rom 8:4', 'Eph 5:6', 'Gal 3:2'],
    "correct_option": 'Rom 8:4',
  },
  {
    "id": 3,
    "question": "Then Jesus said unto them, Verily, verily, I say unto you, Except ye eat the flesh of the Son of man, and drink his blood, ye have no life in you.",
    "options": ['Col 2:5', 'John 4:1', 'John 6:53', '1Cor 2:2'],
    "correct_option": 'John 6:53',
  },
  {
    "id": 4,
    "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
    "options": ['John 2:2', 'John 4:5', 'John 5:5', 'John 7:7'],
    "correct_option": 'John 7:7',
  },
  {
    "id": 5,
    "question": "Now of the things which we have spoken this is the sum: We have such an high priest, who is set on the right hand of the throne of the Majesty in the heavens;",
    "options": ['Heb 8:1', 'Titus 2:7', 'Jude 1:2', '1Pet 2:8'],
    "correct_option": 'Heb 8:1',
  },
  // {
  //   "id": 5,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 6,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 7,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 8,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 9,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 10,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
];


const List pilgrimQuestionsData = [
  {
    "id": 1,
    "question": "I am come in my Father's name, and ye receive me not: if another shall come in his own name, him ye will receive.",
    "options": ['John 5:43', 'John 6:1', 'Luke 4:1', 'Mark 6:9'],
    "correct_option": 'John 6:1',
  },
  {
    "id": 2,
    "question": "That the righteousness of the law might be fulfilled in us, who walk not after the flesh, but after the Spirit",
    "options": ['Gen 4:1', 'Rom 8:4', 'Eph 5:6', 'Gal 3:2'],
    "correct_option": 'Rom 8:4',
  },
  {
    "id": 3,
    "question": "Then Jesus said unto them, Verily, verily, I say unto you, Except ye eat the flesh of the Son of man, and drink his blood, ye have no life in you.",
    "options": ['Col 2:5', 'John 4:1', 'John 6:53', '1Cor 2:2'],
    "correct_option": 'John 6:53',
  },
  {
    "id": 4,
    "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
    "options": ['John 2:2', 'John 4:5', 'John 5:5', 'John 7:7'],
    "correct_option":  'John 7:7',
  },
  {
    "id": 5,
    "question": "Now of the things which we have spoken this is the sum: We have such an high priest, who is set on the right hand of the throne of the Majesty in the heavens;",
    "options": ['Heb 8:1', 'Titus 2:7', 'Jude 1:2', '1Pet 2:8'],
    "correct_option": 'Heb 8:1',
  },
  // {
  //   "id": 6,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 7,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 8,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 9,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 10,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 11,
  //   "question": "I am come in my Father's name, and ye receive me not: if another shall come in his own name, him ye will receive.",
  //   "options": ['John 5:43', 'John 6:1', 'Luke 4:1', 'Mark 6:9'],
  //   "correct_option": 1,
  // },
  // {
  //   "id": 12,
  //   "question": "That the righteousness of the law might be fulfilled in us, who walk not after the flesh, but after the Spirit",
  //   "options": ['Gen 4:1', 'Rom 8:4', 'Eph 5:6', 'Gal 3:2'],
  //   "correct_option": 1,
  // },
  // {
  //   "id": 13,
  //   "question": "Then Jesus said unto them, Verily, verily, I say unto you, Except ye eat the flesh of the Son of man, and drink his blood, ye have no life in you.",
  //   "options": ['Col 2:5', 'John 4:1', 'John 6:53', '1Cor 2:2'],
  //   "correct_option": 2,
  // },
  // {
  //   "id": 14,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 2:2', 'John 4:5', 'John 5:5', 'John 7:7'],
  //   "correct_option": 3,
  // },
  // {
  //   "id":15,
  //   "question": "Now of the things which we have spoken this is the sum: We have such an high priest, who is set on the right hand of the throne of the Majesty in the heavens;",
  //   "options": ['Heb 8:1', 'Titus 2:7', 'Jude 1:2', '1Pet 2:8'],
  //   "correct_option": 0,
  // },
  // {
  //   "id": 16,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 17,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 18,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 19,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },
  // {
  //   "id": 20,
  //   "question": "The world cannot hate you; but me it hateth, because I testify of it, that the works thereof are evil.",
  //   "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
  //   "correct_option": 3,
  // },

];
