class HelpInformation {
  static const String info = '''

Making Reservations and Notifications

When a user makes a reservation within our system, our dedicated service, RabbitMq, ensures a seamless process that includes notifying the assigned Owner. Here's how it works:

1. User Registration: Upon registering a new user, they are linked to a specific salon.

2. Employee Assignment: Salons require employees to provide services. These employees are added through the 'Employee' page.

3. Timeslot Allocation: Once an employee is added, you can assign a timeslot to that employee. Alternatively, you can select an available timeslot.

4. Reservation Booking: After configuring a timeslot, users can make reservations. This can be done through the mobile application or from the business's side.(Also in reservations page the report can be generated)

5. Owner Notification: Crucially, when a reservation is successfully created, our RabbitMq service automatically sends a notification email to the owners email. This email informs them about the reservation, specifying the date and time.

 ''';
}
