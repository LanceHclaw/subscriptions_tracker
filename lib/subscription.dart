class Subscription {
  int key;
  String title;
  String description;
  
  Subscription({
    required this.key,
    required this.title,
    required this.description
  });

  Subscription.fromJson(Map<String, dynamic> json)
  : key = json['key'],
    title = json['title'],
    description = json['description']; 

  Map<String, dynamic> toJson() => {
    'key': key,
    'title': title,
    'description': description
  };
}