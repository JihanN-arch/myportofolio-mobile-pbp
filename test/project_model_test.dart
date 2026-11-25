import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/project.dart';

void main() {
  test('Project.fromJson membaca data dari API', () {
    final project = Project.fromJson({
      'id': '4253fb54-b30a-4cd4-ae11-fbe1eb08715f',
      'title': 'Portfolio Web',
      'image': '/static/img/arung.png',
      'github_url': 'https://github.com/jihan/portfolio',
      'demo_url': null,
      'year': 2026,
      'category': 'web',
      'category_display': 'Web',
      'star_count': 1,
    });

    expect(project.id, '4253fb54-b30a-4cd4-ae11-fbe1eb08715f');
    expect(project.title, 'Portfolio Web');
    expect(project.githubUrl, 'https://github.com/jihan/portfolio');
    expect(project.demoUrl, isNull);
    expect(project.year, 2026);
    expect(project.categoryDisplay, 'Web');
  });

  test('Project.toJson tidak mengirim field read-only', () {
    final json = const Project(title: 'Arung', category: 'mobile').toJson();

    expect(json['title'], 'Arung');
    expect(json['category'], 'mobile');
    expect(json.containsKey('id'), isFalse);
    expect(json.containsKey('category_display'), isFalse);
  });
}
