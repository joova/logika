
import 'dart:html';

import 'package:angular/angular.dart';

import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logika/src/logger_service.dart';
import 'package:logika/src/routes.dart';
import 'package:logika/src/route_paths.dart';


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
    routerDirectives,
  ],
  providers: [ClassProvider(Logger)],
  exports: [RoutePaths, Routes],
)
class AppComponent {
  final Logger _logger;
 
  bool customWidth = false;
  bool end = false;
  bool overlay = false;

  
  AppComponent(this._logger);

  void w3_open() {
    // _logger.log("w3 open ....");
    // Get the Sidebar
    var mySidebar = querySelector("#mySidebar");

    // Get the DIV with overlay effect
    var overlayBg = querySelector("#myOverlay");

    if (mySidebar.style.display == 'block') {
            mySidebar.style.display = 'none';
            overlayBg.style.display = "none";
        } else {
            mySidebar.style.display = 'block';
            overlayBg.style.display = "block";
        }
  }

  void w3_close() {
    // _logger.log("w3 open ....");
    // Get the Sidebar
    var mySidebar = querySelector("#mySidebar");

    // Get the DIV with overlay effect
    var overlayBg = querySelector("#myOverlay");
    mySidebar.style.display = 'none';
    overlayBg.style.display = "none";
  }

}
