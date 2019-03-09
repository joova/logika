import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:logika/src/pagination_service.dart';

import 'package:logika/src/plm_type/plm_type.dart';

import 'plm_type_service.dart';

@Component(
  selector: 'plm_type',
  styleUrls: ['plm_type_component.css'],
  templateUrl: 'plm_type_component.html',
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
    ClassProvider(PlmTypeService),
    overlayBindings
  ],
)

class PlmTypeComponent implements OnInit {
  final PlmTypeService plmTypeService;

  List<PlmType> listPlmType = [];
  PlmType plmType = new PlmType();
  String _text = "";

  int current = 1;
  int limit = 10;
  List pages;

  bool showAddPlmTypeDialog = false;
  bool isAddNewRecord = true;

  PlmTypeComponent(this.plmTypeService);

  @override
  Future<Null> ngOnInit() async {
    var paging = await _goToPage(1);
    pages = new List(paging.getPage());
    listPlmType = paging.getData();
  }

  Future<Null> searchPlmType(String text) async {
    _text = text;
    var paging;
    if (_text != ""){
      paging = await _searchPlmType(1);
    } else {
      paging = await _goToPage(1);
    }
    
    pages = new List(paging.getPage());
    listPlmType = paging.getData();
  }

  Future<Pagination> _searchPlmType(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging = await plmTypeService.search(_text, offset, limit);
    return paging;
  }

  Future<Null> goToPage(int page) async {
    var paging = await _goToPage(page);
    listPlmType = paging.getData();
  }

  Future<Null> prevPage() async {
    if(current > 1)
      current--;

    var paging = await _goToPage(current);
    listPlmType = paging.getData();
  }

  Future<Null> nextPage() async {
    if(current < pages.length)
      current++;

    var paging = await _goToPage(current);
    listPlmType = paging.getData();
  }

  Future<Pagination> _goToPage(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging;
    if (_text != ""){
      paging = await plmTypeService.search(_text, offset, limit);
    } else {
      paging = await plmTypeService.getPaging(offset, limit);
    }
    return paging;
  }

  void onSelect(PlmType selected) {
    plmType = selected;
    print(plmType.code);

    isAddNewRecord = false;
    showAddPlmTypeDialog = true;

  }

  Future<void> add() async {
    var newPlmType = await plmTypeService.create(plmType);

    listPlmType.add(newPlmType);
    plmType = new PlmType();

    showAddPlmTypeDialog = false;
  }

  Future<void> update() async {
    await plmTypeService.update(plmType);
    plmType = new PlmType();

    showAddPlmTypeDialog = false;
  }

  PlmType remove(int index) {
    plmType=listPlmType[index];
    plmTypeService.delete(plmType);
    return listPlmType.removeAt(index);
  } 
}
