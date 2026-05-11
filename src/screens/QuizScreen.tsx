import React, { useMemo, useState } from 'react';
import { Pressable, SafeAreaView, ScrollView, Share, StyleSheet, Text, View } from 'react-native';
import { AdPlaceholder } from '../components/AdPlaceholder';
import { PrimaryButton } from '../components/PrimaryButton';
import { ProgressBar } from '../components/ProgressBar';
import { categories } from '../data/categories';
import { questions } from '../data/questions';
import { CategoryId, Question, QuizAttempt } from '../types/quiz';

type Props = {
  categoryId: CategoryId;
  onComplete: (attempt: QuizAttempt, wrongQuestions: Question[]) => void;
  onExit: () => void;
};

const QUIZ_LENGTH = 10;

export function QuizScreen({ categoryId, onComplete, onExit }: Props) {
  const category = categories.find((item) => item.id === categoryId)!;
  const quizQuestions = useMemo(() => questions.filter((item) => item.category === categoryId).slice(0, QUIZ_LENGTH), [categoryId]);
  const [index, setIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<string | null>(null);
  const [selectedAnswers, setSelectedAnswers] = useState<Record<string, string>>({});
  const [wrongQuestions, setWrongQuestions] = useState<Question[]>([]);

  const current = quizQuestions[index];
  const isAnswered = selectedAnswer !== null;
  const correctCount = quizQuestions.filter((question) => selectedAnswers[question.id] === question.correctAnswer).length;

  if (!current) {
    return null;
  }

  const selectAnswer = (answer: string) => {
    if (isAnswered) {
      return;
    }
    setSelectedAnswer(answer);
    setSelectedAnswers((answers) => ({ ...answers, [current.id]: answer }));
    if (answer !== current.correctAnswer) {
      setWrongQuestions((items) => [...items, current]);
    }
  };

  const next = () => {
    if (index < quizQuestions.length - 1) {
      setIndex((value) => value + 1);
      setSelectedAnswer(null);
      return;
    }

    const finalAnswers = { ...selectedAnswers, [current.id]: selectedAnswer ?? '' };
    const finalScore = quizQuestions.filter((question) => finalAnswers[question.id] === question.correctAnswer).length;
    const finalWrongQuestions = quizQuestions.filter((question) => finalAnswers[question.id] !== question.correctAnswer);
    const attempt: QuizAttempt = {
      id: `attempt-${Date.now()}`,
      category: categoryId,
      score: finalScore,
      total: quizQuestions.length,
      coinsEarned: finalScore * 10 + 20,
      completedAt: new Date().toISOString(),
      wrongQuestionIds: finalWrongQuestions.map((question) => question.id),
    };
    onComplete(attempt, finalWrongQuestions);
  };

  const shareQuestion = async () => {
    await Share.share({
      message: `Can you answer this? ${current.question}\nPractice on Quiz Nepal: quiznepal://quiz/${category.routeSlug}`,
    });
  };

  return (
    <SafeAreaView style={styles.safe}>
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.topRow}>
          <Pressable onPress={onExit}><Text style={styles.exit}>← Categories</Text></Pressable>
          <Text style={styles.score}>Score {correctCount}/{quizQuestions.length}</Text>
        </View>
        <Text style={styles.category}>{category.icon} {category.title}</Text>
        <ProgressBar progress={(index + (isAnswered ? 1 : 0)) / quizQuestions.length} color={category.color} />
        <Text style={styles.progressText}>Question {index + 1} of {quizQuestions.length}</Text>

        <View style={styles.questionCard}>
          <Text style={styles.topic}>{current.topic} · {current.difficulty}</Text>
          <Text style={styles.question}>{current.question}</Text>
          <Pressable onPress={shareQuestion} style={styles.shareCard}>
            <Text style={styles.shareText}>📣 Share question card placeholder · “Can you answer this?”</Text>
          </Pressable>
        </View>

        {current.options.map((option) => {
          const isCorrect = option === current.correctAnswer;
          const isSelected = option === selectedAnswer;
          return (
            <Pressable
              key={option}
              onPress={() => selectAnswer(option)}
              style={({ pressed }) => [
                styles.option,
                pressed && !isAnswered ? styles.pressed : null,
                isAnswered && isCorrect ? styles.correct : null,
                isAnswered && isSelected && !isCorrect ? styles.wrong : null,
              ]}
            >
              <Text style={styles.optionText}>{option}</Text>
            </Pressable>
          );
        })}

        {isAnswered ? (
          <View style={styles.feedback}>
            <Text style={styles.feedbackTitle}>{selectedAnswer === current.correctAnswer ? '✅ Correct!' : 'Needs review — wrong answer? Learn why.'}</Text>
            <Text style={styles.feedbackText}>Correct answer: {current.correctAnswer}</Text>
            <Text style={styles.feedbackText}>{current.explanation}</Text>
            <Text style={styles.review}>{selectedAnswer !== current.correctAnswer ? 'Marked as needs review for your profile.' : 'Nice! Confidence badhyo.'}</Text>
            <PrimaryButton label={index === quizQuestions.length - 1 ? 'See result' : 'Next question'} onPress={next} />
          </View>
        ) : (
          <AdPlaceholder type="rewarded" message="Future rewarded hint/extra life. MVP keeps quiz fair without forcing ads." />
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: '#F8FAFC' },
  container: { padding: 20, paddingBottom: 36 },
  topRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  exit: { color: '#2563EB', fontWeight: '800', fontSize: 15 },
  score: { color: '#0F172A', fontWeight: '900', backgroundColor: '#E2E8F0', paddingHorizontal: 12, paddingVertical: 7, borderRadius: 999 },
  category: { color: '#0F172A', fontSize: 24, fontWeight: '900', marginVertical: 14 },
  progressText: { color: '#64748B', marginTop: 8, fontWeight: '700' },
  questionCard: { backgroundColor: '#FFFFFF', borderRadius: 24, padding: 20, marginVertical: 16, shadowColor: '#0F172A', shadowOpacity: 0.06, shadowRadius: 14, elevation: 2 },
  topic: { color: '#DC2626', fontSize: 13, fontWeight: '900', textTransform: 'uppercase' },
  question: { color: '#0F172A', fontSize: 24, lineHeight: 32, fontWeight: '900', marginTop: 10 },
  shareCard: { backgroundColor: '#FEF3C7', padding: 12, borderRadius: 14, marginTop: 16 },
  shareText: { color: '#92400E', fontWeight: '800' },
  option: { backgroundColor: '#FFFFFF', borderRadius: 18, padding: 17, marginBottom: 10, borderWidth: 2, borderColor: '#E2E8F0' },
  pressed: { opacity: 0.86 },
  correct: { borderColor: '#16A34A', backgroundColor: '#DCFCE7' },
  wrong: { borderColor: '#DC2626', backgroundColor: '#FEE2E2' },
  optionText: { color: '#0F172A', fontSize: 16, fontWeight: '800' },
  feedback: { backgroundColor: '#FFFFFF', borderRadius: 22, padding: 18, marginTop: 8 },
  feedbackTitle: { color: '#0F172A', fontWeight: '900', fontSize: 18, marginBottom: 8 },
  feedbackText: { color: '#334155', lineHeight: 21, marginBottom: 6 },
  review: { color: '#7C3AED', fontWeight: '800', marginVertical: 8 },
});
