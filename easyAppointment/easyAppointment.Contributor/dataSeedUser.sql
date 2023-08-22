USE [eaUserMenagment]

SET IDENTITY_INSERT [dbo].[Sex] ON;

INSERT INTO [dbo].[Sex] (SexId, SexName)
VALUES
    (1, 'Male'),
    (2, 'Female');

SET IDENTITY_INSERT [dbo].[Sex] OFF;

SET IDENTITY_INSERT [dbo].[Roles] ON;

INSERT INTO [dbo].[Roles] (RoleId, RoleName, Description)
VALUES
    (1, 'Admin', 'Administrator'),
    (2, 'BusinessOwner', 'Business Owner'),
    (3, 'Customer', 'Customer'),
    (4, 'Employee', 'Employee');

SET IDENTITY_INSERT [dbo].[Roles] OFF;

SET IDENTITY_INSERT [dbo].[Users] ON;

INSERT INTO [dbo].[Users] (UserId, FirstName, LastName, Email, Phone, Status, SexId, Username, PasswordHash, PasswordSalt)
VALUES
    (1, 'Admin', 'User', 'admin@example.com', '000000000', 'active', 1, 'admin', 'mbFWDfYRoEXDnS/PVVQrvg4NbPY=', 'LpHyBtjDewnQnox7mc+CIQ=='),
    (2, 'John', 'Owner', 'johndoe@example.com', '123456789', 'active', 1, 'JohnDoeBO', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (3, 'Alice', 'Owner', 'alicesmith@example.com', '987654321', 'active', 2, 'AliceSmithBO', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (4, 'Bob', 'Owner', 'bobjohnson@example.com', '555555555', 'active', 1, 'BobJohnsonBO', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (5, 'Customer', 'Test', 'customer@example.com', '111111111', 'active', 2, 'customer', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (6, 'Leila', 'Employee', 'leila@example.com', '999999999', 'active', 2, 'LeilaEmployee', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (7, 'James', 'Employee', 'james@example.com', '888888888', 'active', 1, 'JamesEmployee', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (8, 'Sophia', 'Employee', 'sophia@example.com', '777777777', 'active', 2, 'SophiaEmployee', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (9, 'Oliver', 'Employee', 'oliver@example.com', '666666666', 'active', 1, 'OliverEmployee', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (10, 'Emma', 'Employee', 'emma@example.com', '555555555', 'active', 2, 'EmmaEmployee', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (11, 'Noah', 'Employee', 'noah@example.com', '444444444', 'active', 1, 'NoahEmployee', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (12, 'Ava', 'Employee', 'ava@example.com', '333333333', 'active', 2, 'AvaEmployee', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (13, 'William', 'Employee', 'william@example.com', '222222222', 'active', 1, 'WilliamEmployee', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),    
    (14, 'Mia', 'Employee', 'mia@example.com', '111111111', 'active', 2, 'MiaEmployee', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (15, 'Elijah', 'Employee', 'elijah@example.com', '1010101010', 'active', 1, 'ElijahEmployee', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (16, 'Anna', 'Customer', 'anna.customer@example.com', '123412341', 'active', 2, 'AnnaC', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (17, 'Brian', 'Customer', 'brian.customer@example.com', '234523452', 'active', 1, 'BrianC', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (18, 'Clara', 'Customer', 'clara.customer@example.com', '345634563', 'active', 2, 'ClaraC', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA=='),
    (19, 'David', 'Customer', 'david.customer@example.com', '456745674', 'active', 1, 'DavidC', '4A0hSwTHqNQ+UlLcwZocUjrjh4Y=', 'KhpdbY7uYWyLbhC4Iio2AA==');

SET IDENTITY_INSERT [dbo].[Users] OFF;

SET IDENTITY_INSERT [dbo].[UserRoles] ON;

INSERT INTO [dbo].[UserRoles] (UserRoleId, UserId, RoleId, ModificationDate)
VALUES
    (1, 1, 1, GETDATE()),
    (2, 2, 2, GETDATE()),
    (3, 3, 2, GETDATE()),
    (4, 4, 2, GETDATE()),
    (5, 5, 3, GETDATE()),  -- Admin becomes a customer
    (6, 6, 2, GETDATE()),  -- Business Owner 1
    (7, 7, 2, GETDATE()),  -- Business Owner 2
    (8, 8, 2, GETDATE()),  -- Business Owner 3
    (9, 9, 4, GETDATE()),  -- Unassigned Employee
    (10, 10, 4, GETDATE()), -- Unassigned Employee
    (11, 11, 4, GETDATE()), -- Unassigned Employee
    (12, 12, 4, GETDATE()), -- Unassigned Employee
    (13, 13, 4, GETDATE()), -- Unassigned Employee
    (14, 14, 4, GETDATE()), -- Unassigned Employee
    (15, 15, 4, GETDATE()), -- Unassigned Employee
    (16, 2, 4, GETDATE()),  -- Employee of Business Owner 1
    (17, 2, 4, GETDATE()),  -- Employee of Business Owner 1
    (18, 3, 4, GETDATE()),  -- Employee of Business Owner 2
    (19, 3, 4, GETDATE()),  -- Employee of Business Owner 2
    (20, 4, 4, GETDATE()),  -- Employee of Business Owner 3
    (21, 4, 4, GETDATE()),  -- Employee of Business Owner 3
    (22, 16, 3, GETDATE()),
    (23, 17, 3, GETDATE()),
    (24, 18, 3, GETDATE()),
    (25, 19, 3, GETDATE());

SET IDENTITY_INSERT [dbo].[UserRoles] OFF;
