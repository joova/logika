import 'package:angular_components/model/ui/display_name.dart';

class Resource implements HasUIDisplayName {
  String id;
  String name;
  String uri;


  Resource({
    this.id, 
    this.name,
    this.uri
  });

  factory Resource.fromJson(Map<String, dynamic> org) => 
    Resource(
      id: org['id'], 
      name: org['name'],
      uri: org['uri']
    );

  Map toJson() => {
    // 'id': _id, 
    'name': name,
    'uri': uri
    };

  @override
  String get uiDisplayName => name;
}