// void main() {
//   /*
//   var name = "mario";
//   // name is now of type string, cant change to any other type
//   print(name);

//   final age = 26; // runtime const
//   const isOpen = 20; //compile time const

//   print(age + 10);
//   print('my name is $name');
//   */

//   // String name = 'mario';
//   // int age = 25;
//   // const bool isOpen = true;
//   // double avgRating = 7.9;
//   // int? point; // can be null
//   // print(point);

//   // print(greet(10000, name: 'Adil', age: 22));

//   final List<int> scores = [50, 75, 20, 99];
//   // scores.add(10);
//   // scores.remove(3);
//   // scores.shuffle();
//   // print(scores.indexOf(20));
//   // print(scores);

//   // Set<String> names = {"mario", "luigi"};
//   // // set is a unordered uniques collection of elements

//   // names.add('bowser');
//   // names.add('bowser');
//   // print(names);

//   for (int score in scores.where((scr) => scr > 20)) {
//     print(score);
//   }
// }

// int greet(double salary, {String? name, required int age}) {
//   // this function returns dynamic
//   return 1;
// }

// class MenuItem {
//   String? title;
//   String subtitle;

//   MenuItem({this.title, required this.subtitle});
// }

void main() async {
  // fetchPost().then((p) {
  //   print(p.title);
  //   print(p.userId);
  // });

  final p = await fetchPost();
}

Future<Post> fetchPost() {
  const delay = Duration(seconds: 3);
  return Future.delayed(delay, () {
    return Post(title: 'new post', userId: 123);
  });
}

class Post {
  final String title;
  final int userId;

  Post({required this.title, required this.userId});
}
