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
  }
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

      this.port('events:sub').send('mouseOver');
      this.port('events:sub').send('mouseMove');
      this.port('events:sub').send('mouseOut');
      this.port('events:sub').send('mouseDown');
      this.port('events:sub').send('mouseUp');
      this.port('events:sub').send('mouseLeave');
      this.port('events:sub').send('mouseEnter');
      this.port('events:sub').send('mousewheel');
      this.port('events:sub').send('mouseEnter');
      this.port('events:sub').send('mouseLeave');
      this.port('events:sub').send('dragOver');
      this.port('events:sub').send('dragEnd');
      this.port('events:sub').send('dragStart');
      this.port('events:sub').send('dragEnter');
      this.port('events:sub').send('dragleave');
      this.port('events:sub').send('fullscreenChange');
      this.port('events:sub').send('fullscreenError');
      this.port('events:sub').send('keydown');
      this.port('events:sub').send('keyup');
      this.port('events:sub').send('keypress');
      this.port('events:sub').send('selectStart');
      this.port('events:sub').send('touchCancel');
      this.port('events:sub').send('touchLeave');
      this.port('events:sub').send('touchEnter');
      this.port('events:sub').send('touchStart');
      this.port('events:sub').send('touchMove');
      this.port('events:sub').send('transitionEvent');

      this.port('events:sub').send('beforeCut');
      this.port('events:sub').send('beforeCopy');
      this.port('events:sub').send('beforePaste');
      this.port('events:sub').send('contextMenu');
      
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



class EventReactor{

  static create() => new EventReactor();

  EventReactor(){

  }
}
