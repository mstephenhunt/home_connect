__Configuring Enviornment:__
1) Create config/application.yml  
  touch ./config/application.yml  
2) Paste in this, put in AdafruitIO key:  
  # config/application.yml  
    
    `   defaults: &defaults  
          ADAFRUIT_API_KEY: YOUR_AF_IO_KEY
          SHOW_SIGNUP: true/false (this shows or hides the signup button)
          
        development:  
          <<: *defaults  
        
        test:  
          <<: *defaults  
    `
3) Upload code found in Arduino folder (setting same adafruit.io, network creds, etc)