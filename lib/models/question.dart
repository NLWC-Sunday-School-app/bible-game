
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
    "question": "Who is the greatest man in the bible?",
    "options": ['James 4:1', 'James 4:1', 'James 4:1', 'James 4:1'],
    "answer_index": 0,
  },
  {
    "id": 2,
    "question": "Blessed is he who comes to the name of?",
    "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
    "answer_index": 1,
  },
  {
    "id": 3,
    "question": "What is man that thou art mindful of him?",
    "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
    "answer_index": 2,
  },
  {
    "id": 4,
    "question": "This is life eternal that might know the only true God?",
    "options": ['John 4:1', 'John 4:1', 'John 4:1', 'John 4:1'],
    "answer_index": 3,
  },
];
