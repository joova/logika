import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import 'dashboard/dashboard_component.template.dart' as dashboard_template;
import 'user/user_component.template.dart' as user_template;
import 'org/org_component.template.dart' as org_template;
import 'resource/resource_component.template.dart' as resource_template;
import 'priv/priv_component.template.dart' as priv_template;
import 'setting/setting_component.template.dart' as setting_template;

export 'route_paths.dart';

class Routes {
  static final dashboard = RouteDefinition(
    routePath: RoutePaths.dashboard,
    component: dashboard_template.DashboardComponentNgFactory,
  );

  static final user = RouteDefinition(
    routePath: RoutePaths.user,
    component: user_template.UserComponentNgFactory,
  );

  static final org = RouteDefinition(
    routePath: RoutePaths.org,
    component: org_template.OrgComponentNgFactory,
  );

  static final resource = RouteDefinition(
    routePath: RoutePaths.resource,
    component: resource_template.ResourceComponentNgFactory,
  );

    static final priv = RouteDefinition(
    routePath: RoutePaths.priv,
    component: priv_template.PrivComponentNgFactory,
  );

  static final setting = RouteDefinition(
    routePath: RoutePaths.setting,
    component: setting_template.SettingComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    dashboard,
    user,
    org,
    priv,
    resource,
    setting
  ];
}