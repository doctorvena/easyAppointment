# EasyAppointment

This project was crafted for Software Development II. "EasyAppointment" is a comprehensive application suite featuring:

Web API - Backend system developed using ASP .Net Core 6.0.
Desktop App - Flutter Desktop.
Mobile App - Developed with Flutter.
Architecture
Microservices using RabbitMQ for efficient data handling and communication.
JWT (JSON Web Tokens) for secure authentication.

## Application Setup and Launch

1. Clone repository <br/>

2. In the folder where the project is located,make sure docker desktop is running enter the following commands (CMD / Powershell): <br/>

docker-compose up --build

3. After docker starts the containers, open in browser: http://localhost:4000/swagger/index.html
 
 4. Run the desktop flutter application (Login credentials are below)
 - flutter pub get <br/>
 - flutter run -d windows
 <br/>

 5. Run the flutter app with the following command:
- flutter pub get <br/>
- flutter run <br/>
*Important disclaimer - Make sure you have an emulator running before using the command


Paypal creds for payment:
Password: 12345678
email: sb-kdryg27127512@personal.example.com

## Login credentials:
**Desktop**<br/>

```
BussinesOwner:
Username: JohnDoeBO
Password: test
```

```
Employee:
Username: LeilaEmployee
Password: test
```

**Mobile**<br/>
```
Customer:
Username: AnnaC
Password: test
```