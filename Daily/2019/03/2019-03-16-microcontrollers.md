---
title: "Microcontrollers"
date: 2019-03-16
source_file: "PERSONAL\SCHOOL\Gregorius\Informatica\Microcontrollers.docx"
source_type: docx
tags: [personal]
area: Areas
status: active
confidence: 0.8
imported: 2026-05-14
---

1 Microcontrollers
1.1 Een microcontroller, wat is dat?
Een microcontroller is één enkele elektronische chip die complexe taken kan uitvoeren aan de hand van een programma dat in de chip is opgeslagen. Op de microcontroller-chip zijn meerdere onderdelen samengebracht, zoals een microprocessor, een RAM-geheugen, een A/D converter, een klok en een programma-geheugen. Eigenlijk is de microcontroller een heel klein computertje op één enkele chip.
Met zijn metalen contactpinnen staat de microcontroller in contact met de buitenwereld. Een aantal van die contactpinnen zijn ingangen, waarop je sensoren kunt aansluiten zoals een lichtsensor, temperatuursensor, druksensor, bewegingssensor, een draaiknop, een schakelaartje, een IRsensor, GPS-ontvanger enzovoort. Met sensoren kan de microcontroller de buitenwereld waarnemen.
In het programma staat beschreven wat de microcontroller moet doen. Zo kan de microcontroller via de uitgangscontacten allerlei dingen besturen. Op de uitgangen kun je dingen aansluiten als LED's, lampen, een pomp, een display, een verwarmingsapparaat, een luidsprekertje, een motor, een IR-led, een robot-arm, een relais enzovoort. Dit noem je actuatoren.
1.2 De wasmachine
Een mooi voorbeeld van een toepassing van een microcontroller is de wasmachine. Op de ingangen van deze microcontroller staan de bedieningsknoppen, zodat de microcontroller weet wat je met de wasmachine wilt doen. Op de ingangen staan ook de sensoren, zoals een druksensor die de microcontroller laat weten hoe hoog het water in de trommel staat, een bewegingssensor zodat de microcontroller het centrifugeren kan stoppen als de wasmachine te hard trilt, een temperatuursensor waarmee de microcontroller meet of hij het verwarmingselement moet aan- of uitzetten en een lichtsensor waarmee de microcontroller 'kijkt' hoe vuil het water is. Op de uitgangen staan de elektrische kraan waarmee de microcontroller water in de trommel kan laten lopen, het verwarmingselement om het water te verwarmen, de motor waarmee de trommel kan draaien, de pomp waarmee vuil water wordt weggepompt, een display en een elektrisch slot wat ervoor zorgt dat je de wasmachine niet kan openen tijdens het wassen.
Het programma in de microcontroller laat alles mooi samenwerken zodat je wasgoed schoon wordt. In het programma is ook een klok geprogrammeerd. Via het display laat de microcontroller zien hoe lang het wassen nog duurt, welke temperatuur je hebt ingesteld enzovoort.

1.5 De Integrated Development Environment (IDE)
Een programma zoals dat in een microcontroller zit bestaat uit binaire code. Dat zijn alleen maar enen en nullen. Een mens kan geen programma schrijven in binaire code. Om die binaire code te maken heb je een speciaal computerprogramma nodig, een software-ontwikkelomgeving of IDE. Met deze software kun je een programma voor een microcontroller schrijven in een programmeertaal die voor een mens (de programmeur) te begrijpen is. De IDE heeft een editor om het programma te schrijven, een debugger om fouten in het programma op te zoeken en een compiler die het door jou geschreven programma vertaalt in de binaire code die in de microcontroller moet worden geladen. Naast de IDE software heb je ook hardware nodig waarmee je de code vanuit de IDE in het geheugen van de microcontroller kunt laden.
1.6 Arduino
Arduino maakt sinds 2005 een IDE en de benodigde hardware om microcontrollers te programmeren en om er prototypes mee te bouwen. Het uitgangspunt van de Arduino ontwerpers was dat iedereen het moest kunnen gebruiken. Kunstenaars, knutselaars, ingenieurs, studenten, scholieren en hobbyisten. De Arduino hardware is open-source en het Arduino IDE programma is gratis. Je kunt het programma downloaden van http://www.arduino.cc .





