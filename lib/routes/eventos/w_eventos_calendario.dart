import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mister_football/main.dart';
import 'package:table_calendar/table_calendar.dart';

class EventosCalendario extends StatefulWidget {
  final Map listaEventos;

  EventosCalendario({Key key, @required this.listaEventos}) : super(key: key);

  @override
  _EventosCalendario createState() => _EventosCalendario();
}

class _EventosCalendario extends State<EventosCalendario> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {};
    //Añadir eventos
    widget.listaEventos.forEach((key, value) {
      String fechaString = key.split("/")[0];
      DateTime fecha = DateTime(int.parse(fechaString.split("-")[0]), int.parse(fechaString.split("-")[1]), int.parse(fechaString.split("-")[2]));
      String horaString = key.split("/")[1];
      if (_events[fecha] != null) {
        List eventosItem = _events[fecha].toList();
        List nuevoEventoAGuardar = [];
        nuevoEventoAGuardar.add(horaString);
        nuevoEventoAGuardar.add(value);
        eventosItem.add(nuevoEventoAGuardar);
        //Ordenar por hora
        eventosItem.sort((a, b) => a[0].compareTo(b[0]));
        _events[fecha] = eventosItem;
      } else {
        List nuevoEventoAGuardar = [];
        nuevoEventoAGuardar.add(horaString);
        nuevoEventoAGuardar.add(value);
        _events[fecha] = [nuevoEventoAGuardar];
      }
    });

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  /*void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }*/

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendarWithBuilders(),
          _buildEventList(),
        ],
      ),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    initializeDateFormatting('es_ES');
    return TableCalendar(
      locale: 'es_ES',
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: {
        CalendarFormat.month: '',
        CalendarFormat.twoWeeks: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        weekendStyle: TextStyle(color: MisterFootball.primarioDark2),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: MisterFootball.primarioLight2),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              decoration: BoxDecoration(
                color: MisterFootball.complementarioLight2.withOpacity(.2),
                border: Border(
                  bottom: BorderSide(width: 1),
                  top: BorderSide(width: 1),
                  left: BorderSide(width: 1),
                  right: BorderSide(width: 1),
                ),
              ),
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 16.0
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          /* Selecciona el día de hoy */
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            //color: MisterFootball.complementarioLight2.withOpacity(.3),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                bottom: BorderSide(width: 1, color: MisterFootball.primarioDark2.withOpacity(.3)),
                top: BorderSide(width: 1, color: MisterFootball.primarioDark2.withOpacity(.3)),
                left: BorderSide(width: 1, color: MisterFootball.primarioDark2.withOpacity(.3)),
                right: BorderSide(width: 1, color: MisterFootball.primarioDark2.withOpacity(.3)),
              ),
            ),
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          /* Mostrar los eventos */
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      /*onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,*/
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: (_calendarController.isSelected(date)
            ? MisterFootball.complementarioDelComplementarioDark
            //: (_calendarController.isToday(date) ? MisterFootball.primarioLight2 : Colors.blue[400])
            : MisterFootball.primario),
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      shrinkWrap: true,
      /* Eliminar Scroll para pantallas pequeñas */
      physics: NeverScrollableScrollPhysics(),
      children: _selectedEvents
          .map((event) =>
              //Entrenami,ento
              Container(
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * .05,
                  MediaQuery.of(context).size.width * .015,
                  MediaQuery.of(context).size.width * .05,
                  MediaQuery.of(context).size.width * .015,
                ),
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * .05,
                  MediaQuery.of(context).size.width * .05,
                  MediaQuery.of(context).size.width * .05,
                  MediaQuery.of(context).size.width * .05,
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: (event[1].length == 1)
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            MisterFootball.complementarioLight.withOpacity(.3),
                            MisterFootball.complementario.withOpacity(.3),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            MisterFootball.analogo1Light.withOpacity(.3),
                            MisterFootball.analogo1.withOpacity(.3),
                          ],
                        ),
                ),
                child: (event[1].length == 1)
                    //Entrenamiento
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(event[0]),
                          Text(event[1][0]),
                        ],
                      )
                    //Partido
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * .15,
                            child: Text(event[0]),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * .55,
                                child: Text(
                                  "${event[1][0]} de ${event[1][2]}",
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .55,
                                child: Text(
                                  "contra ${event[1][1]}",
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
              ))
          //Partido
          /*: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.8),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(event[0]),
                      Text(event[1][0]),
                    ],
                  ),
                ))*/
          .toList(),
    );
  }
}
