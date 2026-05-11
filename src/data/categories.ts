import { QuizCategory } from '../types/quiz';

export const categories: QuizCategory[] = [
  {
    id: 'driving-license',
    title: 'Driving License',
    subtitle: 'Written exam practice with traffic rules',
    icon: '🚦',
    color: '#2563EB',
    routeSlug: 'driving-license-written-practice',
  },
  {
    id: 'loksewa-gk',
    title: 'Loksewa GK',
    subtitle: 'Repeat high-value GK with explanations',
    icon: '📚',
    color: '#7C3AED',
    routeSlug: 'loksewa-gk-daily-challenge',
  },
  {
    id: 'nepal-gk',
    title: 'Nepal GK',
    subtitle: 'Can you beat today’s Nepal GK challenge?',
    icon: '🇳🇵',
    color: '#DC2626',
    routeSlug: 'nepal-gk-quiz-battle',
  },
  {
    id: 'computer-it-gk',
    title: 'Computer/IT GK',
    subtitle: 'Useful basics for exams and interviews',
    icon: '💻',
    color: '#0891B2',
    routeSlug: 'computer-it-gk-practice',
  },
  {
    id: 'fun-iq',
    title: 'Fun/IQ Quiz',
    subtitle: 'Quick brain warm-up before study',
    icon: '🧠',
    color: '#EA580C',
    routeSlug: 'fun-iq-nepal-challenge',
  },
];
