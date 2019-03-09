import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:logika/src/pagination_service.dart';

import 'package:logika/src/action/act.dart';

import 'act_service.dart';

@Component(
  selector: 'act',
  styleUrls: ['act_component.css'],
  templateUrl: 'act_component.html',
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
    ClassProvider(ActService), 
    overlayBindings
  ],
)

class ActComponent implements OnInit {
  final ActService actService;

  List<Act> listAct = [];
  Act act = new Act();
  String _text = "";

  int current = 1;
  int limit = 10;
  List pages;

  bool showAddActDialog = false;

  ActComponent(this.actService);

  @override
  Future<Null> ngOnInit() async {
    var paging = await _goToPage(1);
    pages = new List(paging.getPage());
    listAct = paging.getData();
  }

  Future<Null> searchAct(String text) async {
    _text = text;
    var paging;
    if (_text != ""){
      paging = await _searchAct(1);
    } else {
      paging = await _goToPage(1);
    }
    
    pages = new List(paging.getPage());
    listAct = paging.getData();
  }

  Future<Pagination> _searchAct(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging = await actService.search(_text, offset, limit);
    return paging;
  }

  Future<Null> goToPage(int page) async {
    var paging = await _goToPage(page);
    listAct = paging.getData();
  }

  Future<Null> prevPage() async {
    if(current > 1)
      current--;

    var paging = await _goToPage(current);
    listAct = paging.getData();
  }

  Future<Null> nextPage() async {
    if(current < pages.length)
      current++;

    var paging = await _goToPage(current);
    listAct = paging.getData();
  }

  Future<Pagination> _goToPage(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging;
    if (_text != ""){
      paging = await actService.search(_text, offset, limit);
    } else {
      paging = await actService.getPaging(offset, limit);
    }
    return paging;
  }

  void onSelect(Act selected) {
    act = selected;
    print(act.code);
    showAddActDialog = true;
  }

  Future<void> add() async {
    var newAct = await actService.create(act);

    listAct.add(newAct);
    act = new Act();

    showAddActDialog = false;
  }

  Future<void> update() async {
    await actService.update(act);
    act = new Act();

    showAddActDialog = false;
  }

  Act remove(int index) {
    act=listAct[index];
    actService.delete(act);
    return listAct.removeAt(index);
  } 
}
