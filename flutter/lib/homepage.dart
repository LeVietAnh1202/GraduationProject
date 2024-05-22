import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constant/number.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // double widthDataTable = screenWidth - sideBarWidth - 40;

    double heightDataTable = screenHeight -
        appBarHeight -
        bodyContentPadding -
        breadcrumbHeight -
        selectHeight;
    print('heightDataTable: ' + heightDataTable.toString());
    return Container(
      height: heightDataTable,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ứng dụng & Website Danh mục Đầu tư Flutter Responsive',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Cảm ơn bạn đã ghé thăm kho lưu trữ trang web danh mục đầu tư của tôi. Trang web dựa trên Flutter này là nơi để giới thiệu các kỹ năng, dự án, chứng chỉ và cách liên hệ với tôi. Trang web được thiết kế với trọng tâm là tính đáp ứng, đảm bảo rằng nó trông và hoạt động hoàn hảo trên nhiều thiết bị khác nhau, từ màn hình máy tính để bàn lớn đến thiết bị Android nhỏ gọn.',
            ),
            SizedBox(height: 8),
            Text(
              'Xem Demo Trực Tiếp',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Thêm liên kết demo trực tiếp của bạn ở đây
              },
              child: Text('Nhấn để xem demo trực tiếp'),
            ),
            SizedBox(height: 8),
            Text(
              'Ảnh Chụp Màn Hình',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Thêm các widget ảnh chụp màn hình của bạn ở đây
            Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(child: Text('Ảnh Chụp Màn Hình 1')),
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(child: Text('Ảnh Chụp Màn Hình 2')),
            ),
            SizedBox(height: 8),
            Text(
              'Mục Lục',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            _buildTableOfContents(),
            SizedBox(height: 8),
            Text(
              'Tính Năng Chính',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            _buildKeyFeatures(),
            SizedBox(height: 8),
            Text(
              'Công Nghệ và Gói Được Sử Dụng',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            _buildTechnologiesUsed(),
            SizedBox(height: 8),
            Text(
              'Bắt Đầu',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            _buildGettingStarted(),
            SizedBox(height: 8),
            Text(
              'Hướng Dẫn Sử Dụng',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            _buildUsageGuide(),
            SizedBox(height: 8),
            Text(
              'Đóng Góp',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            _buildContributions(),
            SizedBox(height: 8),
            Text(
              'Liên Hệ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            _buildContactMe(),
            SizedBox(height: 8),
            Text(
              'Giấy Phép',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              'Dự án này được cấp phép theo Giấy phép MIT - xem tệp LICENSE để biết thêm chi tiết.',
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Được thiết kế và phát triển với ❤️ bởi Hamad Anwar.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableOfContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tính Năng Chính'),
        Text('Công Nghệ và Gói Được Sử Dụng'),
        Text('Bắt Đầu'),
        Text('Hướng Dẫn Sử Dụng'),
        Text('Đóng Góp'),
        Text('Liên Hệ'),
        Text('Giấy Phép'),
      ],
    );
  }

  Widget _buildKeyFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Thiết Kế Đáp Ứng: Trang web danh mục đầu tư được thiết kế tỉ mỉ để cung cấp trải nghiệm nhất quán và hấp dẫn về mặt thị giác trên nhiều loại thiết bị khác nhau. Dù bạn truy cập trang web trên màn hình máy tính để bàn lớn, máy tính xách tay, máy tính bảng hay điện thoại thông minh Android nhỏ, bố cục và nội dung sẽ thích ứng một cách linh hoạt để đảm bảo khả năng sử dụng tối ưu.'),
        Text(
            'Trình Bày Dự Án: Trái tim của danh mục đầu tư nằm ở phần trình bày dự án. Mỗi dự án được trình bày với một thẻ hấp dẫn cung cấp cái nhìn thoáng qua về bản chất của dự án. Người truy cập có thể nhấp vào các thẻ này để xem chi tiết hơn về từng dự án. Hơn nữa, liên kết trực tiếp đến kho lưu trữ GitHub tương ứng cho phép người truy cập khám phá mã nguồn và có cái nhìn toàn diện về các khía cạnh kỹ thuật của dự án.'),
        Text(
            'Chứng Chỉ và Thành Tựu: Tôi tin vào việc học tập và phát triển liên tục, đó là lý do tại sao danh mục đầu tư có một phần chuyên biệt để trình bày các chứng chỉ và thành tựu của tôi. Điều này cung cấp cái nhìn sâu sắc về hành trình nghề nghiệp của tôi, nêu bật các kỹ năng và chuyên môn mà tôi đã tích lũy được.'),
        Text(
            'Liên Hệ và Tương Tác: Để tạo điều kiện liên lạc dễ dàng, danh mục đầu tư cung cấp nhiều cách để liên hệ với tôi. Phần liên hệ có thông tin như địa chỉ email của tôi, hồ sơ LinkedIn và tài khoản Twitter. Dù bạn là một cộng tác viên tiềm năng, nhà tuyển dụng hay chỉ là một người quan tâm đến việc kết nối, tôi luôn sẵn sàng cho những cuộc trò chuyện ý nghĩa.'),
        Text(
            'Giao Diện Người Dùng Thanh Lịch và Hoạt Hình: Giao diện người dùng của danh mục đầu tư được thiết kế cẩn thận không chỉ để hoạt động mà còn để hấp dẫn về mặt thị giác. Các hoạt hình tinh tế được tích hợp xuyên suốt trang web để tạo ra trải nghiệm duyệt web thú vị và hấp dẫn. Các hoạt hình này được cân bằng cẩn thận để tăng cường sự tham gia của người dùng mà không làm cho nội dung trở nên quá tải.'),
      ],
    );
  }

  Widget _buildTechnologiesUsed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Trang web danh mục đầu tư được xây dựng bằng Flutter, một bộ công cụ phát triển phần mềm giao diện người dùng mã nguồn mở mạnh mẽ. Các gói sau đây đã được sử dụng để cải thiện các khía cạnh khác nhau của trang web:'),
        Text(
            'google_fonts: Tích hợp các phông chữ hấp dẫn và dễ đọc từ thư viện Google Fonts vào trang web.'),
        Text(
            'flutter_svg: Cho phép tích hợp và hiển thị mượt mà các hình ảnh SVG, đảm bảo đồ họa chất lượng cao trên tất cả các thiết bị.'),
        Text(
            'get: Cung cấp khả năng quản lý trạng thái hiệu quả, đơn giản hóa quá trình xử lý và cập nhật các thành phần giao diện người dùng.'),
        Text(
            'photo_view: Cung cấp trình xem ảnh thanh lịch và thân thiện với người dùng để trải nghiệm hình ảnh tốt hơn.'),
        Text(
            'url_launcher: Cho phép tích hợp dễ dàng với các liên kết bên ngoài, giúp người truy cập nhanh chóng điều hướng đến các tài nguyên bên ngoài.'),
        Text(
            'font_awesome_flutter: Giới thiệu nhiều biểu tượng có thể tùy chỉnh từ thư viện FontAwesome, nâng cao đại diện trực quan của các tính năng trên trang web.'),
      ],
    );
  }

  Widget _buildGettingStarted() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Để khám phá và tương tác với trang web danh mục đầu tư trên máy của bạn, hãy làm theo các bước sau:'),
        Text(
            'Sao chép kho lưu trữ: git clone https://github.com/Hamad-Anwar/Flutter-Responsive-Portfolio-WebApp.git'),
        Text('Cài đặt các phụ thuộc: flutter pub get'),
        Text('Chạy ứng dụng: chạy run'),
      ],
    );
  }

  Widget _buildUsageGuide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Sau khi trang web đã được khởi chạy, bạn sẽ thấy một loạt các phần để khám phá:'),
        Text(
            'Trang chủ: Trang chào mừng khách truy cập với một tổng quan về nội dung và mục đích của trang web.'),
        Text(
            'Dự án: Duyệt qua các dự án của tôi, mỗi dự án được hiển thị dưới dạng một thẻ tương tác. Nhấp vào một thẻ sẽ hiển thị thông tin chi tiết và một liên kết trực tiếp đến kho lưu trữ GitHub.'),
        Text(
            'Chứng chỉ: Khám phá các chứng chỉ của tôi, nhận được cái nhìn sâu sắc về hành trình phát triển chuyên nghiệp của tôi.'),
        Text(
            'Liên hệ: Liên hệ với tôi thông qua thông tin liên lạc được cung cấp hoặc liên kết mạng xã hội.'),
      ],
    );
  }

  Widget _buildContributions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Tôi hoan nghênh đóng góp và đề xuất từ cộng đồng! Nếu bạn gặp bất kỳ vấn đề nào, có ý tưởng để cải thiện, hoặc muốn đóng góp bằng bất kỳ cách nào, đừng ngần ngại mở một vấn đề hoặc gửi yêu cầu kéo. Hãy cùng hợp tác để làm cho danh mục này trở nên tốt hơn nữa!'),
      ],
    );
  }

  Widget _buildContactMe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Phản hồi và suy nghĩ của bạn được đánh giá cao. Hãy tự do kết nối với tôi qua:'),
        Text('Email: rh676838@gmail.com'),
        Text('LinkedIn: Hamad Anwar'),
      ],
    );
  }
}