Een eenvoudig programma in de Arduino IDE
De Arduino UNO hardware bestaat uit een board waarop de microcontroller in een voetje geprikt zit. De in- en uitgangen van de microcontroller zijn met heel kleine stekkertjes bereikbaar, zodat je gemakkelijk zonder te solderen een prototype kan bouwen en uitproberen. Verder zit er elektronica op het board om het programma van de IDE naar de ATmega328 chip te kunnen sturen. Het Arduino board sluit je aan op een USB poort van je computer.

Het Arduino UNO board
Als de microcontroller geprogrammeerd is kun je de USB kabel er uit halen en kan de Arduino zelfstandig zonder computer het programma uitvoeren. Je hebt dan natuurlijk wel een voeding van 9 volt nodig, of een USB voeding van 5 volt. Je kunt zelfs de ATmega328 chip voorzichtig uit het voetje halen en los van het Arduino board gebruiken. Hoe dat moet wordt beschreven in hoofdstuk 7.2.

2 Programmeren
2.1 De Arduino sketch
Een programmeertaal moet je leren, net als duits of engels. Als je je niet goed aan de regels houdt begrijpt de IDE-editor niet wat je bedoelt en werkt het programma verkeerd of helemaal niet. Ook als je een hoofdletter of een komma vergeet kan dat grote gevolgen hebben. Alleen de spaties in de editor zijn niet zo belanglijk.
De Arduino IDE heeft een uitgebreide help functie. Via Help/Reference kun je alle belangrijke onderdelen van de programmeertaal (de syntax) vinden. De Arduino programmeertaal is redelijk simpel. Een programma wat geschreven is in de Arduino programmeertaal noem je een sketch. Via de IDE Bestand/Voorbeelden kun je veel voorbeelden van sketches vinden. Op het internet zijn ook heel veel voorbeelden te vinden.
2.2 De setup- en loop-functies
Een sketch moet altijd een setup- en een loop-functie hebben. In de setup functie van de sketch worden de instellingen van pinnen en dergelijke gemaakt. De setup wordt maar één keer doorlopen, direct nadat je de microcontroller hebt aangezet. De loop wordt steeds herhaald, zolang de microcontroller aan staat. Een minimale sketch ziet er dus zo uit:
Deze sketch doet niks want er staan nog geen opdrachten in. Tussen de accoladen, { en } worden de programmaregels met opdrachten geschreven. Voor elke { staat verderop in de sketch een }. Een sketch bevat dus altijd evenveel { als }. De sluit-accolade staat recht onder de eerste letter van de functie. Dit is niet noodzakelijk, maar je kunt dan goed zien waar de accolade bij hoort als je de opdrachten laat inspringen.
2.3 Meer functies
Meerdere opdrachten die bij elkaar horen en samen één functie hebben kun je tussen accoladen zetten en een naam geven. Je kan zelf zoveel functies programmeren als je wilt. Dit is erg handig als je in het programma regelmatig dezelfde reeks dingen moet doen, zoals sensoren uitlezen, berekeningen maken of iets naar een display schrijven.
Met de opdracht berekenX(); laat je het programma naar de functie void berekenX(){...} springen en worden de opdrachten tussen de accoladen van die functie één keer uitgevoerd. Daarna gaat het programma verder waar het gebleven was.
2.4 // Commentaarregel
Een // (dubbele slash) en alles wat er achter staat op die regel wordt genegeerd door de compiler. Hiermee kun je je sketch voorzien van commentaar. Kijk maar naar het voorbeeld op bladzijde 9. Dit is erg handig voor jezelf, maar ook voor andere programmeurs die jouw sketch willen gebruiken. En voor deze cursus! Gebruik altijd commentaarregels in je sketch!!!
2.5 /* Commentaarblok */
Als je meerdere regels commentaar hebt kun je iedere regel beginnen met een dubbele slash, maar je kunt ook de eerste regel beginnen met /* , en de laatste regel eindigen met */. Je kunt ook delen van een programma tijdelijk uitzetten door er een commentaarregel of commentaarblok van te maken. Zo kun je binnen één sketch verschillende dingen uitproberen.
2.6 pinMode
De 14 digitale pinnen van de Arduino kunnen ingang of uitgang zijn. Voordat je de pinnen kan gebruiken moet je eerst aangeven of de betreffende pinnen ingangen of uitgangen moeten zijn. Dit doe je met de pinMode opdracht.

