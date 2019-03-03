import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/material_select/display_name.dart';
import 'package:angular_components/material_select/material_select.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:logika/src/pagination_service.dart';

import 'package:logika/src/priv/priv.dart';

import 'priv_service.dart';

@Component(
  selector: 'priv',
  styleUrls: ['priv_component.css'],
  templateUrl: 'priv_component.html',
  directives: [
    displayNameRendererDirective,
    
    AutoDismissDirective,
    AutoFocusDirective,
    MaterialSelectComponent,
    MaterialSelectItemComponent,
    MaterialCheckboxComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialDialogComponent,
    ModalComponent,
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

  // data variable
  static List<Resource> listResource = [];
  static List<IdmAction> listAction = [];

  List<Priv> listPriv = [];
  Priv priv = new Priv();
  String _text = "";

  // paging variable
  int current = 1;
  int limit = 10;
  List pages;

  // dispaly form input
  bool showAddPrivDialog = false;
  bool isAddNewRecord = true;
  
  // selection component
  SelectionModel<IdmAction> actionSelection = SelectionModel.single();
  SelectionOptions<IdmAction> actionOptions;

  SelectionModel<Resource> resourceSelection = SelectionModel.single();
  SelectionOptions<Resource> resourceOptions;


  PrivComponent(this.privService);

  @override
  Future<Null> ngOnInit() async {
    var paging = await _goToPage(1);
    pages = new List(paging.getPage());

    listPriv = paging.getData();
    listResource = await privService.getResources();
    listAction = await privService.getActions();

    actionOptions = SelectionOptions.fromList(listAction);
    resourceOptions = SelectionOptions.fromList(listResource);
    
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
    isAddNewRecord = false;
    showAddPrivDialog = true;

    print(resourceSelection.select(priv.resource));
  }

  Future<void> add() async {
    priv.resource = resourceSelection.selectedValues.first;
    priv.action = actionSelection.selectedValues.first;

    var newpriv = await privService.create(priv);

    listPriv.add(newpriv);
    priv = new Priv();

    showAddPrivDialog = false;
  }

  Future<void> update() async {
    priv.resource = resourceSelection.selectedValues.first;
    priv.action = actionSelection.selectedValues.first;

    await privService.update(priv);
    priv = new Priv();

    showAddPrivDialog = false;
  }

  Priv remove(int index) {
    priv = listPriv[index];
    privService.delete(priv);
    return listPriv.removeAt(index);
  }
}
