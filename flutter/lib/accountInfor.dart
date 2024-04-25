import 'package:flutter/material.dart';
import 'package:flutter_todo_app/provider/account.dart';
import 'package:provider/provider.dart';

class AccountInfoPopup extends StatelessWidget {
  const AccountInfoPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.read<AccountProvider>();

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/avatar.png'), // Thay bằng đường dẫn ảnh avatar của người dùng
                radius: 30,
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tài khoản: ${accountProvider.getAccount()}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                      'Họ tên: ${accountProvider.getUsername()}'), // Thay bằng tên thật của người dùng
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Text('Ngày sinh: 01/01/1990'),
          Text('Email: john.doe@example.com'),
          Text('Last Online: 24/04/2024'),
          SizedBox(height: 16.0),
          Text(
            'About me:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          ),
        ],
      ),
    );
  }
}
