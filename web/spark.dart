library spark.spec;

import 'dart:html';
import 'package:sparkflow/sparkflow.dart';
import 'package:hub/hubclient.dart';
import 'package:spark_elements/elements.dart';
import 'package:spark/spark.dart';

void main(){
    
   Spark.registerComponents();
  
   var list = SparkRegistry.generate('spark/domcards');
   var query = SparkRegistry.generate('elements/querySelector');
  
   list.boot();
   query.boot();

   query.port('in:elem').tap(Funcs.compose(print,(e){ return "elem:$e"; }));
   query.port('in:query').tap(Funcs.compose(print,(e){ return "query:$e"; }));
   query.port('out:val').tap(Funcs.compose(print,(e){ return "out:val:$e"; }));

   query.port('out:val').bindPort(list.port('in:elem'));

   list.port('out:elem').tap(Funcs.compose(print,(e){ return "listElem:$e"; }));
   list.port('events:events').tap(Funcs.compose(print,(e){ return "listEvents:$e"; }));
  
   query.port('in:query').send('#component_lists');
   query.port('in:elem').send(document.body);

}
