import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/buddies_service.dart';

class BuddiesScreen extends StatelessWidget {
  const BuddiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    BuddiesService buddiesService = BuddiesService();

    return Scaffold(
      appBar: AppBar(title: const Text("Buddies")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Be My Buddy Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            StreamBuilder<List<String>>(
              stream: buddiesService.getBuddyRequests(currentUserId),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No pending buddy requests.");
                }

                List<String> requestIds = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: requestIds.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(requestIds[index])
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData ||
                            !userSnapshot.data!.exists) {
                          return const SizedBox.shrink();
                        }

                        var userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(userData['profilePic'] ?? ''),
                          ),
                          title: Text(userData['name'] ?? 'Unknown'),
                          subtitle: Text(userData['email'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                onPressed: () {
                                  buddiesService.acceptBuddyRequest(
                                      currentUserId, requestIds[index]);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  buddiesService.declineBuddyRequest(
                                      currentUserId, requestIds[index]);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("Your Buddies",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            StreamBuilder<List<String>>(
              stream: buddiesService.getBuddies(currentUserId),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No buddies yet.");
                }

                List<String> buddyIds = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: buddyIds.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(buddyIds[index])
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData ||
                            !userSnapshot.data!.exists) {
                          return const SizedBox.shrink();
                        }

                        var userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(userData['profilePic'] ?? ''),
                          ),
                          title: Text(userData['name'] ?? 'Unknown'),
                          subtitle: Text(userData['email'] ?? ''),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
