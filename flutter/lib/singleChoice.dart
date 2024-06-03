import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SingleChoice extends StatefulWidget {
  late SegmentButtonOption option;
  Function(ShowImage) changeImageOption;
  SingleChoice({required this.option, required this.changeImageOption});

  @override
  State<SingleChoice> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);
    appStateProvider.setCalendarView(Calendar.week);
    appStateProvider.setImagesView(ShowImage.video);
  }

  Widget segmentedButtonImage(BuildContext context) {
    return SegmentedButton<ShowImage>(
      segments: const <ButtonSegment<ShowImage>>[
        ButtonSegment<ShowImage>(
            value: ShowImage.video,
            label: Text('Video'),
            icon: Icon(Icons.video_camera_back_outlined)),
        ButtonSegment<ShowImage>(
            value: ShowImage.full,
            label: Text('Ảnh ban đầu'),
            icon: Icon(Icons.calendar_view_week)),
        ButtonSegment<ShowImage>(
            value: ShowImage.crop,
            label: Text('Ảnh đã xử lý'),
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

        widget.changeImageOption(newSelection.first);
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
          Provider.of<AppStateProvider>(context, listen: false)
              .setCalendarView(newSelection.first);
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
