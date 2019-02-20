import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logika/src/logger_service.dart';
import 'package:logika/src/route_paths.dart';
import 'package:logika/src/routes.dart';

@Component(
  selector: 'dashboard',
  styleUrls: [
    'setting_component.css'
    ],
  templateUrl: 'setting_component.html',
  directives: [
    MaterialIconComponent,
    materialInputDirectives,
    routerDirectives,
    NgFor,
    NgIf,
  ],
  providers: [ClassProvider(Logger)],
  exports: [RoutePaths, Routes],
)

class SettingComponent implements OnInit  {

  final Logger _logger;

  SettingComponent(this._logger);

  @override
  void ngOnInit() {
    
  }
}