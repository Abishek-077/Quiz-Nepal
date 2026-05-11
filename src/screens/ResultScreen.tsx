import React from 'react';
import { SafeAreaView, ScrollView, Share, StyleSheet, Text, View } from 'react-native';
import { AdPlaceholder } from '../components/AdPlaceholder';
import { PrimaryButton } from '../components/PrimaryButton';
import { categories } from '../data/categories';
import { Question, QuizAttempt, UserProgress } from '../types/quiz';

type Props = {
  attempt: QuizAttempt;
  wrongQuestions: Question[];
  progress: UserProgress;
  onTryAgain: () => void;
  onCategories: () => void;
  onLeaderboard: () => void;
  onProfile: () => void;
};

const messageForScore = (score: number, total: number) => {
  const ratio = score / total;
  if (ratio >= 0.9) return 'Top rank energy! Mock test ready mindset.';
  if (ratio >= 0.7) return 'Strong prep. Beat your previous score next.';
  if (ratio >= 0.5) return 'Good start. Review weak topics and try again.';
  return 'No stress, sathi. Learn the explanations and improve fast.';
};

export function ResultScreen({ attempt, wrongQuestions, progress, onTryAgain, onCategories, onLeaderboard, onProfile }: Props) {
  const category = categories.find((item) => item.id === attempt.category);
  const shareScore = async () => {
    await Share.share({
      message: `I scored ${attempt.score}/${attempt.total} in ${category?.title ?? 'Quiz Nepal'} on Quiz Nepal 🇳🇵. Can you beat me? quiznepal://quiz/${category?.routeSlug ?? 'daily'}`,
    });
  };

  const showInterstitial = progress.completedQuizzes > 0 && progress.completedQuizzes % 3 === 0;

  return (
    <SafeAreaView style={styles.safe}>
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.card}>
          <Text style={styles.emoji}>{attempt.score >= 7 ? '🏆' : '📈'}</Text>
          <Text style={styles.title}>Result: {attempt.score}/{attempt.total}</Text>
          <Text style={styles.message}>{messageForScore(attempt.score, attempt.total)}</Text>
          <View style={styles.rewardRow}>
            <Text style={styles.reward}>🪙 +{attempt.coinsEarned} coins</Text>
            <Text style={styles.reward}>🔥 {progress.streak} streak</Text>
          </View>
        </View>

        {showInterstitial ? <AdPlaceholder type="interstitial" message="Future interstitial after every 3 completed quizzes, never before learning value." /> : null}

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Needs review</Text>
          {wrongQuestions.length === 0 ? (
            <Text style={styles.empty}>Perfect! No weak topics from this quiz.</Text>
          ) : wrongQuestions.map((question) => (
            <View key={question.id} style={styles.reviewCard}>
              <Text style={styles.topic}>{question.topic}</Text>
              <Text style={styles.question}>{question.question}</Text>
              <Text style={styles.answer}>Correct: {question.correctAnswer}</Text>
              <Text style={styles.explanation}>{question.explanation}</Text>
            </View>
          ))}
        </View>

        <PrimaryButton label="Try again and beat your score" onPress={onTryAgain} />
        <PrimaryButton label="Share score" onPress={shareScore} variant="secondary" />
        <PrimaryButton label="Leaderboard" onPress={onLeaderboard} variant="ghost" />
        <PrimaryButton label="Profile / weak topics" onPress={onProfile} variant="ghost" />
        <PrimaryButton label="Choose another category" onPress={onCategories} variant="ghost" />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: '#F8FAFC' },
  container: { padding: 20, paddingBottom: 36 },
  card: { backgroundColor: '#0F172A', borderRadius: 28, padding: 24, alignItems: 'center' },
  emoji: { fontSize: 48 },
  title: { color: '#FFFFFF', fontSize: 32, fontWeight: '900', marginTop: 8 },
  message: { color: '#CBD5E1', textAlign: 'center', lineHeight: 22, marginTop: 8 },
  rewardRow: { flexDirection: 'row', gap: 10, marginTop: 18 },
  reward: { backgroundColor: '#1E293B', color: '#FFFFFF', borderRadius: 999, paddingHorizontal: 12, paddingVertical: 8, fontWeight: '900' },
  section: { marginTop: 18 },
  sectionTitle: { color: '#0F172A', fontSize: 22, fontWeight: '900', marginBottom: 10 },
  empty: { color: '#16A34A', backgroundColor: '#DCFCE7', padding: 14, borderRadius: 16, fontWeight: '800' },
  reviewCard: { backgroundColor: '#FFFFFF', borderRadius: 18, padding: 15, marginBottom: 10 },
  topic: { color: '#7C3AED', fontWeight: '900', fontSize: 12, textTransform: 'uppercase' },
  question: { color: '#0F172A', fontWeight: '900', marginTop: 6, lineHeight: 20 },
  answer: { color: '#16A34A', fontWeight: '900', marginTop: 8 },
  explanation: { color: '#475569', marginTop: 4, lineHeight: 20 },
});
