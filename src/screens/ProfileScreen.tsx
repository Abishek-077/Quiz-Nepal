import React from 'react';
import { Pressable, SafeAreaView, ScrollView, StyleSheet, Text, View } from 'react-native';
import { AdPlaceholder } from '../components/AdPlaceholder';
import { categories } from '../data/categories';
import { questions } from '../data/questions';
import { UserProgress } from '../types/quiz';

type Props = {
  progress: UserProgress;
  onBack: () => void;
  onCategories: () => void;
};

export function ProfileScreen({ progress, onBack, onCategories }: Props) {
  const weakTopics = Object.entries(progress.weakTopics).sort((a, b) => b[1] - a[1]).slice(0, 6);
  const reviewQuestions = questions.filter((question) => progress.needsReviewQuestionIds.includes(question.id)).slice(0, 8);

  return (
    <SafeAreaView style={styles.safe}>
      <ScrollView contentContainerStyle={styles.container}>
        <Pressable onPress={onBack}><Text style={styles.back}>← Back</Text></Pressable>
        <Text style={styles.title}>My Progress</Text>
        <Text style={styles.subtitle}>Fast feedback today, confidence tomorrow. Complete today’s quiz and keep your streak.</Text>
        <View style={styles.grid}>
          <View style={styles.stat}><Text style={styles.value}>🔥 {progress.streak}</Text><Text style={styles.label}>Daily streak</Text></View>
          <View style={styles.stat}><Text style={styles.value}>🪙 {progress.coins}</Text><Text style={styles.label}>Coins</Text></View>
          <View style={styles.stat}><Text style={styles.value}>{progress.completedQuizzes}</Text><Text style={styles.label}>Quizzes</Text></View>
          <View style={styles.stat}><Text style={styles.value}>{progress.needsReviewQuestionIds.length}</Text><Text style={styles.label}>Review</Text></View>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Best scores</Text>
          {categories.map((category) => (
            <View key={category.id} style={styles.scoreRow}>
              <Text style={styles.scoreName}>{category.icon} {category.title}</Text>
              <Text style={styles.scoreValue}>{progress.bestScores[category.id] ?? 0}/10</Text>
            </View>
          ))}
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Weak topics</Text>
          {weakTopics.length === 0 ? <Text style={styles.empty}>Take a quiz to discover weak topics.</Text> : weakTopics.map(([topic, count]) => (
            <Text key={topic} style={styles.topic}>• {topic}: {count} review mark{count > 1 ? 's' : ''}</Text>
          ))}
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Needs review questions</Text>
          {reviewQuestions.length === 0 ? <Text style={styles.empty}>No wrong answers saved yet. Nice start!</Text> : reviewQuestions.map((question) => (
            <View key={question.id} style={styles.reviewCard}>
              <Text style={styles.reviewTopic}>{question.topic}</Text>
              <Text style={styles.reviewQuestion}>{question.question}</Text>
              <Text style={styles.reviewAnswer}>Correct: {question.correctAnswer}</Text>
            </View>
          ))}
        </View>

        <AdPlaceholder type="banner" message="Premium future: no ads, mock tests, AI explanations, analytics." />
        <Pressable onPress={onCategories} style={styles.cta}><Text style={styles.ctaText}>Practice now →</Text></Pressable>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: '#F8FAFC' },
  container: { padding: 20, paddingBottom: 36 },
  back: { color: '#2563EB', fontSize: 16, fontWeight: '800', marginBottom: 12 },
  title: { color: '#0F172A', fontSize: 32, fontWeight: '900' },
  subtitle: { color: '#475569', lineHeight: 22, marginTop: 8 },
  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: 10, marginVertical: 16 },
  stat: { width: '48%', backgroundColor: '#FFFFFF', borderRadius: 18, padding: 16 },
  value: { color: '#0F172A', fontSize: 21, fontWeight: '900' },
  label: { color: '#64748B', marginTop: 4, fontWeight: '700' },
  section: { backgroundColor: '#FFFFFF', borderRadius: 20, padding: 16, marginBottom: 14 },
  sectionTitle: { color: '#0F172A', fontSize: 20, fontWeight: '900', marginBottom: 10 },
  scoreRow: { flexDirection: 'row', justifyContent: 'space-between', paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: '#F1F5F9' },
  scoreName: { color: '#0F172A', fontWeight: '800' },
  scoreValue: { color: '#16A34A', fontWeight: '900' },
  empty: { color: '#64748B', lineHeight: 20 },
  topic: { color: '#334155', paddingVertical: 4, fontWeight: '700' },
  reviewCard: { backgroundColor: '#F8FAFC', borderRadius: 14, padding: 12, marginBottom: 8 },
  reviewTopic: { color: '#7C3AED', fontSize: 12, fontWeight: '900', textTransform: 'uppercase' },
  reviewQuestion: { color: '#0F172A', fontWeight: '800', marginTop: 4, lineHeight: 19 },
  reviewAnswer: { color: '#16A34A', fontWeight: '900', marginTop: 5 },
  cta: { backgroundColor: '#0F172A', borderRadius: 16, padding: 16, alignItems: 'center' },
  ctaText: { color: '#FFFFFF', fontWeight: '900', fontSize: 16 },
});
