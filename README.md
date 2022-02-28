# Alarm App With Analog Clock

- This project use `Flutter 2.8.1` and `Dart 2.15.1`
- Running this command `flutter pub get` in terminal to download depedencies.
- This project use `Riverpod` as state management.
------
## Project Folder Structure
### [lib/clock](lib/clock)
This folder used to save code for rendering and handle analog clock in this app.
- [lib/clock/clock_circle.dart](lib/clock/clock_circle.dart)
In this file clock circle rendered. This clock circle rendered as `CustomPainter` not `Widget`.
- [lib/clock/clock_hand.dart](lib/clock/clock_hand.dart)
In this file clock hand (minute hand and arrow hand) rendered and controllered. This clock hand can be controlled with gesture. Logic used to connect gesture with clock hand is to create tranparent area that support gesture. Next this area divided by 4 (top left, top right, bottom left, bottom right). Based on that area `Trigonometri` is used to determine what clock hand should face.
-  [lib/clock/clock_controller.dart](lib/clock/clock_controller.dart)
In this file clock state management wil be handled, Including get clock and minute in this analog clock, what should we do wen user done with dragging clock hand.
-  [lib/clock/clock.dart](lib/clock/clock.dart)
In this file clock circle, clock hand, and clock controlled merged to be analog clock. So we just need call widget `Clock()` and analog clock will be rendered.
---
### [lib/alarm](lib/alarm)
This folder used to save code for handle alarm service in this app.
- [lib/alarm/alarm_page.dart](lib/alarm/alarm_page.dart)
In this file, alarm rendered in screen and set what we do when user done moving clock hand.
- [lib/alarm/detail_page.dart](lib/alarm/detail_page.dart)
In this file, bar chart rendered that show some information.
- [lib/alarm/notification_service.dart](lib/alarm/notification_service.dart)
In this file, notification initialization, logic, and action be handled.

## Some Infromation Might Help
- How am I determine time alarm is set and time when alarm is ringing until user click?.
When user set alarm, i count how much second until alarm is ringing. With this way I already find the solution for problem one. For problem two, I use this logic. When user set alarm I count when alarm should ringing, and set this as payload in notification. When user tap on notification i use this to count time when alarm is ringing until user click 
`time alarm ringing before user click` = `time user click alaram` - `time alarm should ring (already send as payload)`
This might not the best way, but currently I only know this way.
- How I handle clock rotation with gesture?
Like I said before, I divide this clock to 4 part. Each part have 90 degree. First i use `atan` to determine degree. Next i use this:
 - If user tap in top right area, then I dont need add extra count.
 - If user tapi in bottom right area, then I add extra 90.
 - If user tapi in bottom left area, then I add extra 180.
 - If user tapi in top left area, then I add extra 270.