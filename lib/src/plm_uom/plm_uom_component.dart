import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:logika/src/pagination_service.dart';

import 'package:logika/src/plm_uom/plm_uom.dart';

import 'plm_uom_service.dart';

@Component(
  selector: 'plm_uom',
  styleUrls: ['plm_uom_component.css'],
  templateUrl: 'plm_uom_component.html',
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
    ClassProvider(PlmUomService), 
    overlayBindings
  ],
)

class PlmUomComponent implements OnInit {
  final PlmUomService plmUomService;

  List<PlmUom> listPlmUom = [];
  PlmUom plmUom = new PlmUom();
  String _text = "";

  int current = 1;
  int limit = 10;
  List pages;

  bool showAddPlmUomDialog = false;
<<<<<<< HEAD
=======
  bool isAddNewRecord = true;
>>>>>>> abca9532612084dce3d7c4e3a978533ef6c8f024

  PlmUomComponent(this.plmUomService);

  @override
  Future<Null> ngOnInit() async {
    var paging = await _goToPage(1);
    pages = new List(paging.getPage());
    listPlmUom = paging.getData();
  }

  Future<Null> searchPlmUom(String text) async {
    _text = text;
    var paging;
    if (_text != ""){
      paging = await _searchPlmUom(1);
    } else {
      paging = await _goToPage(1);
    }
    
    pages = new List(paging.getPage());
    listPlmUom = paging.getData();
  }

  Future<Pagination> _searchPlmUom(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging = await plmUomService.search(_text, offset, limit);
    return paging;
  }

  Future<Null> goToPage(int page) async {
    var paging = await _goToPage(page);
    listPlmUom = paging.getData();
  }

  Future<Null> prevPage() async {
    if(current > 1)
      current--;

    var paging = await _goToPage(current);
    listPlmUom = paging.getData();
  }

  Future<Null> nextPage() async {
    if(current < pages.length)
      current++;

    var paging = await _goToPage(current);
    listPlmUom = paging.getData();
  }

  Future<Pagination> _goToPage(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging;
    if (_text != ""){
      paging = await plmUomService.search(_text, offset, limit);
    } else {
      paging = await plmUomService.getPaging(offset, limit);
    }
    return paging;
  }

  void onSelect(PlmUom selected) {
    plmUom = selected;
    print(plmUom.code);
<<<<<<< HEAD
    showAddPlmUomDialog = true;
=======

    isAddNewRecord = false;
    showAddPlmUomDialog = true;

>>>>>>> abca9532612084dce3d7c4e3a978533ef6c8f024
  }

  Future<void> add() async {
    var newPlmUom = await plmUomService.create(plmUom);

    listPlmUom.add(newPlmUom);
    plmUom = new PlmUom();

    showAddPlmUomDialog = false;
  }

  Future<void> update() async {
    await plmUomService.update(plmUom);
    plmUom = new PlmUom();

    showAddPlmUomDialog = false;
  }

<<<<<<< HEAD
  PlmUom remove(int index) => listPlmUom.removeAt(index);
=======
  PlmUom remove(int index) {
    plmUom=listPlmUom[index];
    plmUomService.delete(plmUom);
    return listPlmUom.removeAt(index);
  }
>>>>>>> abca9532612084dce3d7c4e3a978533ef6c8f024
}
