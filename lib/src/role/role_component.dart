import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:logika/src/pagination_service.dart';

import 'package:logika/src/role/role.dart';

import 'role_service.dart';

@Component(
  selector: 'role',
  styleUrls: ['role_component.css'],
  templateUrl: 'role_component.html',
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
    ClassProvider(RoleService), 
    overlayBindings
  ],
)

class RoleComponent implements OnInit {
  final RoleService roleService;

  List<Role> listRole = [];
  Role role = new Role();
  String _text = "";

  int current = 1;
  int limit = 10;
  List pages;

  bool showAddRoleDialog = false;

  RoleComponent(this.roleService);

  @override
  Future<Null> ngOnInit() async {
    var paging = await _goToPage(1);
    pages = new List(paging.getPage());
    listRole = paging.getData();
  }

  Future<Null> searchRole(String text) async {
    _text = text;
    var paging;
    if (_text != ""){
      paging = await _searchRole(1);
    } else {
      paging = await _goToPage(1);
    }
    
    pages = new List(paging.getPage());
    listRole = paging.getData();
  }

  Future<Pagination> _searchRole(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging = await roleService.search(_text, offset, limit);
    return paging;
  }

  Future<Null> goToPage(int page) async {
    var paging = await _goToPage(page);
    listRole = paging.getData();
  }

  Future<Null> prevPage() async {
    if(current > 1)
      current--;

    var paging = await _goToPage(current);
    listRole = paging.getData();
  }

  Future<Null> nextPage() async {
    if(current < pages.length)
      current++;

    var paging = await _goToPage(current);
    listRole = paging.getData();
  }

  Future<Pagination> _goToPage(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging;
    if (_text != ""){
      paging = await roleService.search(_text, offset, limit);
    } else {
      paging = await roleService.getPaging(offset, limit);
    }
    return paging;
  }

  void onSelect(Role selected) {
    role = selected;
    // print(role.id);
    showAddRoleDialog = true;
  }

  Future<void> add() async {
    var newOrg = await roleService.create(role);

    listRole.add(newOrg);
    role = new Role();

    showAddRoleDialog = false;
  }

  Future<void> update() async {
    await roleService.update(role);
    role = new Role();

    showAddRoleDialog = false;
  }

  Role remove(int index) => listRole.removeAt(index);
}
