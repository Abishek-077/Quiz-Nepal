import '../domain/entities/study_resource.dart';

class StudyResourceCatalog {
  const StudyResourceCatalog._();

  static const List<StudyResource> all = [
    StudyResource(
      id: 'dotm-written-exam',
      categoryId: 'driving_license',
      title: 'Driving license written exam portal',
      sourceName: 'Department of Transport Management',
      description:
          'Official written examination system for driving license preparation.',
      url: 'https://exam.dotm.gov.np/',
      type: StudyResourceType.officialPortal,
    ),
    StudyResource(
      id: 'dotm-category-b-english-pdf',
      categoryId: 'driving_license',
      title: 'Category B objective questions',
      sourceName: 'Transport Management Office, Bhaktapur',
      description:
          'Government PDF question bank for car, jeep and delivery van exams.',
      url:
          'https://bhaktpurlc.dotm.gov.np/Files/NoticePDF/B_English%28Collection%292023-12-04_09-15-34-322.pdf',
      type: StudyResourceType.pdf,
    ),
    StudyResource(
      id: 'traffic-police-signs',
      categoryId: 'traffic_signs',
      title: 'Traffic signs and signals',
      sourceName: 'Kathmandu Valley Traffic Police Office',
      description:
          'Official traffic light, pedestrian signal and road signal guidance.',
      url: 'https://traffic.nepalpolice.gov.np/about-us/traffic-signs/',
      type: StudyResourceType.online,
    ),
    StudyResource(
      id: 'dor-traffic-signs-manual',
      categoryId: 'traffic_signs',
      title: 'Traffic signs manual',
      sourceName: 'Department of Roads',
      description:
          'Road signs manual from Nepal Department of Roads guidelines.',
      url:
          'https://www.dor.gov.np/home/guideline/force/traffic-signs-manual-volume-1',
      type: StudyResourceType.book,
    ),
    StudyResource(
      id: 'psc-general-knowledge-syllabus',
      categoryId: 'loksewa_gk',
      title: 'General knowledge syllabus sample',
      sourceName: 'Public Service Commission Nepal',
      description:
          'PSC syllabus PDF with geography, history, governance and current affairs topics.',
      url:
          'https://psc.gov.np/assets/uploads/files/6_WDO_6_Level_076-2-12final1.pdf',
      type: StudyResourceType.pdf,
    ),
    StudyResource(
      id: 'psc-home',
      categoryId: 'loksewa_gk',
      title: 'PSC notices and syllabus portal',
      sourceName: 'Public Service Commission Nepal',
      description:
          'Official source for current Loksewa notices, exam updates and syllabi.',
      url: 'https://psc.gov.np/',
      type: StudyResourceType.officialPortal,
    ),
    StudyResource(
      id: 'microsoft-computer-basics',
      categoryId: 'computer_basics',
      title: 'Exploring basic computer concepts',
      sourceName: 'Microsoft Learn',
      description:
          'Beginner learning path covering computer parts, internet, programming history and security.',
      url:
          'https://learn.microsoft.com/en-us/training/paths/explore-basic-computer-concepts/',
      type: StudyResourceType.online,
    ),
    StudyResource(
      id: 'gcf-basic-skills',
      categoryId: 'computer_basics',
      title: 'Computer and digital basic skills',
      sourceName: 'GCFGlobal',
      description:
          'Free lessons for computer basics, internet use and practical digital skills.',
      url: 'https://edu.gcfglobal.org/en/subjects/basic-skills/',
      type: StudyResourceType.online,
    ),
    StudyResource(
      id: 'britannica-nepal',
      categoryId: 'nepal_gk',
      title: 'Nepal overview and facts',
      sourceName: 'Encyclopaedia Britannica',
      description:
          'Reference article for Nepal geography, history, culture, population and map facts.',
      url: 'https://www.britannica.com/place/Nepal',
      type: StudyResourceType.online,
    ),
    StudyResource(
      id: 'cia-nepal-factbook',
      categoryId: 'nepal_gk',
      title: 'Nepal country facts',
      sourceName: 'CIA World Factbook',
      description:
          'Country reference for geography, people, economy and government indicators.',
      url: 'https://www.cia.gov/the-world-factbook/countries/nepal/',
      type: StudyResourceType.online,
    ),
  ];

  static List<StudyResource> forCategory(String categoryId) {
    return all
        .where((resource) => resource.categoryId == categoryId)
        .toList(growable: false);
  }
}
