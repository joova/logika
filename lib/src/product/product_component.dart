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

import 'package:logika/src/product/product.dart';

import 'product_service.dart';

@Component(
  selector: 'product',
  styleUrls: ['product_component.css'],
  templateUrl: 'product_component.html',
  directives: [
    displayNameRendererDirective,
    AutoDismissDirective,
    AutoFocusDirective,
    MaterialCheckboxComponent,
    MaterialSelectComponent,
    MaterialSelectItemComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialDialogComponent,
    ModalComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
  providers: [ClassProvider(ProductService), overlayBindings],
)
class ProductComponent implements OnInit {
  final ProductService productService;


  // data variable
  static List<UOM> listUom = [];
  static List<PlmType> listPlmType = [];
  static List<PlmCategory> listPlmCategory = [];

  List<Product> listProduct = [];
  Product product = new Product();
  String _text = "";

  int current = 1;
  int limit = 10;
  List pages;

  bool showAddProductDialog = false;
  bool isAddNewRecord = true;

  // selection component
  SelectionModel<UOM> uomSelection = SelectionModel.single();
  SelectionOptions<UOM> uomOptions;

  SelectionModel<PlmType> plmTypeSelection = SelectionModel.single();
  SelectionOptions<PlmType> plmTypeOptions;

  SelectionModel<PlmCategory> plmCategorySelection = SelectionModel.single();
  SelectionOptions<PlmCategory> plmCategoryOptions;

  ProductComponent(this.productService);

  @override
  Future<Null> ngOnInit() async {
    var paging = await _goToPage(1);
    pages = new List(paging.getPage());
    listProduct = paging.getData();

    listUom = await productService.getUoms();
    listPlmCategory = await productService.getCategories();
    listPlmType = await productService.getTypes();

    uomOptions = SelectionOptions.fromList(listUom);
    plmTypeOptions = SelectionOptions.fromList(listPlmType);
    plmCategoryOptions = SelectionOptions.fromList(listPlmCategory);
  }

  Future<Null> searchProduct(String text) async {
    _text = text;
    var paging;
    if (_text != "") {
      paging = await _searchProduct(1);
    } else {
      paging = await _goToPage(1);
    }

    pages = new List(paging.getPage());
    listProduct = paging.getData();
  }

  Future<Pagination> _searchProduct(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging = await productService.search(_text, offset, limit);
    return paging;
  }

  Future<Null> goToPage(int page) async {
    var paging = await _goToPage(page);
    listProduct = paging.getData();
  }

  Future<Null> prevPage() async {
    if (current > 1) current--;

    var paging = await _goToPage(current);
    listProduct = paging.getData();
  }

  Future<Null> nextPage() async {
    if (current < pages.length) current++;

    var paging = await _goToPage(current);
    listProduct = paging.getData();
  }

  Future<Pagination> _goToPage(int page) async {
    current = page;
    var offset = (page - 1) * limit;
    var paging;
    if (_text != "") {
      paging = await productService.search(_text, offset, limit);
    } else {
      paging = await productService.getPaging(offset, limit);
    }
    return paging;
  }

  void onSelect(Product selected) {
    product = selected;
    // print(product.id);
    showAddProductDialog = true;
    isAddNewRecord = false;
  }

  Future<void> add() async { 
    product.uom = uomSelection.selectedValues.first;
    product.type = plmTypeSelection.selectedValues.first;
    product.category = plmCategorySelection.selectedValues.first;
    // print(product);
    var newProduct = await productService.create(product);

    listProduct.add(newProduct);
    product = new Product();

    showAddProductDialog = false;
  }
  

  Future<void> update() async {

    product.uom = uomSelection.selectedValues.first;
    product.category= plmCategorySelection.selectedValues.first;
    product.type= plmTypeSelection.selectedValues.first;

    await productService.update(product);
    product = new Product();

    showAddProductDialog = false;
  }
  
  Product remove(int index) {
    product = listProduct[index];
    productService.delete(product);
    return listProduct.removeAt(index);
  }
}
