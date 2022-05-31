
Future<List<List<String?>>> constructIpsByThread(List<dynamic> args)async{
  int maxThreads = args[0];
  List<String?> ips = args[1];
  int maxTasks = (ips.length / maxThreads).ceil();
  List<List<String?>> tasksByThread = [];
  for (int i = 0; i < maxThreads; i++) {
    List<String?> _ = ips.skip(i * maxTasks).take(maxTasks).toList();
    _.isNotEmpty ? tasksByThread.add(_) : null;
  }
  return tasksByThread;
}