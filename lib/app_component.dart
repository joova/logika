
import 'package:angular/angular.dart';

import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:logika/src/dashboard/dashboard_component.dart';
import 'package:logika/src/logger_service.dart';
import 'package:logika/src/todo_list/todo_list_component.dart';


// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'logika-app',
  styleUrls: [
    'package:angular_components/app_layout/layout.scss.css',
    'app_component.css'
  ],
  templateUrl: 'app_component.html',
  directives: [
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialPersistentDrawerDirective,
    MaterialTemporaryDrawerComponent,
    MaterialToggleComponent,
    MaterialListComponent,
    MaterialListItemComponent,
    NgSwitch,
    NgSwitchWhen,
    TodoListComponent,
    DashboardComponent,
  ],
  providers: [ClassProvider(Logger)]
)
class AppComponent {
  final Logger _logger;
 
  bool customWidth = false;
  bool end = false;
  bool overlay = false;

  String component = 'dashboard';

  AppComponent(this._logger);

  void switchComponent(String comp){
    _logger.log('switchComponent $comp');
    this.component = comp;
  }
}
