# Senior-Design-APFL-App
<p align="center">
  <img src="https://github.com/Ragnarokryan/Automated-Posistioning-Firework-Launcher-App/assets/87395094/ec3bd6fa-0d9b-4be3-9c35-4aed7ad22d1b" />
</p>

Smart phone application that controls the Automated Positioning Firework Launcher.
This is an app for Senior Design II that will allow the user to remotely control and fire 
the pyrotechnic rack from a safe distance.

https://github.com/Ragnarokryan/Automated-Posistioning-Firework-Launcher-App/assets/87395094/34f92147-a9ff-4c08-bf4f-0fd97a824b58
<p align="center, left">
  The initial screen is the splash screen that presents the user with the name of the project and features a bit of what this application is about with the fireworks and a depiction of the design.
</p>
https://github.com/Ragnarokryan/Automated-Posistioning-Firework-Launcher-App/assets/87395094/034a137c-e113-4f06-8ee4-5d702380a41a
Connection is established via Bluetooth Classic which is the communication protocol of the HC-05 device used in the design. The application is configured to only progress past this screen once it aquires the device address of the Bluetooth module.

https://github.com/Ragnarokryan/Automated-Posistioning-Firework-Launcher-App/assets/87395094/f5078b5f-64fb-4e7e-93b1-d57058a4d6cb
The user are presented with the positioning screen that will show four buttons that allow for manual input of angles of 60 to 150. On the rightof the buttons, the angles the user inputs will be displayed once all are set and will be transmited to the Bluetooth module to modulate the PWM's of each mortar. Once the mortars reach their specified angle the feedback is transmitted back to the application and displayed for the user to see.

https://github.com/Ragnarokryan/Automated-Posistioning-Firework-Launcher-App/assets/87395094/f1b173e9-1d1b-4c11-99b5-56ab3d02f40b
On the following screen navigated by the bottom navigation bar is the ignition screen. This will allow the user to launch their fireworks indivually but only when all angles are set as previously mentioned at the top of the positioning screen.
