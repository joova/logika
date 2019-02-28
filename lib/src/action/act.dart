class Act {
  String code;
  String name;


  Act({
    this.code, 
    this.name
  });

  factory Act.fromJson(Map<String, dynamic> act) => 
    Act(
      code: act['code'], 
      name: act['name']
    );

  Map toJson() => {
    'code': code, 
    'name': name
    };
}