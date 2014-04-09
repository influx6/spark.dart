library spark;

import 'package:sparkflow/sparkflow.dart';
import 'package:hub/hubclient.dart';
import 'package:spark_elements/elements.dart';

class Spark{
  static registerComponents(){
      Component.registerComponents();
      /* SparkRegistry.register('spark'); */
  }
}

class DOMElement extends Element{
  
    void open(){}
    void closed(){}
    void hide(){}
    void show(){}

}
