import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:logika/src/pagination_service.dart';

import 'package:logika/src/resource/resource.dart';

import 'resource_service.dart';

@Component(
  selector: 'resource',
  styleUrls: ['resource_component.css'],
  templateUrl: 'resource_component.html',
  directives: [
    AutoDismissDirective,
    AutoFocusDirective,
    MaterialCheckboxComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialDialogComponent,
    ModalComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
  providers: [
    ClassProvider(ResourceService), 
    overlayBindings
  ],
)

class ResourceComponent implements OnInit {
  final ResourceService resourceService;

  List<Resource> listResource = [];
  Resource resource = new Resource();
  String _text = "";

  int current = 1;
  int limit = 10;
  List pages;

  bool showAddResourceDialog = false;

  ResourceComponent(this.resourceService);

  @override
  Future<Null> ngOnInit() async {
    var paging = await _goToPage(1);
    pages = new List(paging.getPage());
    listResource = paging.getData();
  }

  Future<Null> searchResource(String text) async {
    _text = text;
    var paging;
    if (_text != ""){
      paging = await _searchResource(1);
    } else {
      paging = await _goToPage(1);
    }
    
    pages = new List(paging.getPage());
    listResource = paging.getData();
  }

  Future<Pagination> _searchResource(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging = await resourceService.search(_text, offset, limit);
    return paging;
  }

  Future<Null> goToPage(int page) async {
    var paging = await _goToPage(page);
    listResource = paging.getData();
  }

  Future<Null> prevPage() async {
    if(current > 1)
      current--;

    var paging = await _goToPage(current);
    listResource = paging.getData();
  }

  Future<Null> nextPage() async {
    if(current < pages.length)
      current++;

    var paging = await _goToPage(current);
    listResource = paging.getData();
  }

  Future<Pagination> _goToPage(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging;
    if (_text != ""){
      paging = await resourceService.search(_text, offset, limit);
    } else {
      paging = await resourceService.getPaging(offset, limit);
    }
    return paging;
  }

  void onSelect(Resource selected) {
    resource = selected;
    // print(org.id);
    showAddResourceDialog = true;
  }

  Future<void> add() async {
    var newResource = await resourceService.create(resource);

    listResource.add(newResource);
    resource = new Resource();

    showAddResourceDialog = false;
  }

  Future<void> update() async {
    await resourceService.update(resource);
    resource = new Resource();

    showAddResourceDialog = false;
  }

  Resource remove(int index) => listResource.removeAt(index);
}
