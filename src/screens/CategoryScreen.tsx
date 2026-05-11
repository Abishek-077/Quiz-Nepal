import React from 'react';
import { Pressable, SafeAreaView, ScrollView, StyleSheet, Text, View } from 'react-native';
import { categories } from '../data/categories';
import { CategoryId, UserProgress } from '../types/quiz';
import { AdPlaceholder } from '../components/AdPlaceholder';

type Props = {
  progress: UserProgress;
  onSelectCategory: (categoryId: CategoryId) => void;
  onBack: () => void;
};

export function CategoryScreen({ progress, onSelectCategory, onBack }: Props) {
  return (
    <SafeAreaView style={styles.safe}>
      <ScrollView contentContainerStyle={styles.container}>
        <Pressable onPress={onBack}><Text style={styles.back}>← Back</Text></Pressable>
        <Text style={styles.eyebrow}>Choose exam category</Text>
        <Text style={styles.title}>Start quiz immediately</Text>
        <Text style={styles.subtitle}>No long signup. Pick one topic and get score + explanation in your first session.</Text>
        <View style={styles.badges}>
          <Text style={styles.badge}>🔥 {progress.streak} streak</Text>
          <Text style={styles.badge}>🪙 {progress.coins} coins</Text>
        </View>
        {categories.map((category) => (
          <Pressable
            key={category.id}
            onPress={() => onSelectCategory(category.id)}
            style={({ pressed }) => [styles.card, pressed ? styles.pressed : null]}
          >
            <View style={[styles.iconWrap, { backgroundColor: category.color }]}><Text style={styles.icon}>{category.icon}</Text></View>
            <View style={styles.cardText}>
              <Text style={styles.cardTitle}>{category.title}</Text>
              <Text style={styles.cardSubtitle}>{category.subtitle}</Text>
              <Text style={styles.best}>Best: {progress.bestScores[category.id] ?? 0}/10 · Deep link: /quiz/{category.routeSlug}</Text>
            </View>
            <Text style={styles.arrow}>›</Text>
          </Pressable>
        ))}
        <AdPlaceholder type="banner" message="Future banner slot after value-first category selection." />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: '#F8FAFC' },
  container: { padding: 20, paddingBottom: 34 },
  back: { color: '#2563EB', fontSize: 16, fontWeight: '700', marginBottom: 12 },
  eyebrow: { color: '#DC2626', fontSize: 13, fontWeight: '900', textTransform: 'uppercase', letterSpacing: 0.8 },
  title: { color: '#0F172A', fontSize: 31, fontWeight: '900', marginTop: 6 },
  subtitle: { color: '#475569', fontSize: 15, lineHeight: 22, marginVertical: 10 },
  badges: { flexDirection: 'row', gap: 10, marginBottom: 10 },
  badge: { backgroundColor: '#FFFFFF', color: '#0F172A', borderRadius: 999, paddingHorizontal: 12, paddingVertical: 8, fontWeight: '800' },
  card: { flexDirection: 'row', alignItems: 'center', backgroundColor: '#FFFFFF', borderRadius: 22, padding: 16, marginTop: 12, shadowColor: '#0F172A', shadowOpacity: 0.05, shadowRadius: 12, elevation: 2 },
  pressed: { opacity: 0.86, transform: [{ scale: 0.99 }] },
  iconWrap: { width: 56, height: 56, borderRadius: 18, alignItems: 'center', justifyContent: 'center' },
  icon: { fontSize: 28 },
  cardText: { flex: 1, marginLeft: 14 },
  cardTitle: { fontSize: 18, color: '#0F172A', fontWeight: '900' },
  cardSubtitle: { color: '#475569', marginTop: 3, lineHeight: 19 },
  best: { color: '#64748B', fontSize: 12, marginTop: 6 },
  arrow: { fontSize: 34, color: '#94A3B8', fontWeight: '300' },
});
