USE [easyAppointmnetDB]

SET IDENTITY_INSERT [dbo].[City] ON 

INSERT INTO City (CityId, CityName, Country) 
VALUES 
(1, 'New York', 'USA'), 
(2, 'London', 'UK');

SET IDENTITY_INSERT [dbo].[City] OFF --Turn off IDENTITY_INSERT for City

SET IDENTITY_INSERT [dbo].[Sex] ON 

INSERT INTO Sex (SexId, SexName) 
VALUES 
(1, 'Male'), 
(2, 'Female');

SET IDENTITY_INSERT [dbo].[Sex] OFF --Turn off IDENTITY_INSERT for Sex

SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT INTO Roles (RoleId, RoleName, Description) 
VALUES 
(1, 'Admin', 'Administrator'), 
(2, 'User', 'User');

SET IDENTITY_INSERT [dbo].[Roles] OFF --Turn off IDENTITY_INSERT for Roles

SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT INTO Users (UserId, FirstName, LastName, Email, Phone, Status, SexId, Username, PasswordHash, PasswordSalt) 
VALUES 
(1, 'John', 'Doe', 'john.doe@example.com', '1234567890', 'Active', 1, 'john', HASHBYTES('SHA2_256', 'password'), HASHBYTES('SHA2_256', 'salt')), 
(2, 'Jane', 'Doe', 'jane.doe@example.com', '0987654321', 'Active', 2, 'jane', HASHBYTES('SHA2_256', 'password'), HASHBYTES('SHA2_256', 'salt'));

SET IDENTITY_INSERT [dbo].[Users] OFF --Turn off IDENTITY_INSERT for Users

SET IDENTITY_INSERT [dbo].[UserRoles] ON 

INSERT INTO UserRoles (UserRoleId, UserId, RoleId, ModificationDate) 
VALUES 
(1, 1, 1, GETDATE()), 
(2, 2, 2, GETDATE());

SET IDENTITY_INSERT [dbo].[UserRoles] OFF --Turn off IDENTITY_INSERT for UserRoles

SET IDENTITY_INSERT [dbo].[Salon] ON 

INSERT INTO Salon (SalonId, SalonName, Address, OwnerUserId, CityId) 
VALUES 
(1, 'Awesome Salon', '123 Main St, New York, NY', 1, 1), 
(2, 'Beautiful Salon', '456 High St, London', 2, 2);

SET IDENTITY_INSERT [dbo].[Salon] OFF --Turn off IDENTITY_INSERT for Salon

SET IDENTITY_INSERT [dbo].[SalonEmployees] ON 

INSERT INTO SalonEmployees (SalonEmployeeId, SalonId, EmployeeUserId)
VALUES
(1, 1, 1),
(2, 2, 2);

SET IDENTITY_INSERT [dbo].[SalonEmployees] OFF --Turn off IDENTITY_INSERT for SalonEmployees

SET IDENTITY_INSERT [dbo].[Services] ON 

INSERT INTO Services (ServiceId, ServiceName, Description, Price, SalonId)
VALUES
(1, 'Haircut', 'A nice haircut',  20.0, 1),
(2, 'Manicure', 'Beautiful manicure',  30.0, 2);

SET IDENTITY_INSERT [dbo].[Services] OFF --Turn off IDENTITY_INSERT for Services


INSERT INTO TimeSlots (StartTime, EndTime, ServiceId, EmployeeId, SlotDate, Duration) 
VALUES 
('2023-07-01 09:00:00', '2023-07-01 10:00:00', 1, 1, '2023-07-01', 60), 
('2023-07-01 10:00:00', '2023-07-01 11:00:00', 2, 2, '2023-07-01', 60);

