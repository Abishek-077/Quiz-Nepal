import React from 'react';
import { Pressable, SafeAreaView, ScrollView, StyleSheet, Text, View } from 'react-native';
import { leaderboard } from '../data/leaderboard';
import { UserProgress } from '../types/quiz';

type Props = {
  progress: UserProgress;
  onBack: () => void;
  onProfile: () => void;
};

export function LeaderboardScreen({ progress, onBack, onProfile }: Props) {
  const userScore = progress.attempts.reduce((sum, attempt) => sum + attempt.score * 100, 0) + progress.coins;

  return (
    <SafeAreaView style={styles.safe}>
      <ScrollView contentContainerStyle={styles.container}>
        <Pressable onPress={onBack}><Text style={styles.back}>← Back</Text></Pressable>
        <Text style={styles.title}>Leaderboard</Text>
        <Text style={styles.subtitle}>Healthy competition only. Leaderboard should motivate practice, not pressure.</Text>
        <View style={styles.meCard}>
          <Text style={styles.meTitle}>Your current rank card</Text>
          <Text style={styles.meScore}>{userScore} pts · 🔥 {progress.streak} streak · 🪙 {progress.coins}</Text>
          <Pressable onPress={onProfile}><Text style={styles.profileLink}>Review weak topics →</Text></Pressable>
        </View>
        {leaderboard.map((entry, index) => (
          <View key={entry.id} style={styles.row}>
            <Text style={styles.rank}>#{index + 1}</Text>
            <View style={styles.details}>
              <Text style={styles.name}>{entry.name}</Text>
              <Text style={styles.meta}>{entry.city} · {entry.category} · 🔥 {entry.streak}</Text>
            </View>
            <Text style={styles.points}>{entry.score}</Text>
          </View>
        ))}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: '#F8FAFC' },
  container: { padding: 20, paddingBottom: 36 },
  back: { color: '#2563EB', fontSize: 16, fontWeight: '800', marginBottom: 12 },
  title: { color: '#0F172A', fontSize: 32, fontWeight: '900' },
  subtitle: { color: '#475569', lineHeight: 22, marginTop: 8, marginBottom: 16 },
  meCard: { backgroundColor: '#DBEAFE', borderRadius: 22, padding: 18, marginBottom: 14 },
  meTitle: { color: '#1E3A8A', fontWeight: '900', fontSize: 18 },
  meScore: { color: '#1E40AF', fontWeight: '800', marginTop: 6 },
  profileLink: { color: '#1D4ED8', fontWeight: '900', marginTop: 10 },
  row: { flexDirection: 'row', alignItems: 'center', backgroundColor: '#FFFFFF', borderRadius: 18, padding: 15, marginBottom: 10 },
  rank: { color: '#DC2626', fontSize: 18, fontWeight: '900', width: 44 },
  details: { flex: 1 },
  name: { color: '#0F172A', fontSize: 17, fontWeight: '900' },
  meta: { color: '#64748B', marginTop: 3 },
  points: { color: '#0F172A', fontWeight: '900' },
});
