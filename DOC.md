# FXTM Forex Tracker App Documentation

## Key Components

### Core Services

1. **ApiClient**: Centralized DIO HTTP client with request handling, logging, and connectivity checking.

2. **ConnectivityService**: Monitors device internet connectivity using the connectivity_plus package.

3. **CacheService**: Manages data caching using SharedPreferences with timestamp-based invalidation.

4. **ErrorService**: Central error handling service that standardizes error formats across the app.

5. **FinnhubService**: Provides API methods to fetch forex pairs and historical data from Finnhub.

6. **WebSocketClient**: Manages WebSocket connections with connect, disconnect, and send functionality.

7. **WsService**: Higher-level WebSocket service that handles subscribing to forex symbols and processing updates.

### Data Layer

1. **Models**:
   - **API Models**: Data transfer objects mapped directly from API responses
   - **Domain Models**: Application-specific models used for business logic
   - **UI Models**: Simplified models optimized for presentation

2. **Repositories**:
   - **ForexRepository**: Coordinates between services and UI, combining data from API and cache

### UI Layer

1. **Pages**:
   - **MainPage**: Root container with tab navigation
   - **ForexPairsScreen**: Displays real-time forex pair prices
   - **HistoryPage**: Shows historical data with interactive charts

2. **State Management**:
   - Uses Flutter Bloc (Cubit) pattern for state management
   - Each screen has dedicated Cubit and State implementations

## Data Flow

1. **Real-time Price Updates**:
   ```
   WebSocketClient → WsService → ForexPairsCubit → ForexPairsScreen → UI Update
   ```

2. **Historical Data Retrieval**:
   ```
   ApiClient → FinnhubService → ForexRepository → HistoryCubit → HistoryPage → Charts
   ```

3. **Error Handling**:
   ```
   Exception → ErrorService → ErrorUI (SnackBar/Dialog) → User Feedback
   ```

## Dependency Injection Flow

The app uses constructor-based dependency injection without external packages. Here's the flow:

```
SharedPreferences → CacheService → ForexRepository → MainPage → UI Screens
                                    ↑                ↑
ConnectivityService → ApiClient → FinnhubService ───┤
ConnectivityService → WebSocketClient → WsService ──┘
```

## Environment Configuration

The app supports two environments:
- **Production**: Uses real Finnhub API for live data
- **Mock**: Uses simulated data for development and testing

Environment switching is controlled via the `.env` file's `FLAVOR` setting `prod` or `mock`.

## Testing Strategy
Using Mokito for generate mock classes, covered a couple of tests, for example, not all, using the coverage folder to check the coverage percent.

This allows testing the application logic without relying on external services.

##
Code Coverage
- ![Screenshot 2025-03-03 at 01.37.26.png](..%2F..%2F..%2F..%2Fvar%2Ffolders%2Fr8%2F842m9prn3vj5cg1y_56xq88w0000gq%2FT%2FTemporaryItems%2FNSIRD_screencaptureui_kwWOeQ%2FScreenshot%202025-03-03%20at%2001.37.26.png)

## Technical Highlights

- **Caching Strategy**: Time-based cache invalidation ensures fresh data while reducing API calls
- **Error Handling**: Centralized error processing with user-friendly messages
- **Offline Support**: Graceful degradation when network connectivity is lost
- **Responsive UI**: Adapts to different screen sizes and orientations
- **Real-time Updates**: WebSocket implementation provides live forex data updates

## TO-DOs
- Use a get-it package for dependency injection.
- Optimize WebSocket client and WebSocket service.
- Optimize error handling and internet connectivity check for WebSocket.
- Localization and all the text files should be stored in one language file.
- Loader for specific components not for whole page when data is retrieving
- Better caching mechanism and local DB hive
- Code linters fix
