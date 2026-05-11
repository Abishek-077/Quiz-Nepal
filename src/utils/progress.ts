import { CategoryId, QuizAttempt, UserProgress } from '../types/quiz';

const STORAGE_KEY = 'quiz-nepal-progress-v1';
let memoryStorage: string | null = null;

const localStore = {
  async getItem(key: string): Promise<string | null> {
    if (typeof globalThis !== 'undefined' && 'localStorage' in globalThis) {
      return globalThis.localStorage.getItem(key);
    }
    return memoryStorage;
  },
  async setItem(key: string, value: string): Promise<void> {
    if (typeof globalThis !== 'undefined' && 'localStorage' in globalThis) {
      globalThis.localStorage.setItem(key, value);
      return;
    }
    memoryStorage = value;
  },
};

export const defaultProgress: UserProgress = {
  coins: 0,
  streak: 0,
  completedQuizzes: 0,
  bestScores: {},
  attempts: [],
  weakTopics: {},
  needsReviewQuestionIds: [],
};

const todayKey = () => new Date().toISOString().slice(0, 10);

const yesterdayKey = () => {
  const date = new Date();
  date.setDate(date.getDate() - 1);
  return date.toISOString().slice(0, 10);
};

export async function loadProgress(): Promise<UserProgress> {
  const raw = await localStore.getItem(STORAGE_KEY);
  if (!raw) {
    return defaultProgress;
  }

  return { ...defaultProgress, ...JSON.parse(raw) } as UserProgress;
}

export async function saveProgress(progress: UserProgress): Promise<void> {
  await localStore.setItem(STORAGE_KEY, JSON.stringify(progress));
}

export function applyQuizAttempt(
  progress: UserProgress,
  attempt: QuizAttempt,
  weakTopics: string[],
): UserProgress {
  const today = todayKey();
  const yesterday = yesterdayKey();
  const nextStreak = progress.lastQuizDate === today
    ? progress.streak
    : progress.lastQuizDate === yesterday
      ? progress.streak + 1
      : 1;

  const nextWeakTopics = { ...progress.weakTopics };
  weakTopics.forEach((topic) => {
    nextWeakTopics[topic] = (nextWeakTopics[topic] ?? 0) + 1;
  });

  const needsReviewQuestionIds = Array.from(
    new Set([...progress.needsReviewQuestionIds, ...attempt.wrongQuestionIds]),
  );

  const bestScores = {
    ...progress.bestScores,
    [attempt.category]: Math.max(progress.bestScores[attempt.category] ?? 0, attempt.score),
  } satisfies Partial<Record<CategoryId, number>>;

  return {
    ...progress,
    coins: progress.coins + attempt.coinsEarned,
    streak: nextStreak,
    lastQuizDate: today,
    completedQuizzes: progress.completedQuizzes + 1,
    bestScores,
    attempts: [attempt, ...progress.attempts].slice(0, 20),
    weakTopics: nextWeakTopics,
    needsReviewQuestionIds,
  };
}
