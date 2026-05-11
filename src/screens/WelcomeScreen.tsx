import React from 'react';
import { SafeAreaView, StyleSheet, Text, View } from 'react-native';
import { PrimaryButton } from '../components/PrimaryButton';
import { UserProgress } from '../types/quiz';

type Props = {
  progress: UserProgress;
  onStart: () => void;
  onLeaderboard: () => void;
  onProfile: () => void;
};

export function WelcomeScreen({ progress, onStart, onLeaderboard, onProfile }: Props) {
  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.container}>
        <View style={styles.heroCard}>
          <Text style={styles.logo}>🇳🇵</Text>
          <Text style={styles.title}>Quiz Nepal</Text>
          <Text style={styles.subtitle}>Exam prep that feels like a battle game — fast feedback, explanations, and daily confidence.</Text>
          <View style={styles.statsRow}>
            <View style={styles.statPill}><Text style={styles.statValue}>🔥 {progress.streak}</Text><Text style={styles.statLabel}>day streak</Text></View>
            <View style={styles.statPill}><Text style={styles.statValue}>🪙 {progress.coins}</Text><Text style={styles.statLabel}>coins</Text></View>
          </View>
        </View>

        <View style={styles.copyCard}>
          <Text style={styles.copyTitle}>Take your first quiz in 30 seconds.</Text>
          <Text style={styles.copy}>Driving License, Loksewa GK, Nepal GK, Computer/IT, or Fun IQ. Wrong answer? Learn why.</Text>
        </View>

        <PrimaryButton label="Start today’s challenge" onPress={onStart} />
        <PrimaryButton label="View leaderboard" onPress={onLeaderboard} variant="secondary" />
        <PrimaryButton label="My progress" onPress={onProfile} variant="ghost" />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: '#EAF4FF' },
  container: { flex: 1, padding: 20, justifyContent: 'center' },
  heroCard: { backgroundColor: '#FFFFFF', borderRadius: 28, padding: 24, shadowColor: '#0F172A', shadowOpacity: 0.08, shadowRadius: 20, elevation: 4 },
  logo: { fontSize: 54, textAlign: 'center' },
  title: { fontSize: 38, fontWeight: '900', color: '#0F172A', textAlign: 'center', marginTop: 8 },
  subtitle: { fontSize: 16, color: '#475569', textAlign: 'center', lineHeight: 24, marginTop: 10 },
  statsRow: { flexDirection: 'row', gap: 12, marginTop: 22 },
  statPill: { flex: 1, backgroundColor: '#F8FAFC', borderRadius: 18, padding: 14, alignItems: 'center' },
  statValue: { fontSize: 18, fontWeight: '900', color: '#0F172A' },
  statLabel: { fontSize: 12, color: '#64748B', marginTop: 2 },
  copyCard: { backgroundColor: '#DBEAFE', borderRadius: 20, padding: 16, marginVertical: 18 },
  copyTitle: { color: '#1E3A8A', fontWeight: '900', fontSize: 17 },
  copy: { color: '#1E40AF', marginTop: 4, lineHeight: 20 },
});
