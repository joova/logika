import 'package:angular_components/model/ui/display_name.dart';


class Priv {
  String id;
  Resource resource;
  IdmAction action;


  Priv({
    this.id, 
    this.resource,
    this.action,
  });

  factory Priv.fromJson(Map<String, dynamic> priv) => 
    Priv(
      id: priv['id'], 
      resource: Resource.fromJson(priv['resource']),
      action: IdmAction.fromJson(priv['action']),
    );

  Map toJson() => {
    // 'id': _id, 
    'resource': resource.toJson(),
    'action':action.toJson()
    };
}

class Resource  implements HasUIDisplayName {
  final String id;
  final String name;
  final String uri;

  const Resource({
    this.id, 
    this.name,
    this.uri,
  });

  factory Resource.fromJson(Map<String, dynamic> res) => 
    Resource(
      id: res['id'], 
      name: res['name'],
      uri: res['uri']
    );

    Map toJson() => {
      'id': id, 
      'name': name,
      'uri': uri
    };

  @override
  String get uiDisplayName => name;
  bool operator ==(Object other) => (other is Resource && this.id == other.id);
}

class IdmAction  implements HasUIDisplayName {
  final String code;
  final String name;
 
  const IdmAction({
    this.code, 
    this.name
  });

  factory IdmAction.fromJson(Map<String, dynamic> act) => 
    IdmAction(
      code: act['code'], 
      name: act['name']
    );

  Map toJson() => {
    'code': code, 
    'name': name
    };

  @override
  String get uiDisplayName => name;

  bool operator ==(Object other) => (other is IdmAction && this.code == other.code);
}