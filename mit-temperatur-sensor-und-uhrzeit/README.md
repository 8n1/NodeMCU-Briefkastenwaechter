# briefkastenwaechter-mit-temp-sensor-und-uhrzeit
Um einen Temperatur Sensor(DS18B20), Uhrzeit und Datum erweiterte Version des "einfachen" Briefkastenwächters: https://github.com/8n1/briefkastenwaechter

Aktiviert ein Pushingbox Szenario und übergibt dabei Datum, Uhrzeit und Temperatur. 
Diese Werte können mit den Schlüsselworten $date$ , $time$ und $temperatur$ in die Nachricht die man bekommt eingebaut werden.

Datum und Uhrzeit werden von einem beliebigen Webserver geholt,
Dei Temperatur kommmt von einem DS18B20.

.:.

Ein Beispielprojekt findet man hier:

RasPiPo(st) 2 - Der Briefkasten verschickt E-Mails - http://www.forum-raspberrypi.de/Thread-hardware-automatisierung-raspipo-st-2-der-briefkasten-verschickt-e-mails?pid=159108#pid159108

"Neueinsteiger" übernahm den Hardware Teil und die Dokumentation - Ich (joh.raspi) die Software.
