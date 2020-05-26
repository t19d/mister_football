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
      print(horaString);
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
    /*_events = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      DateTime(2020, 05, 23): ['Event A8', 'Event B8', 'Event C8', 'Event D8', 'Event C8', 'Event D8', 'Event C8', 'Event D8'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };*/

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
        outsideDaysVisible: false,
        weekendStyle: TextStyle(color: Colors.lightBlue),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.lightBlue),
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
              color: MisterFootball.complementario,
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle(fontSize: 16.0),
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
        color:
            (_calendarController.isSelected(date) ? Colors.brown[500] : (_calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400])),
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
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
