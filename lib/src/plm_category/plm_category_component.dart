import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:logika/src/pagination_service.dart';

import 'package:logika/src/plm_category/plm_category.dart';

import 'package:logika/src/plm_category/plm_category_service.dart';

@Component(
  selector: 'plm_category',
  styleUrls: ['plm_category_component.css'],
  templateUrl: 'plm_category_component.html',
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
    ClassProvider(PlmCategoryService), 
    overlayBindings
  ],
)

class PlmCategoryComponent implements OnInit {
  final PlmCategoryService plmCategoryService;

  List<PlmCategory> listPlmCategory = [];
  PlmCategory plmCategory = new PlmCategory();
  String _text = "";

  int current = 1;
  int limit = 10;
  List pages;

  bool showAddPlmCategoryDialog = false;
  bool isAddNewRecord = true;

  PlmCategoryComponent(this.plmCategoryService);

  @override
  Future<Null> ngOnInit() async {
    var paging = await _goToPage(1);
    pages = new List(paging.getPage());
    listPlmCategory = paging.getData();
  }

  Future<Null> searchPlmCategory(String text) async {
    _text = text;
    var paging;
    if (_text != ""){
      paging = await _searchPlmCategory(1);
    } else {
      paging = await _goToPage(1);
    }
    
    pages = new List(paging.getPage());
    listPlmCategory = paging.getData();
  }

  Future<Pagination> _searchPlmCategory(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging = await plmCategoryService.search(_text, offset, limit);
    return paging;
  }

  Future<Null> goToPage(int page) async {
    var paging = await _goToPage(page);
    listPlmCategory = paging.getData();
  }

  Future<Null> prevPage() async {
    if(current > 1)
      current--;

    var paging = await _goToPage(current);
    listPlmCategory = paging.getData();
  }

  Future<Null> nextPage() async {
    if(current < pages.length)
      current++;

    var paging = await _goToPage(current);
    listPlmCategory = paging.getData();
  }

  Future<Pagination> _goToPage(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging;
    if (_text != ""){
      paging = await plmCategoryService.search(_text, offset, limit);
    } else {
      paging = await plmCategoryService.getPaging(offset, limit);
    }
    return paging;
  }

  void onSelect(PlmCategory selected) {
    plmCategory = selected;
    print(plmCategory.code);

    isAddNewRecord = false;
    showAddPlmCategoryDialog = true;
  }

  Future<void> add() async {
    var newPlmCategory = await plmCategoryService.create(plmCategory);

    listPlmCategory.add(newPlmCategory);
    plmCategory = new PlmCategory();

    showAddPlmCategoryDialog = false;
  }

  Future<void> update() async {
    await plmCategoryService.update(plmCategory);
    plmCategory = new PlmCategory();

    showAddPlmCategoryDialog = false;
  }

  PlmCategory remove(int index) => listPlmCategory.removeAt(index);
}
