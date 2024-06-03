import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/appState.dart';
import 'package:provider/provider.dart';

class PageNumberWidget extends StatefulWidget {
  const PageNumberWidget({super.key});

  @override
  State<PageNumberWidget> createState() => _PageNumberWidgetState();
}

class _PageNumberWidgetState extends State<PageNumberWidget> {
  Container pageNumberBlock(int currentPage, Color bgrColor, Color textColor) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        color: bgrColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$currentPage',
        style: TextStyle(
          fontSize: 18,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);
    final int numberOfPages = appStateProvider.getNumberOfPages();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.first_page),
          onPressed: () {
            // Handle pagination: Go to the first page
            appStateProvider.setCurrentPage(1);
          },
        ),
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle pagination: Go to the previous page
            appStateProvider.goToPreviousPage();
          },
        ),
        SizedBox(width: 10),
        for (int currentPage = 1; currentPage <= numberOfPages; currentPage++)
          InkWell(
              onTap: () {
                // Handle pagination: Go to page i
                appStateProvider.setCurrentPage(currentPage);
              },
              child: currentPage == appStateProvider.appState!.currentPage
                  ? pageNumberBlock(currentPage, Colors.blue, Colors.white)
                  : pageNumberBlock(currentPage, Colors.white, Colors.black)),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            // Handle pagination: Go to the next page
            appStateProvider.goToNextPage();
          },
        ),
        IconButton(
          icon: Icon(Icons.last_page),
          onPressed: () {
            // Handle pagination: Go to the last page
            appStateProvider.goToLastPage();
          },
        ),
      ],
    );
  }
}
