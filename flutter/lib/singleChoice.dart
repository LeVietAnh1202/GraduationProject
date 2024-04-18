import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class SingleChoice extends StatefulWidget {
  late SegmentButtonOption option;
  SingleChoice({required this.option});

  @override
  State<SingleChoice> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AppStateProvider>(context, listen: false)
        .setCalendarView(Calendar.week);
    Provider.of<AppStateProvider>(context, listen: false)
        .setImagesView(ShowImage.full);
  }

  Widget segmentedButtonImage(BuildContext context) {
    return SegmentedButton<ShowImage>(
      segments: const <ButtonSegment<ShowImage>>[
        ButtonSegment<ShowImage>(
            value: ShowImage.full,
            label: Text('Show full image'),
            icon: Icon(Icons.calendar_view_week)),
        ButtonSegment<ShowImage>(
            value: ShowImage.crop,
            label: Text('Image face cropped'),
            icon: Icon(Icons.calendar_view_month)),
      ],
      selected: <ShowImage>{
        context.watch<AppStateProvider>().appState!.imagesView
      },
      onSelectionChanged: (Set<ShowImage> newSelection) {
        setState(() {
          Provider.of<AppStateProvider>(context, listen: false)
              .setImagesView(newSelection.first);
        });
      },
    );
  }

  Widget segmentedButtonCalendar(BuildContext context) {
    return SegmentedButton<Calendar>(
      segments: const <ButtonSegment<Calendar>>[
        ButtonSegment<Calendar>(
            value: Calendar.week,
            label: Text('Lịch học theo tuần'),
            icon: Icon(Icons.calendar_view_week)),
        ButtonSegment<Calendar>(
            value: Calendar.term,
            label: Text('Lịch học theo học kỳ'),
            icon: Icon(Icons.calendar_view_month)),
      ],
      selected: <Calendar>{
        context.watch<AppStateProvider>().appState!.calendarView
      },
      onSelectionChanged: (Set<Calendar> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          Provider.of<AppStateProvider>(context, listen: false)
              .setCalendarView(newSelection.first);
          print('newSelection.first: ');
          print(newSelection.first);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.option) {
      case SegmentButtonOption.calendar:
        return segmentedButtonCalendar(context);

      case SegmentButtonOption.image:
        return segmentedButtonImage(context);
      default:
        return Container();
    }
  }
}
