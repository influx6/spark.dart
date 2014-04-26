library spark;

import 'dart:html' as html;
import 'package:sparkflow/sparkflow.dart';
import 'package:hub/hubclient.dart';
import 'package:spark_elements/elements.dart';

class Spark{
  static registerComponents(){
      Component.registerComponents();
      Elements.registerComponents();
      SparkRegistry.register('spark','domcards',DOMCards.create);
      SparkRegistry.register('spark','eventfilter',EventFilter.create);
      SparkRegistry.register('spark','eventreactor',EventReactor.create);
  }

  static isEvent(n) => n is html.Event;
}

class DOMCards extends Element{
  MapDecorator eventcards;

  static create() => new DOMCards();

  DOMCards(){
    this.meta('desc','provides a self contained dom element');

    this.eventcards = MapDecorator.create();
    //adds a new event group space for domelement events
    this.createSpace('events');
    //takes in a string name of an event to be notified about
    this.makeInport('events:sub');
    //takes in a string id of an event to stop notifying about
    this.makeInport('events:unsub');
    //sends out event packets that occur with the dom element which it is listening to
    this.makeOutport('events:events');

    this.port('events:sub').pause();
    this.port('events:unsub').pause();
  
    this.port('events:sub').forceCondition(Valids.isString);
    this.port('events:unsub').forceCondition(Valids.isString);

    this.port('events:sub').tap(this.notifyEvent);
    this.port('events:unsub').tap(this.unNotifyEvent);

    this.port('events:sub').tap(this.notifyEvent);
    this.port('events:unsub').tap(this.unNotifyEvent);

    this.port('in:elem').tap((pack){
      
      this.port('events:sub').resume();
      this.port('events:unsub').resume();

      this.port('events:sub').send('error');
      this.port('events:sub').send('focus');
      this.port('events:sub').send('drag');
      this.port('events:sub').send('click');
      this.port('events:sub').send('select');
      this.port('events:sub').send('search');
      this.port('events:sub').send('load');
      this.port('events:sub').send('scroll');
      this.port('events:sub').send('select');
      this.port('events:sub').send('copy');
      this.port('events:sub').send('paste');
      this.port('events:sub').send('submit');
      this.port('events:sub').send('cancel');
      this.port('events:sub').send('blur');
      this.port('events:sub').send('abort');
      this.port('events:sub').send('drop');
      this.port('events:sub').send('invalid');

      /*this.port('events:sub').send('mouseover');*/
      /*this.port('events:sub').send('mousemove');*/
      /*this.port('events:sub').send('mouseout');*/
      /*this.port('events:sub').send('mousedown');*/
      /*this.port('events:sub').send('mouseup');*/
      /*this.port('events:sub').send('mouseleave');*/
      /*this.port('events:sub').send('mousewheel');*/
      /*this.port('events:sub').send('mouseenter');*/
      this.port('events:sub').send('dragover');
      this.port('events:sub').send('dragend');
      this.port('events:sub').send('dragstart');
      this.port('events:sub').send('dragenter');
      this.port('events:sub').send('dragleave');
      /*this.port('events:sub').send('fullscreenchange');*/
      /*this.port('events:sub').send('fullscreenerror');*/
      this.port('events:sub').send('keydown');
      this.port('events:sub').send('keyup');
      this.port('events:sub').send('keypress');
      this.port('events:sub').send('selectstart');
      this.port('events:sub').send('touchcancel');
      this.port('events:sub').send('touchleave');
      this.port('events:sub').send('touchenter');
      this.port('events:sub').send('touchstart');
      this.port('events:sub').send('touchmove');
      this.port('events:sub').send('transitionevent');

      this.port('events:sub').send('beforecut');
      this.port('events:sub').send('beforecopy');
      this.port('events:sub').send('beforepaste');
      this.port('events:sub').send('contextmenu');
      
    });

  }

  void notifyEvent(packet){
    if(this.eventcards.has(packet.data)) return null;
    var fn = (e){
      var pack = this.port('events:events').createDataPacket(e);
      pack.update('eventType',packet.data);
      return this.port('events:events').send(pack);
    };

    this.eventcards.add(packet.data,fn);
    this.elem.addEventListener(packet.data,fn);
  }

  void unNotifyEvent(packet){
    if(!this.eventcards.has(packet.data)) return null;
    var fn = this.eventcards.destroy(packet.data);
    this.elem.addEventListener(packet.data,fn);
  }

}



class EventFilter extends Component{
  var allowed = "all";
  bool reverse = false;

  static create() => new EventFilter();

  EventFilter(){

    this.createSpace('ev');
    this.createSpace('state');
    this.createSpace('type');

    this.makeInport('type:allowed',
        meta:{'description':'takes a string or list of allowed event names' });
    this.makeInport('ev:events',
        meta:{'description':"the port where all events comes in"});
    this.makeInport('state:invert',
        meta:{'description':"takes a bool operation that inverts the operation"});

    this.makeOutport('state:pass');
    this.makeOutport('state:fail');
    
    this.port('state:invert').forceCondition(Valids.isBool);
    this.port('ev:events').forceCondition(Spark.isEvent);

    this.port('state:invert').tap((n){
      this.reverse = n.data;
    });

    this.port('type:allowed').forceCondition((n){
      return (Valids.isString(n) || Valids.isList(n) ? true : false);
    });

    this.port('type:allowed').tap((n){
      this.allowed = n.data;
    });
  
    this.port('ev:events').tap(this.filter);

  }

  void _handle(fn,fe,n){
      var type = n.has('eventType') ? n.get('eventType') : n.data.type;

      if(Valids.isString(this.allowed)){
      
        Funcs.when(Valids.match(this.allowed,"all"),(){
           return fn(n);
        });

        Funcs.when(Valids.match(this.allowed,"none"),(){
           return fe(n);
        });

        Funcs.when(Valids.match(type,this.allowed),(){
           return fn(n);
        },(){
          return fe(n);
        });
  
        return null;
      }


      if(Valids.isList(this.allowed))
        return Funcs.when(this.allowed.contains(type),(){
          return fn(n);
        },(){
          return fe(n);
        });

      return fe;
  }

  void filter(m){

    Funcs.when(this.reverse,(){

       return this._handle((n){
          return this.sendFailure(n);
       },(n){
          return this.port('state:pass').send(n);
       },m);

    },(){
        
       return this._handle((n){
          return this.port('state:pass').send(n);
       },(n){
          return this.sendFailure(n);
       },m);

    });


  }

  void sendFailure(n){
    var fail = this.port('state:fail');
    if(fail.hasSubscribers) return fail.send(n);
    return null;
  }

}

class EventReactor extends Component{

  static create() => new EventReactor();

  EventReactor(){
    
      this.enableSubnet();
      this.createSpace('evin');

      this.makeInport('evin:events',meta:{'desc':"stream of events"});
      this.makeInport('evin:type',meta:{"desc":"type/types of events to allow"});
      this.makeInport('evin:condfn',meta:{"desc":"a function to apply for "});
      
      this.port('static:option').bindPort(this.port('evin:type'));

      

  }

}
