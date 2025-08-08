import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_app/components/Background/full_screen_background.dart';
import 'package:game_app/components/navbar/bottom_navbar_menu.dart';
import 'package:game_app/util/common_function.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    if (!await isOnline()) {
      setState(() {
        _isLoading = false;
        _errorMessage = '您目前處於離線狀態。';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://lst.waysapp.com/api/mobile/notifications'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _notifications = data.cast<Map<String, dynamic>>();
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to load notifications: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _dateFormater(String datetime) {
    DateTime dateTime = DateTime.parse(datetime);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottomNavbarMenu(),
      body: FullScreenBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
            ? Center(child: Text(_errorMessage))
            : _notifications.isEmpty
            ? Center(child: Text('No notifications found'))
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 0),
                    child: ScreenHeader(title: "通知"),
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/ui/background/bar_notification.png",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.notifications, color: Colors.amber),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification["title"] ?? "No title",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (notification["body"] != null)
                                      Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Text(
                                          notification["body"],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    if (notification["created_at"] != null)
                                      Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          _dateFormater(
                                            notification["created_at"],
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
