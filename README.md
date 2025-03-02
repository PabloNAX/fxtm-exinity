# FXTM

## Before launching

Flutter version 3.24.5


The freezed and mockito generated code should be first run with build_runner:

`dart run build_runner build --delete-conflicting-outputs && flutter pub get`

you can change the api keys or prod/mock env in .env file. 

I added .env and generated files (.freezed, .g) to github for the sake of the time.

## Notes:
Candles API is premium, and i didn't check it in real time, but i implemented mock env with mock data to check the UI charts
Also WebSocket Finhub probably not working on weekend or working with a delay as Forex market is not availble on weekend, i was implemented the mock WebSocket as well.
I didn't try with the real data but hope it should work.


## Please read the DOC.md for documentaion and arch explanation