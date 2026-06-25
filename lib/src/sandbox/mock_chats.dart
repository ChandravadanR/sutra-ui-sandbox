/// SANDBOX-ONLY mock data.
///
/// Stands in for the real Personal/Business chat lists that the app loads from
/// the Rust backend (Matrix). None of the real chat/backend code ships with the
/// sandbox — these are plain hard-coded rows so the drawer has something to show.
class MockChat {
  const MockChat({
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    this.isGroup = false,
    this.pinned = false,
  });

  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final bool isGroup;
  final bool pinned;
}

const personalChats = <MockChat>[
  MockChat(
    name: 'Aanya',
    lastMessage: 'See you at 6 for yoga!',
    time: '8m',
    unread: 2,
    pinned: true,
  ),
  MockChat(name: 'Rohan', lastMessage: 'Sent the notes 📒', time: '45m', unread: 1),
  MockChat(
    name: 'Family',
    lastMessage: 'Mom: dinner at 8',
    time: '2h',
    isGroup: true,
  ),
  MockChat(name: 'Priya', lastMessage: 'Cricket match tomorrow?', time: '4h'),
  MockChat(name: 'Karan', lastMessage: 'Thanks 🙏', time: 'Yesterday'),
];

const businessChats = <MockChat>[
  MockChat(
    name: 'Stoicism 101 · Anika',
    lastMessage: 'New module: Marcus Aurelius',
    time: '15m',
    unread: 5,
    isGroup: true,
    pinned: true,
  ),
  MockChat(
    name: 'Sunrise Yoga · Priya',
    lastMessage: 'Live in 2 hours 🧘',
    time: '30m',
    unread: 3,
    isGroup: true,
  ),
  MockChat(
    name: 'Strength & Conditioning',
    lastMessage: 'Coach: warmup video posted',
    time: '3h',
    isGroup: true,
  ),
  MockChat(
    name: 'Sutra Promotions',
    lastMessage: '20% off creator courses this week',
    time: '12h',
    isGroup: true,
  ),
];
