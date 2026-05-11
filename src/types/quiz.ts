export type CategoryId = 'driving-license' | 'loksewa-gk' | 'nepal-gk' | 'computer-it-gk' | 'fun-iq';

export type Difficulty = 'easy' | 'medium' | 'hard';

export type Question = {
  id: string;
  category: CategoryId;
  question: string;
  options: string[];
  correctAnswer: string;
  explanation: string;
  difficulty: Difficulty;
  topic: string;
};

export type QuizCategory = {
  id: CategoryId;
  title: string;
  subtitle: string;
  icon: string;
  color: string;
  routeSlug: string;
};

export type QuizAttempt = {
  id: string;
  category: CategoryId;
  score: number;
  total: number;
  coinsEarned: number;
  completedAt: string;
  wrongQuestionIds: string[];
};

export type UserProgress = {
  coins: number;
  streak: number;
  lastQuizDate?: string;
  completedQuizzes: number;
  bestScores: Partial<Record<CategoryId, number>>;
  attempts: QuizAttempt[];
  weakTopics: Record<string, number>;
  needsReviewQuestionIds: string[];
};

export type LeaderboardEntry = {
  id: string;
  name: string;
  category: CategoryId | 'all';
  score: number;
  streak: number;
  city: string;
};
