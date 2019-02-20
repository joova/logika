import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:logika/src/pagination_service.dart';

import 'package:logika/src/user/user.dart';

import 'user_service.dart';

@Component(
  selector: 'user',
  styleUrls: ['user_component.css'],
  templateUrl: 'user_component.html',
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
    ClassProvider(UserService), 
    overlayBindings
  ],
)

class UserComponent implements OnInit {
  final UserService userService;

  List<User> listUser = [];
  User user = new User();
  String _text = "";

  int current = 1;
  int limit = 10;
  List pages;

  bool showAddUserDialog = false;

  UserComponent(this.userService);

  @override
  Future<Null> ngOnInit() async {
    var paging = await _goToPage(1);
    pages = new List(paging.getPage());
    listUser = paging.getData();
  }

  Future<Null> searchUser(String text) async {
    _text = text;
    var paging;
    if (_text != ""){
      paging = await _searchUser(1);
    } else {
      paging = await _goToPage(1);
    }
    
    pages = new List(paging.getPage());
    listUser = paging.getData();
  }

  Future<Pagination> _searchUser(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging = await userService.search(_text, offset, limit);
    return paging;
  }

  Future<Null> goToPage(int page) async {
    var paging = await _goToPage(page);
    listUser = paging.getData();
  }

  Future<Null> prevPage() async {
    if(current > 1)
      current--;

    var paging = await _goToPage(current);
    listUser = paging.getData();
  }

  Future<Null> nextPage() async {
    if(current < pages.length)
      current++;

    var paging = await _goToPage(current);
    listUser = paging.getData();
  }

  Future<Pagination> _goToPage(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging;
    if (_text != ""){
      paging = await userService.search(_text, offset, limit);
    } else {
      paging = await userService.getPaging(offset, limit);
    }
    return paging;
  }

  void onSelect(User selected) {
    user = selected;
    // print(user.id);
    showAddUserDialog = true;
  }

  Future<void> add() async {
    user.password = "password";
    var newUser = await userService.create(user);

    listUser.add(newUser);
    user = new User();

    showAddUserDialog = false;
  }

  Future<void> update() async {
    await userService.update(user);
    user = new User();

    showAddUserDialog = false;
  }

  User remove(int index) => listUser.removeAt(index);
}
