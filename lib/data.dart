import 'core/net_image.dart';

/// Sample profiles for the UI demo. The full app loads real users from the backend.
class Profile {
  const Profile({required this.name, required this.age, required this.city, required this.km, required this.job, required this.bio, required this.photo, required this.interests, this.verified = false});
  final String name, city, job, bio, photo;
  final int age, km;
  final List<String> interests;
  final bool verified;
}

final profiles = <Profile>[
  Profile(name: 'Aisha', age: 26, city: 'Mumbai', km: 3, job: 'Product Designer', bio: 'Chai > coffee. Weekend treks, film photography and long brunches.', photo: unsplash('1494790108377-be9c29b29330', w: 900), interests: ['Travel', 'Photography', 'Yoga'], verified: true),
  Profile(name: 'Rohan', age: 28, city: 'Bengaluru', km: 5, job: 'Software Engineer', bio: 'Guitarist, amateur chef and certified dog person 🐶', photo: unsplash('1507003211169-0a1dd7228f2d', w: 900), interests: ['Music', 'Cooking', 'Dogs'], verified: true),
  Profile(name: 'Meera', age: 25, city: 'Pune', km: 2, job: 'Architect', bio: 'Sketching cities, one café at a time. Looking for my partner in crime for food walks.', photo: unsplash('1534528741775-53994a69daeb', w: 900), interests: ['Art', 'Food', 'Books']),
  Profile(name: 'Kabir', age: 29, city: 'Delhi', km: 8, job: 'Marketing Lead', bio: 'Marathons on Sundays, stand-up comedy on Fridays.', photo: unsplash('1500648767791-00dcc994a43e', w: 900), interests: ['Running', 'Comedy', 'Startups'], verified: true),
  Profile(name: 'Zara', age: 27, city: 'Hyderabad', km: 4, job: 'Doctor', bio: 'Saving lives by day, binge-watching thrillers by night.', photo: unsplash('1517841905240-472988babdf9', w: 900), interests: ['Movies', 'Dance', 'Travel']),
  Profile(name: 'Ishita', age: 24, city: 'Jaipur', km: 6, job: 'Fashion Stylist', bio: 'Vintage markets, sunsets and spontaneous road trips.', photo: unsplash('1524504388940-b1c1722653e1', w: 900), interests: ['Fashion', 'Road trips', 'Music'], verified: true),
];

class Chat {
  const Chat(this.profile, this.last, this.time, {this.unread = 0, this.online = false});
  final Profile profile;
  final String last, time;
  final int unread;
  final bool online;
}

final chats = <Chat>[
  Chat(profiles[0], 'Haha that trek sounds amazing! When?', '2m', unread: 2, online: true),
  Chat(profiles[2], 'You had me at food walks 😄', '1h', unread: 1, online: true),
  Chat(profiles[4], 'Seen that one! The ending was wild', 'Yesterday'),
  Chat(profiles[5], 'Sunset point this Sunday?', 'Mon'),
];
