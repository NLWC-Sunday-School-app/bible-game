 class SequenceGeneratorSingleton {
  static final SequenceGeneratorSingleton _instance = SequenceGeneratorSingleton._internal();

  SequenceGeneratorSingleton._internal(){

  }

  factory SequenceGeneratorSingleton(){
    return _instance;
  }

 }