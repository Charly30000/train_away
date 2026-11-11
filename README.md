# train_away

A new Flutter project.

# Iniciar modo dev en dispositivo fisico mediante wifi

- Conecta el dispositivo por USB (solo una vez)
- Habilita ADB sobre TCP/IP
```
adb tcpip 5555
```
- Obtén la IP del dispositivo Android
```
adb shell ip route
```
- Conecta por Wi-Fi
```
adb connect 192.168.1.42:5555
```
- Selecciona el dispositivo normalmente y conectate
