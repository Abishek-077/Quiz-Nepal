import React, { useEffect, useState } from 'react';
import { ActivityIndicator, SafeAreaView, StyleSheet, Text } from 'react-native';
import { CategoryScreen } from './src/screens/CategoryScreen';
import { LeaderboardScreen } from './src/screens/LeaderboardScreen';
import { ProfileScreen } from './src/screens/ProfileScreen';
import { QuizScreen } from './src/screens/QuizScreen';
import { ResultScreen } from './src/screens/ResultScreen';
import { WelcomeScreen } from './src/screens/WelcomeScreen';
import { CategoryId, Question, QuizAttempt, UserProgress } from './src/types/quiz';
import { applyQuizAttempt, defaultProgress, loadProgress, saveProgress } from './src/utils/progress';

type Screen = 'welcome' | 'categories' | 'quiz' | 'result' | 'leaderboard' | 'profile';

export default function App() {
  const [screen, setScreen] = useState<Screen>('welcome');
  const [progress, setProgress] = useState<UserProgress>(defaultProgress);
  const [selectedCategory, setSelectedCategory] = useState<CategoryId>('nepal-gk');
  const [lastAttempt, setLastAttempt] = useState<QuizAttempt | null>(null);
  const [lastWrongQuestions, setLastWrongQuestions] = useState<Question[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    void loadProgress()
      .then(setProgress)
      .finally(() => setLoading(false));
  }, []);

  const completeQuiz = (attempt: QuizAttempt, wrongQuestions: Question[]) => {
    const nextProgress = applyQuizAttempt(progress, attempt, wrongQuestions.map((question) => question.topic));
    setProgress(nextProgress);
    setLastAttempt(attempt);
    setLastWrongQuestions(wrongQuestions);
    setScreen('result');
    void saveProgress(nextProgress);
  };

  const startCategory = (categoryId: CategoryId) => {
    setSelectedCategory(categoryId);
    setScreen('quiz');
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.loading}>
        <Text style={styles.loadingLogo}>🇳🇵</Text>
        <ActivityIndicator color="#DC2626" size="large" />
        <Text style={styles.loadingText}>Loading Quiz Nepal...</Text>
      </SafeAreaView>
    );
  }

  if (screen === 'categories') {
    return <CategoryScreen progress={progress} onSelectCategory={startCategory} onBack={() => setScreen('welcome')} />;
  }

  if (screen === 'quiz') {
    return <QuizScreen categoryId={selectedCategory} onComplete={completeQuiz} onExit={() => setScreen('categories')} />;
  }

  if (screen === 'result' && lastAttempt) {
    return (
      <ResultScreen
        attempt={lastAttempt}
        wrongQuestions={lastWrongQuestions}
        progress={progress}
        onTryAgain={() => setScreen('quiz')}
        onCategories={() => setScreen('categories')}
        onLeaderboard={() => setScreen('leaderboard')}
        onProfile={() => setScreen('profile')}
      />
    );
  }

  if (screen === 'leaderboard') {
    return <LeaderboardScreen progress={progress} onBack={() => setScreen('welcome')} onProfile={() => setScreen('profile')} />;
  }

  if (screen === 'profile') {
    return <ProfileScreen progress={progress} onBack={() => setScreen('welcome')} onCategories={() => setScreen('categories')} />;
  }

  return (
    <WelcomeScreen
      progress={progress}
      onStart={() => setScreen('categories')}
      onLeaderboard={() => setScreen('leaderboard')}
      onProfile={() => setScreen('profile')}
    />
  );
}

const styles = StyleSheet.create({
  loading: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#EAF4FF',
  },
  loadingLogo: {
    fontSize: 56,
    marginBottom: 18,
  },
  loadingText: {
    color: '#0F172A',
    fontSize: 18,
    fontWeight: '800',
    marginTop: 14,
  },
});
