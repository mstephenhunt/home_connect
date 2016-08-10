#include <ESP8266WiFi.h>
#include "Adafruit_MQTT.h"
#include "Adafruit_MQTT_Client.h"

#define SWITCH_PIN 16

/************************* WiFi Access Point *********************************/

#define WLAN_SSID       "your_ssid"
#define WLAN_PASS       "your_password"

/************************* Adafruit.io Setup *********************************/

#define AIO_SERVER      "io.adafruit.com"
#define AIO_SERVERPORT  1883
#define AIO_USERNAME    "your_aio_username"
#define AIO_KEY         "your_aio_key"

/************ Global State (you don't need to change this!) ******************/

// Create an ESP8266 WiFiClient class to connect to the MQTT server.
WiFiClient client;

// Store the MQTT server, client ID, username, and password in flash memory.
// This is required for using the Adafruit MQTT library.
const char MQTT_SERVER[] PROGMEM    = AIO_SERVER;
// Set a unique MQTT client ID using the AIO key + the date and time the sketch
// was compiled (so this should be unique across multiple devices for a user,
// alternatively you can manually set this to a GUID or other random value).
const char MQTT_CLIENTID[] PROGMEM  = __TIME__ AIO_USERNAME;
const char MQTT_USERNAME[] PROGMEM  = AIO_USERNAME;
const char MQTT_PASSWORD[] PROGMEM  = AIO_KEY;

// Setup the MQTT client class by passing in the WiFi client and MQTT server and login details.
Adafruit_MQTT_Client mqtt(&client, MQTT_SERVER, AIO_SERVERPORT, MQTT_CLIENTID, MQTT_USERNAME, MQTT_PASSWORD);

/****************************** Feeds ***************************************/

// Setup a feed called 'ac' for subscribing to changes.
// Notice MQTT paths for AIO follow the form: <username>/feeds/<feedname>
const char AC_FEED[] PROGMEM = AIO_USERNAME "/feeds/ac";
Adafruit_MQTT_Subscribe AC = Adafruit_MQTT_Subscribe(&mqtt, AC_FEED, MQTT_QOS_1);

/*************************** Sketch Code ************************************/

char *currentState = "OFF";

void setup()
{
  pinMode(0, OUTPUT);
  digitalWrite(0, HIGH);

  // Initialize the pin to off
  pinMode(SWITCH_PIN, OUTPUT);
  digitalWrite(SWITCH_PIN, HIGH);
  
  Serial.begin(115200);

  Serial.println(F("Adafruit IO Example"));

  // Connect to WiFi access point.
  Serial.println(); Serial.println();
  delay(10);
  Serial.print(F("Connecting to "));
  Serial.println(WLAN_SSID);

  WiFi.begin(WLAN_SSID, WLAN_PASS);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(F("."));
  }
  Serial.println();

  Serial.println(F("WiFi connected"));
  Serial.println(F("IP address: "));
  Serial.println(WiFi.localIP());

  // listen for events on the lamp feed
  mqtt.subscribe(&AC);

  // connect to adafruit io
  connect();
}

void loop()
{

  Adafruit_MQTT_Subscribe *subscription;

  // ping adafruit io a few times to make sure we remain connected
  if(! mqtt.ping(3))
  {
    // reconnect to adafruit io
    if(! mqtt.connected())
      // listen for events on the lamp feed
      mqtt.subscribe(&AC);
      
      // connect to adafruit io
      connect();
  }

  // this is our 'wait for incoming subscription packets' busy subloop
  while (subscription = mqtt.readSubscription(1000))
  {
    // we only care about the ac events
    if (subscription == &AC) {

      // convert mqtt ascii payload to int
      char *readValue = (char *)AC.lastread;
      Serial.print(F("Received: "));
      Serial.println(readValue);
  
      // if you've updated, switch the pin
      if(strcmp(currentState, readValue) != 0)
      {
        Serial.println("Switching state");
        // handle switching and update currentState
        if(strcmp(readValue, "ON")==0)
        {
          Serial.println("Should be on!");
          currentState = "ON";
          digitalWrite(SWITCH_PIN, LOW);
          digitalWrite(0, LOW);
          continue;
        }
        else // if all else fails, just assume you're turning off
        {
          Serial.println("Should be off!");
          currentState = "OFF";
          digitalWrite(SWITCH_PIN, HIGH);
          digitalWrite(0, HIGH);
          continue;
        }
      }
    }   
	
    delay(1); // delay in between reads for stability
  }

}

// connect to adafruit io via MQTT
void connect()
{
  Serial.print(F("Connecting to Adafruit IO... "));

  int8_t ret;

  while ((ret = mqtt.connect()) != 0)
  {

    switch (ret)
	{
      case 1: Serial.println(F("Wrong protocol")); break;
      case 2: Serial.println(F("ID rejected")); break;
      case 3: Serial.println(F("Server unavail")); break;
      case 4: Serial.println(F("Bad user/pass")); break;
      case 5: Serial.println(F("Not authed")); break;
      case 6: Serial.println(F("Failed to subscribe")); break;
      default: Serial.println(F("Connection failed")); break;
    }

    if(ret >= 0)
      mqtt.disconnect();

    Serial.println(F("Retrying connection..."));
    delay(5000);

  }

  Serial.println(F("Adafruit IO Connected!"));

}