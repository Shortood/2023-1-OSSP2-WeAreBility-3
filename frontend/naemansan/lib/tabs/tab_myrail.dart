import 'package:flutter/material.dart';
import 'package:naemansan/screens/map/naver_map_screen.dart';
import 'package:naemansan/screens/screen_index.dart';
import 'package:naemansan/widgets/widget_trail.dart';
import 'package:naemansan/models/trailmodel.dart';
//세부 페이지 이동 시 사용
//import 'package:naemansan/models/traildetailmodel.dart';
import 'package:naemansan/services/courses_api.dart';
import 'package:naemansan/models/trailcommentmodel.dart';
import 'package:naemansan/widgets/widget_trailcomment.dart';
import 'package:naemansan/screens/create_course_screen.dart';

class Myrail extends StatefulWidget {
  final int initialTabIndex;
  const Myrail({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  _MyrailState createState() => _MyrailState();
}

class _MyrailState extends State<Myrail> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TrailApiService TrailapiService;

  int openIndex = 1; // 나만의, 공개 산책로 등록시 사용하는 인덱스
  int selectedIndex = 0; // 키워드별 보기에서 사용하는 인덱스 !!

  @override
  void initState() {
    super.initState();
    TrailapiService = TrailApiService();
    _tabController = TabController(
      length: 5,
      initialIndex: widget.initialTabIndex,
      vsync: this,
    );
    openIndex = 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ListView makeList(AsyncSnapshot<List<dynamic>?> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var data = snapshot.data![index];

        if (data is TrailModel) {
          var trail = data;

          return TrailWidget(
            title: trail.title,
            startpoint: trail.startLocationName,
            distance: trail.distance,
            CourseKeyWord: trail.tags,
            likeCnt: trail.likeCount,
            userCnt: trail.userCount,
            isLiked: trail.isLiked,
            id: trail.id,
            created_date: trail.createdDate.toString(),
          );
        } else if (data is TrailCommentModel) {
          var trail = data;

          return CommentTrailWidget(
            id: trail.id,
            courseId: trail.courseId,
            title: trail.title,
            tags: trail.tags,
            content: trail.content,
          );
        }

        return const SizedBox();
      },
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    const int page = 0;
    const int num = 100000000;
    List<String> keywords = [
      '힐링',
      '스타벅스',
      '자연',
      '오솔길',
      '도심',
      '출근길',
      '퇴근길',
      '점심시간',
      '스트레스해소',
      '한강',
      '공원',
      '성수',
      '강아지',
      '바다',
      '해안가',
      '러닝',
      '맛집',
      '카페',
      '영화',
      '문화',
      '사색',
      '핫플',
      '서울숲',
      '경복궁',
      '한옥마을',
      '문화재',
      '고양이',
      '개울가',
      '계곡',
      '들판',
      '산',
      '동산',
      '야경',
      '노을',
      '숲길',
      '강서구',
      '양천구',
      '구로구',
      '영등포구',
      '금천구',
      '동작구',
      '관악구',
      '서초구',
      '강남구',
      '송파구',
      '강동구',
      '은평구',
      '서대문구',
      '마포구',
      '용산구',
      '중구',
      '종로구',
      '도봉구',
      '강북구',
      '성북구',
      '동대문구',
      '성동구',
      '노원구',
      '중랑구',
      '광진구'
    ]; //임시 키워드 설정()->추후 내가 설정한 키워드 불러오기로 바꾸어야함!!

    final Future<List<TrailModel>?> EnrolledTrail =
        TrailapiService.getEnrolledCourses(page, num);
    final Future<List<TrailModel>?> IndivTrail =
        TrailapiService.getIndividualBasicCourses(page, num);
    final Future<List<TrailModel>?> LikedTrail =
        TrailapiService.getLikedCourses(page, num);
    final Future<List<TrailModel>?> UsedTrail =
        TrailapiService.getUsedCourses(page, num);
    final Future<List<TrailCommentModel>?> CommentedTrail =
        TrailapiService.getCommentedCourses(page, num);
    final Future<List<TrailModel>?> KeyWordTrail =
        TrailapiService.getKeywordCourse(page, num, keywords[selectedIndex]);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const IndexScreen(),
              ),
            );
          },
        ),
        title: const Text(
          '나만의 산책로',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  //산책로 등록
                  builder: (context) => const NaverMapScreen(),
                  // builder: (context) => const CreateCourseScreen(),
                ),
              );
            },
          ),
        ],
        titleSpacing: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(
              child: Text(
                '등록한',
                style: TextStyle(color: Colors.black, fontSize: 12.5),
              ),
            ),
            Tab(
              child: Text(
                '좋아요',
                style: TextStyle(color: Colors.black, fontSize: 12.5),
              ),
            ),
            Tab(
              child: Text(
                '이용한',
                style: TextStyle(color: Colors.black, fontSize: 12.5),
              ),
            ),
            Tab(
              child: Text(
                '댓글단',
                style: TextStyle(color: Colors.black, fontSize: 12.5),
              ),
            ),
            Tab(
              child: Text(
                '키워드',
                style: TextStyle(color: Colors.black, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          //첫번째 탭
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          openIndex = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: openIndex == 1 ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Text(
                          '등록된', //EnrolledTrail
                          style: TextStyle(
                            color: openIndex == 1 ? Colors.white : Colors.black,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          openIndex = 0;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: openIndex == 0 ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Text(
                          '나만의', //IndivTrail
                          style: TextStyle(
                            color: openIndex == 0 ? Colors.white : Colors.black,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder(
                    future: openIndex == 1 ? EnrolledTrail : IndivTrail,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return makeList(snapshot);
                        } else {
                          // 등록한 산책로 없을 때만 여기서도 등록 버튼
                          return Center(
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateCourseScreen(),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      } else if (!snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateCourseScreen(),
                                  ),
                                );
                              },
                            ),
                            const Text('산책로 등록하러 가기'), // 산책로 추가하러 가기
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // 두 번째 탭
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FutureBuilder(
              future: LikedTrail,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Row(
                      children: [Expanded(child: makeList(snapshot))],
                    );
                  } else {
                    return const Center(
                      child: Text('좋아요한 산책로가 없습니다'),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
          // 세 번째 탭
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FutureBuilder(
              future: UsedTrail,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Row(
                      children: [Expanded(child: makeList(snapshot))],
                    );
                  } else {
                    return const Center(
                      child: Text('이용한 산책로가 없습니다'),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
          // 네 번째 탭
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FutureBuilder(
              future: CommentedTrail,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Row(
                      children: [Expanded(child: makeList(snapshot))],
                    );
                  } else {
                    return const Center(
                      child: Text('댓글을 작성한 산책로가 없습니다'),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),

          // 다섯 번째 탭
          //
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List<Widget>.generate(
                      keywords.length,
                      (index) {
                        final keyword = keywords[index];
                        bool isSelected = index == selectedIndex;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            style: ButtonStyle(
                              elevation:
                                  MaterialStateProperty.resolveWith<double>(
                                (Set<MaterialState> states) {
                                  return 8.0;
                                },
                              ),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (isSelected) {
                                    return Colors.green; // 선택된 버튼은 초록색 배경
                                  }
                                  return Colors.white; // 선택되지 않은 버튼은 흰 배경
                                },
                              ),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (isSelected) {
                                    return Colors.white; // 선택된 버튼은 하얀 글씨
                                  }
                                  return Colors.black; // 선택되지 않은 버튼은 검은 글씨
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              keyword,
                              style: const TextStyle(
                                fontSize: 16, // 글자 크기를 16으로 조정
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                FutureBuilder(
                  future: KeyWordTrail,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return Expanded(child: makeList(snapshot));
                      } else {
                        return const Center(
                          child: Text('해당 산책로가 없습니다'),
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
