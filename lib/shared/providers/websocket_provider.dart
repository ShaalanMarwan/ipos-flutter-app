import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'dart:convert';
import '../../core/config/environment.dart';
import '../../core/config/constants.dart';

part 'websocket_provider.g.dart';

@riverpod
class WebSocketManager extends _$WebSocketManager {
  final _persistentChannels = <String, WebSocketChannel>{};
  final _onDemandChannels = <String, WebSocketChannel>{};
  final _reconnectTimers = <String, Timer>{};

  @override
  Future<void> build() async {
    ref.onDispose(() {
      _cleanup();
    });
    
    // Initialize persistent connections
    await _initializePersistentConnections();
  }

  Future<void> _initializePersistentConnections() async {
    // Critical real-time features
    _persistentChannels['orders'] = await _connectWithRetry('${Environment.config.wsBaseUrl}/orders/live');
    _persistentChannels['kitchen'] = await _connectWithRetry('${Environment.config.wsBaseUrl}/kitchen/live');
    _persistentChannels['inventory'] = await _connectWithRetry('${Environment.config.wsBaseUrl}/inventory/live');
  }

  Future<WebSocketChannel> _connectWithRetry(String url) async {
    int retryCount = 0;
    
    while (retryCount < AppConstants.maxRetryAttempts) {
      try {
        final channel = IOWebSocketChannel.connect(Uri.parse(url));
        await channel.ready;
        
        // Set up reconnection on disconnect
        channel.stream.listen(
          (_) {},
          onDone: () => _handleDisconnect(url),
          onError: (_) => _handleDisconnect(url),
        );
        
        return channel;
      } catch (e) {
        retryCount++;
        if (retryCount >= AppConstants.maxRetryAttempts) {
          rethrow;
        }
        await Future.delayed(AppConstants.wsReconnectDelay);
      }
    }
    
    throw Exception('Failed to connect to WebSocket: $url');
  }

  void _handleDisconnect(String url) {
    // Cancel existing timer if any
    _reconnectTimers[url]?.cancel();
    
    // Schedule reconnection
    _reconnectTimers[url] = Timer(AppConstants.wsReconnectDelay, () async {
      try {
        final channelKey = _persistentChannels.entries
            .firstWhere((entry) => entry.value.closeCode != null)
            .key;
        
        _persistentChannels[channelKey] = await _connectWithRetry(url);
      } catch (e) {
        // Retry again after delay
        _handleDisconnect(url);
      }
    });
  }

  Stream<T> subscribePersistent<T>(String channel, String event) {
    final ws = _persistentChannels[channel];
    if (ws == null) {
      throw Exception('Channel $channel not found');
    }
    
    return ws.stream
        .where((data) {
          final decoded = jsonDecode(data);
          return decoded['event'] == event;
        })
        .map((data) => _parseWebSocketData<T>(jsonDecode(data)));
  }

  Future<Stream<T>> subscribeOnDemand<T>(String url, String event) async {
    final ws = await _connectOnDemand(url);
    return ws.stream
        .where((data) {
          final decoded = jsonDecode(data);
          return decoded['event'] == event;
        })
        .map((data) => _parseWebSocketData<T>(jsonDecode(data)));
  }

  Future<WebSocketChannel> _connectOnDemand(String url) async {
    final channel = IOWebSocketChannel.connect(Uri.parse(url));
    await channel.ready;
    
    _onDemandChannels[url] = channel;
    
    // Auto-cleanup after 5 minutes of inactivity
    Timer(const Duration(minutes: 5), () {
      _onDemandChannels[url]?.sink.close();
      _onDemandChannels.remove(url);
    });
    
    return channel;
  }

  void sendMessage(String channel, Map<String, dynamic> message) {
    final ws = _persistentChannels[channel];
    if (ws == null) {
      throw Exception('Channel $channel not found');
    }
    
    ws.sink.add(jsonEncode(message));
  }

  T _parseWebSocketData<T>(Map<String, dynamic> data) {
    // TODO: Implement proper parsing based on type T
    return data['data'] as T;
  }

  void _cleanup() {
    // Cancel all timers
    for (final timer in _reconnectTimers.values) {
      timer.cancel();
    }
    _reconnectTimers.clear();
    
    // Close all channels
    for (final channel in _persistentChannels.values) {
      channel.sink.close();
    }
    _persistentChannels.clear();
    
    for (final channel in _onDemandChannels.values) {
      channel.sink.close();
    }
    _onDemandChannels.clear();
  }
}