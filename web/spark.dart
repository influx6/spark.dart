library spark.spec;

import 'dart:html';
import 'package:sparkflow/sparkflow.dart';
import 'package:hub/hubclient.dart';
import 'package:spark_elements/elements.dart';
import 'package:spark/spark.dart';

void main(){
    
   Spark.registerComponents();
  
   var list = SparkRegistry.generate('spark/domcards');
   var filter = SparkRegistry.generate('spark/eventfilter');
   var query = SparkRegistry.generate('elements/querySelector');
  
   list.port('out:elem').tap(Funcs.compose(print,(e){ return "listElem:$e"; }));
   list.port('events:events').tap(Funcs.compose(print,(e){ 
     return "listEvents:$e ${e.get('eventType')} ${ e.data.type}"; 
   }));
   filter.port('state:pass').tap(Funcs.compose(print,(e){ 
     return "passedFilter:$e ${e.get('eventType')} ${ e.data.type}"; 
   }));
   filter.port('state:fail').tap(Funcs.compose(print,(e){ 
     return "failedFilter:$e ${e.get('eventType')} ${ e.data.type}"; 
   }));

   query.port('out:val').bindPort(list.port('in:elem'));
   list.port('events:events').bindPort(filter.port('ev:events'));

  
   query.port('in:query').send('#component_lists');
   query.port('in:elem').send(document.body);

   /*new Time(const Duration(seconds:3),(t){*/
     filter.port('type:allowed').send("none");
   /*});*/

   /*new Time(const Duration(seconds:5),(t){*/
     filter.port('type:allowed').send("drag");
   /*});*/

     filter.port('state:invert').send(true);
}
