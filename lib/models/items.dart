// ignore_for_file: public_member_api_docs, sort_constructors_first

class Items {
  late String name;
  bool done;

  Items({
    required this.name,
    required this.done,
  });

  void setDone(bool value) {
    done = value;
  }




  Items copyWith({
    String? name,
    bool? done,
  }) {
    return Items(
      name: name ?? this.name,
      done: done ?? this.done,
    );
  }


  @override
  String toString() => 'items(name: $name, done: $done)';

  @override
  bool operator ==(covariant Items other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.done == done;
  }

  @override
  int get hashCode => name.hashCode ^ done.hashCode;
}
