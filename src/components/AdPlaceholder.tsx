import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

type Props = {
  type: 'banner' | 'interstitial' | 'rewarded';
  message?: string;
};

export function AdPlaceholder({ type, message }: Props) {
  return (
    <View style={[styles.container, type === 'banner' ? styles.banner : styles.card]}>
      <Text style={styles.label}>{type.toUpperCase()} AD PLACEHOLDER</Text>
      <Text style={styles.message}>{message ?? 'AdMob-ready slot. No ad is loaded in MVP.'}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    borderWidth: 1,
    borderColor: '#CBD5E1',
    borderStyle: 'dashed',
    backgroundColor: '#F8FAFC',
    borderRadius: 16,
    padding: 14,
    marginVertical: 10,
  },
  banner: {
    minHeight: 64,
    alignItems: 'center',
    justifyContent: 'center',
  },
  card: {
    minHeight: 92,
  },
  label: {
    color: '#64748B',
    fontSize: 11,
    fontWeight: '800',
    letterSpacing: 0.8,
  },
  message: {
    color: '#475569',
    fontSize: 13,
    marginTop: 4,
    textAlign: 'center',
  },
});
