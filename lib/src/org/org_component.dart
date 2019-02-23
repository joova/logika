import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:logika/src/pagination_service.dart';

import 'package:logika/src/org/org.dart';

import 'org_service.dart';

@Component(
  selector: 'org',
  styleUrls: ['org_component.css'],
  templateUrl: 'org_component.html',
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
    ClassProvider(OrgService), 
    overlayBindings
  ],
)

class OrgComponent implements OnInit {
  final OrgService orgService;

  List<Org> listOrg = [];
  Org org = new Org();
  String _text = "";

  int current = 1;
  int limit = 10;
  List pages;

  bool showAddOrgDialog = false;

  OrgComponent(this.orgService);

  @override
  Future<Null> ngOnInit() async {
    var paging = await _goToPage(1);
    pages = new List(paging.getPage());
    listOrg = paging.getData();
  }

  Future<Null> searchOrg(String text) async {
    _text = text;
    var paging;
    if (_text != ""){
      paging = await _searchOrg(1);
    } else {
      paging = await _goToPage(1);
    }
    
    pages = new List(paging.getPage());
    listOrg = paging.getData();
  }

  Future<Pagination> _searchOrg(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging = await orgService.search(_text, offset, limit);
    return paging;
  }

  Future<Null> goToPage(int page) async {
    var paging = await _goToPage(page);
    listOrg = paging.getData();
  }

  Future<Null> prevPage() async {
    if(current > 1)
      current--;

    var paging = await _goToPage(current);
    listOrg = paging.getData();
  }

  Future<Null> nextPage() async {
    if(current < pages.length)
      current++;

    var paging = await _goToPage(current);
    listOrg = paging.getData();
  }

  Future<Pagination> _goToPage(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging;
    if (_text != ""){
      paging = await orgService.search(_text, offset, limit);
    } else {
      paging = await orgService.getPaging(offset, limit);
    }
    return paging;
  }

  void onSelect(Org selected) {
    org = selected;
    // print(org.id);
    showAddOrgDialog = true;
  }

  Future<void> add() async {
    var newOrg = await orgService.create(org);

    listOrg.add(newOrg);
    org = new Org();

    showAddOrgDialog = false;
  }

  Future<void> update() async {
    await orgService.update(org);
    org = new Org();

    showAddOrgDialog = false;
  }

  Org remove(int index) => listOrg.removeAt(index);
}
