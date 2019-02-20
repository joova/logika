import 'dart:html';

import 'package:chartjs/chartjs.dart';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:logika/src/logger_service.dart';

import 'dashboard_service.dart';

@Component(
  selector: 'dashboard',
  styleUrls: [
    'package:angular_components/css/mdc_web/card/mdc-card.scss.css',
    'dashboard_component.css'
    ],
  templateUrl: 'dashboard_component.html',
  directives: [
    MaterialCheckboxComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
  providers: [ClassProvider(DashboardService), ClassProvider(Logger)],
)

class DashboardComponent implements AfterContentInit, AfterViewInit  {

  final Logger _logger;
  final DashboardService dashboardService;
  
  Element _element;
  DashboardComponent(this._element, this._logger, this.dashboardService);

  @override
  void ngAfterViewInit() {
    _logger.log("after view init ...");
    // var rnd = math.Random();
    var months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr',
      'Mei', 'Jun', 'Jul', 'Agu',
      'Sep', 'Okt', 'Nov', 'Des'
    ];
    var data1 = <int>[80, 20, 30, 40, 10, 6, 18, 76, 13, 32, 21, 97];
    var data2 = <int>[37, 89, 12, 65, 50, 15, 54, 46, 65, 30, 57, 19];
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
    
    var canvas = _element.querySelector("#canvas");
    _logger.log(canvas);
    // Chart(canvas, config);
  }

  @override
  void ngAfterContentInit() {
    _logger.log("after content init ...");
    // canvas =  querySelector('#canvas') as CanvasElement;
    // _logger.log(canvasEl);
  }

}
