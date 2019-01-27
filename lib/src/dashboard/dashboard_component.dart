import 'dart:async';

import 'dart:html';
import 'dart:math' as math;

import 'package:chartjs/chartjs.dart';


import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:logika/src/logger_service.dart';

import 'dashboard_service.dart';

@Component(
  selector: 'dashboard',
  styleUrls: ['dashboard_component.css'],
  templateUrl: 'dashboard_component.html',
  directives: [
    MaterialCheckboxComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
  providers: [
    ClassProvider(DashboardService),
    ClassProvider(Logger)
  ],
)
class DashboardComponent implements OnInit {
  final Logger _logger;
  final DashboardService dashboardService;

  DashboardComponent(this._logger, this.dashboardService);

  var rnd = math.Random();
  var months = <String>['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
  var data1 = <int>[80, 20, 30, 40, 10, 6, 18, 76, 13, 32, 21, 97];
  var data2 = <int>[37, 89, 12, 65, 50, 15, 54, 46, 65, 30, 57, 19];

  @override
  Future<Null> ngOnInit() async {
    var data = LinearChartData(labels: months, datasets: <ChartDataSets>[
      ChartDataSets(
          label: 'Inbound',
          backgroundColor: 'rgba(220,220,220,0.2)',
          data: data1),
      ChartDataSets(
          label: 'Outbound',
          backgroundColor: 'rgba(151,187,205,0.2)',
          data: data2)
    ]);

    var config = ChartConfiguration(
        type: 'line', data: data, options: ChartOptions(responsive: true));

    var canvas = querySelector('#canvas') as CanvasElement;
    _logger.log('canvas' + canvas.width.toString());
    
    Chart(canvas, config);
  }

}
