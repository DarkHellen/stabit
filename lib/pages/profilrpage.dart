import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stabit/pages/cource_page.dart';
import 'Results page.dart';
import 'home_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  final Email = FirebaseAuth.instance.currentUser!.email;

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          //final size = MediaQuery.of(context).size;
          var index = 2;
          return Scaffold(
            backgroundColor: Colors.deepPurple,
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              color: Colors.deepPurple.shade200,
              animationDuration: const Duration(milliseconds: 200),
              index: index,
              onTap: (index) {
                if (index == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else if (index == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CourseView()));
                } else if (index == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                } else if (index == 3) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Result_Page()));
                }
              },
              items: const [
                Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                Icon(Icons.book_online, color: Colors.white),
                Icon(Icons.person_2_sharp, color: Colors.white),
                Icon(
                  Icons.developer_mode,
                  color: Colors.redAccent,
                )
              ],
            ),
            body: SafeArea(
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Stabit')
                      .doc("Student")
                      .collection(Email!)
                      .doc("Profile")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final userData =
                        snapshot.data?.data() as Map<String, dynamic>?;
                    if (userData == null) {
                      // Handle the case when userData is null or doesn't exist
                      return const Center(
                          child: Text('No user data available.'));
                    }

                    return SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              width: 360.w,
                              height: 690.h,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                color: Colors.deepPurple,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 360.w,
                                      height: 690.h,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 1.33,
                                            top: 0,
                                            child: Container(
                                              width: 358.w,
                                              height: 640.h,
                                              decoration: ShapeDecoration(
                                                color: Colors.deepPurple,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                shadows: const [
                                                  BoxShadow(
                                                    color: Color(0x3F000000),
                                                    blurRadius: 75,
                                                    offset: Offset(0, 4),
                                                    spreadRadius: 0,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 38.60,
                                            top: 177,
                                            child: Container(
                                              width: 286.14.w,
                                              height: 348.h,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 51.40.w,
                                                    top: 328.h,
                                                    child: SizedBox(
                                                      width: 183.w,
                                                      height: 20.h,
                                                      child: Text(
                                                        'Occupation:${userData["Occupation"]}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13.sp,
                                                          fontFamily: 'Lato',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 51.40,
                                                    top: 267,
                                                    child: SizedBox(
                                                      width: 183.w,
                                                      height: 20.h,
                                                      child: Text(
                                                        'Date of Birth: ${userData["DoB"]}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13.sp,
                                                          fontFamily: 'Lato',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 50.40,
                                                    top: 206,
                                                    child: SizedBox(
                                                      width: 183.w,
                                                      height: 20.h,
                                                      child: Text(
                                                        'Interests: ${userData["Interests"]} ',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13.sp,
                                                          fontFamily: 'Lato',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 50.40,
                                                    top: 154,
                                                    child: SizedBox(
                                                      width: 183.w,
                                                      height: 20.h,
                                                      child: Text(
                                                        'Contact No: ${userData["PhoneNumber"]}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13.sp,
                                                          fontFamily: 'Lato',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    top: 73.29,
                                                    child: SizedBox(
                                                      width: 286.14.w,
                                                      height: 65.10.h,
                                                      child: Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Bio: ${userData['Bio']}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13.sp,
                                                                fontFamily:
                                                                    'Lato',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 69.40,
                                                    top: 37,
                                                    child: SizedBox(
                                                      width: 154.w,
                                                      height: 21.h,
                                                      child: Text(
                                                        ' ${Email}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xFFA79AE0),
                                                          fontSize: 16.sp,
                                                          fontFamily: 'Lato',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 51.40,
                                                    top: 0,
                                                    child: SizedBox(
                                                        width: 183.w,
                                                        height: 20.h,
                                                        child: Text(
                                                          "Name: ${userData['Name']}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13.sp,
                                                            fontFamily: 'Lato',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 113,
                                            top: 37,
                                            child: Container(
                                              width: 127.48.w,
                                              height: 121.36.h,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 28,
                                                    top: 19.76,
                                                    child: Container(
                                                      width: 84.88.w,
                                                      height: 80.64.h,
                                                      decoration:
                                                          ShapeDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            userData[
                                                                "ImageUrl"],
                                                          ),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                            width: 1.w,
                                                            strokeAlign: BorderSide
                                                                .strokeAlignOutside,
                                                            color: const Color(
                                                                0xFF504786),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 32,
                                            top: 27,
                                            child: Container(
                                              width: 28.w,
                                              height: 30.h,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 0,
                                                    child: Container(
                                                      width: 28.w,
                                                      height: 30.h,
                                                      decoration:
                                                          const ShapeDecoration(
                                                        color:
                                                            Color(0xFFF7DF1E),
                                                        shape: OvalBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 4.90,
                                                    top: 6.h,
                                                    child: Container(
                                                      width: 17.50.w,
                                                      height: 17.58.h,
                                                      child: const Stack(
                                                          children: []),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
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
                  }),
            ),
          );
        });
  }
}
