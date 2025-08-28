import 'package:flutter/widgets.dart';

import 'package:ecomly_client/core/common/widgets/dynamic_loader_widget.dart';

extension WidgetExt on Widget {
  Widget loading(bool isLoading) {
    return DynamicLoaderWidget(originalWidget: this, isLoading: isLoading);
  }
}