De pinMode opdrachten worden meestal in de setup-functie gezet:



Je kunt een pin zelf elke naam geven. Als je een pin 'LED' noemt, of 'groeneLED' of 'plustoets' of 'deurslot', dan kun je in de sketch meteen zien wat de ingang of uitgang doet. Als je een pin een naam geeft moet je die naam altijd definiëren aan het begin van de sketch. Omdat de pinnen altijd een geheel getal zijn definieer je ze als integer. Een integer (int) is een geheel getal.
De getallen A, LED, groeneLED, plustoets en deurslot in de voorbeelden noem je variabelen.
2.7 Variabelen
Een variabele is een waarde die in een geheugenplaats wordt opgeslagen. Je kunt een variabele zelf een naam geven. De naam mag geen spaties of leestekens bevatten en mag ook niet beginnen met een cijfer. Er zijn verschillende soorten variabelen. De soorten variabelen die je het meest gebruikt zijn: int, long en float.
Je kunt een variabele elke waarde geven die je wilt, zolang het maar binnen het bereik van die soort variabele is. In het programma kun je variabelen veranderen met sensoren of met berekeningen.
2.8 digitalWrite
Met de opdracht digitalWrite kun je een digitale uitgang hoog of laag maken en dus iets aan of uit zetten:
Let op de hoofdletters en kleine letters. DigitalWrite, digitalwrite of Digitalwrite werkt niet! Elke opdracht moet altijd worden afgesloten met een puntkomma. Dan weet de compiler dat er een nieuwe opdracht begint.
2.9 delay
Delay betekent wacht. Achter de opdracht delay staat tussen haakjes hoe lang het programma moet wachten in milliseconden. Één milliseconde is een duizendste van een seconde.
Let op! Als x in de opdracht delay(x); een variabele van het type int is, dan kan de delay ten hoogste ongeveer 32 seconden zijn. Als de delay langer moet worden moet je x als een long of een unsigned long definiëren.


3.2 Schakelingen bouwen op een breadboard
Een breadboard is een kunststof plaatje met rijen gaatjes. Onder de gaatjes zitten geleidende metalen strips in de vorm van veerklemmen, die contact maken met de pootjes van de elektronische componenten of snoertjes die je er in prikt. Met een breadboard kun je prototypes van elektronische schakelingen bouwen zonder te solderen.
Bij de kolommen 1 t/m 64 zijn de gaten ABCDE en de gaten FGHIJ via geleidende klemmen met elkaar verbonden. De gaatjes van de rode (+) en de blauwe (-) rijen zijn over de gehele breedte met elkaar verbonden.

Als je een tekening kan lezen en maken, dan kan je de schakeling maken op het breadboard.
Een LED heeft een plus-kant (ook wel anode genoemd) en een min-kant (ook wel kathode). Als je een LED verkeerdom aansluit werkt hij niet. De lange poot is de plus, de korte poot is de min. We willen een rode LED aansluiten op pin 13 van de Arduino. De lange poot van de LED wordt aangesloten op digitale uitgang 13 van de Arduino.
De korte poot wordt aangesloten op een poot van een weerstand van 220Ω. De andere poot van de weerstand wordt aangesloten op GND. GND betekent Ground en is 0 Volt. Het maakt niet uit of de LED vóór of na de weerstand zit. De weerstand is nodig om ervoor te zorgen dat er niet te veel stroom door de LED gaat. Als er teveel stroom door de LED gaat kan hij doorbranden of (erger nog) de microcontroller gaat kapot!

3.7 De potmeter
Een potentiometer (of potmeter) is een weerstand met een aftakking. Door aan de as te draaien kun je de aftakking verplaatsen. De potmeter is dus een spanningsdeler waarvan je de weerstandverhouding kunt instellen.
Als je een potmeter met de buitenste twee poten op 0 V en 5 V aansluit, dan kun je op de aftakking elke gewenste spanning tussen 0 V en 5 V krijgen door aan de as te draaien. De aftakking vindt je op de middelste poot. Deze poot noem je de loper.

