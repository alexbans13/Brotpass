// Discover tab - bread search and browsing
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { colors } from '@/constants/colors';

export default function DiscoverScreen() {
  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Discover</Text>
        <Text style={styles.subtitle}>Find your next bread adventure</Text>
      </View>
      
      <ScrollView style={styles.content}>
        <Text style={styles.placeholder}>
          Bread search and discovery will go here
        </Text>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  header: {
    padding: 24,
    paddingTop: 60,
    backgroundColor: colors.surface,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: colors.text,
    marginBottom: 4,
  },
  subtitle: {
    fontSize: 16,
    color: colors.textSecondary,
  },
  content: {
    flex: 1,
    padding: 24,
  },
  placeholder: {
    fontSize: 16,
    color: colors.textLight,
    textAlign: 'center',
    marginTop: 48,
  },
});

