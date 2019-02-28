import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:logika/src/pagination_service.dart';

import 'package:logika/src/priv/priv.dart';

import 'priv_service.dart';

@Component(
  selector: 'priv',
  styleUrls: ['priv_component.css'],
  templateUrl: 'priv_component.html',
  directives: [
    AutoDismissDirective,
    AutoFocusDirective,
    MaterialDropdownSelectComponent,
    MaterialSelectItemComponent,
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
    ClassProvider(PrivService), 
    overlayBindings
  ],
)

class PrivComponent implements OnInit {
  final PrivService privService;

  List<Priv> listPriv = [];
  var listResource = [];
  var listAction = [];
  Priv priv = new Priv();
  String _text = "";

  int current = 1;
  int limit = 10;
  List pages;

  bool showAddPrivDialog = false;

  PrivComponent(this.privService);

  @override
  Future<Null> ngOnInit() async {
    var paging = await _goToPage(1);
    pages = new List(paging.getPage());
    listPriv = paging.getData();
    listResource = await privService.getResources();
    listAction = await privService.getActions();
  }

  Future<Null> searchPriv(String text) async {
    _text = text;
    var paging;
    if (_text != ""){
      paging = await _searchPriv(1);
    } else {
      paging = await _goToPage(1);
    }
    
    pages = new List(paging.getPage());
    listPriv = paging.getData();
  }

  Future<Pagination> _searchPriv(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging = await privService.search(_text, offset, limit);
    return paging;
  }

  Future<Null> goToPage(int page) async {
    var paging = await _goToPage(page);
    listPriv = paging.getData();
  }

  Future<Null> prevPage() async {
    if(current > 1)
      current--;

    var paging = await _goToPage(current);
    listPriv = paging.getData();
  }

  Future<Null> nextPage() async {
    if(current < pages.length)
      current++;

    var paging = await _goToPage(current);
    listPriv = paging.getData();
  }

  Future<Pagination> _goToPage(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging;
    if (_text != ""){
      paging = await privService.search(_text, offset, limit);
    } else {
      paging = await privService.getPaging(offset, limit);
    }
    return paging;
  }

  void onSelect(Priv selected) {
    priv = selected;
    // print(priv.id);
    showAddPrivDialog = true;
  }

  Future<void> add() async {
    var newpriv = await privService.create(priv);

    listPriv.add(newpriv);
    priv = new Priv();

    showAddPrivDialog = false;
  }

  Future<void> update() async {
    await privService.update(priv);
    priv = new Priv();

    showAddPrivDialog = false;
  }

  Priv remove(int index) => listPriv.removeAt(index);
}
