# FXTM

## Before launching

Flutter version `3.24.5`

The freezed and mockito generated code should be first run with build_runner:

`dart run build_runner build --delete-conflicting-outputs && flutter pub get`

you can change the api keys or prod/mock env in .env file. 

I added .env and generated files (.freezed, .g) to github for the sake of the time.

## Notes:
I didn't test the Candles API in real time since it's a premium feature, but I set up a mock environment with sample data to verify the UI charts. Also, the WebSocket for Finhub may not work on weekends or might have delays since the Forex market is closed. To account for this, I implemented a mock WebSocket as well. I haven't tested it with real data yet, but I expect it should work.


## Please read the `DOC.md` for documentation and arch explanation

### Videos:



https://github.com/user-attachments/assets/87a07379-4010-499a-9db9-4220358f5b94


https://github.com/user-attachments/assets/595080df-186c-4200-ae56-c25fc7922e79