4 Sensoren
4.1 Analoge sensoren
Analoge sensoren zijn vaak variabele weerstanden. De weerstand verandert door een natuurkundige grootheid zoals de temperatuur, druk of de hoeveelheid licht. Als je met zo’n sensor en een gewone weerstand een spanningsdeler maakt kun je de spanning laten veranderen door een veranderende grootheid. Een LDR is een voorbeeld van zo’n sensor. LDR betekent Light Dependent Resistor (licht afhankelijke weerstand). Als je een LDR in het licht houdt is de weerstand laag. Hoe feller het licht, des te lager de weerstand. Als je de LDR in het donker houdt is de weerstand juist heel hoog. Dus als je een spanningsdeler maakt met een LDR en een 'vaste' weerstand, dan is de spanning tussen beiden afhankelijk van de lichtintensiteit.

4.2 De ingangen van de microcontroller
De ATmega328 microcontroller heeft 6 analoge ingangen en maximaal 14 digitale ingangen. Via deze ingangen kan de chip de buitenwereld waarnemen. Dit doet hij door middel van elektrische spanningen. Sensoren en schakelaars geven informatie aan de microcontroller in de vorm van een elektrische spanning.
Een digitale ingang kan een spanning van 5 volt of 0 volt onderscheiden. 0 volt op een digitale ingang noemen we LOW, 5 volt noemen we HIGH. Op een digitale ingang kun je een digitale sensor aansluiten of een schakelaar die de ingang op de juiste manier met 0 volt of 5 volt verbindt. Een digitale waarde op een ingang kun je uitlezen met de opdracht digitalRead.
De analoge ingangen van de microcontroller kunnen ook alle tussenliggende spanningen tussen 0 en 5 volt ‘meten’. Het bereik van 0 - 5 volt wordt door de A/D converter (Analoog naar digitaal omzetter) van de ATmega328 chip verdeeld in 1023 gelijke stapjes, van 0 t/m 1023. Zet je een spanning van 5 volt op de analoge ingang, dan is de analoge waarde 1023. Bij 0 volt is de analoge waarde 0. Bij 1 volt is de waarde dus 1/5 x 1023 = 205. De analoge waarde kun je uitlezen met de opdracht analogRead.
4.3 Een schakelaar als input
Een schakelaar kun je beschouwen als een digitale sensor. Hij heeft twee waarden: gesloten of open (ingedrukt of niet ingedrukt). Als je de schakelaar indrukt is de weerstand 0Ω, als je hem niet indrukt is de weerstand oneindig. Verbindt je een digitale ingang via een schakelaar met 5V, dan kun je een digitaal ‘HIGH’ signaal krijgen door de schakelaar in te drukken. Maar wat nu als je de schakelaar niet indrukt? Om er voor te zorgen dat de spanning dan 0V (LOW) wordt moet je de digitale ingang ook nog via een weerstand verbinden met de 0V (GND). Hiervoor kun je een weerstand van 10.000 Ω nemen. 10.000 Ω = 10 kΩ (kilo-ohm) of kortweg 10k. Bestudeer de schakeling. Eigenlijk is dit ook een spanningsdeler. De schakelaar in de spanningsdeler heeft een weerstand van 0 Ω of oneindig Ω. Dan is de spanning op digitale ingang 7 dus 0 V (niet ingedrukt) of 5 V (wel ingedrukt).
4.5 Seriële communicatie
Als je met sensoren werkt is het handig als je tijdens het programmeren van je prototype kunt zien welke waarden de microcontroller aan de analoge ingangen ‘ziet’. Zolang de ATmega328 chip op het Arduino-board zit kun je via het programma ook gegevens naar de computer terug sturen. De belangrijkste opdrachten hiervoor zijn:
Je kunt de seriële communicatie op de computer zien via het menu Extra/Seriële monitor. Je opent dan een nieuw venster waarin de verstuurde gegevens worden ‘geprint’. De Seriële data worden ontvangen en verzonden via digitale pinnen 0 en 1. Deze pinnen kun je dus niet voor andere dingen gebruiken tijdens de seriële communicatie!



