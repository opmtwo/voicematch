// Define a function to compute the average similarity across multiple fields
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:voicevibe/constants/types.dart';

// Define a class to hold the client and its similarity score
class ConnectionWithSimilarity {
  final ConnectionModel client;
  final double similarity;

  ConnectionWithSimilarity(this.client, this.similarity);
}

double averageSimilarity(String query, ConnectionModel client) {
  final fields = [client.member.givenName];
  return fields
          .map((field) => tokenSortPartialRatio(query, field ?? ''))
          .reduce((a, b) => a + b) /
      fields.length;
}

List<ConnectionModel> searchConnections(
    List<ConnectionModel> items, String query) {
  final matches = items
      .map((item) =>
          ConnectionWithSimilarity(item, averageSimilarity(query, item)))
      .where(
        (connectionWithSimilarity) => connectionWithSimilarity.similarity > 33,
      ) // You can adjust the similarity threshold here
      .toList();

  matches.sort(
    (a, b) => b.similarity.compareTo(
      a.similarity,
    ),
  ); // Sort by similarity score in descending order

  return matches
      .map((connectionWithSimilarity) => connectionWithSimilarity.client)
      .toList();
}
