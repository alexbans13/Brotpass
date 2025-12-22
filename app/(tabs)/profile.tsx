// Profile tab - user profile and stats
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { colors } from '@/constants/colors';

export default function ProfileScreen() {
  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Profile</Text>
      </View>
      
      <ScrollView style={styles.content}>
        <Text style={styles.placeholder}>
          User profile and stats will go here
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

