CREATE DATABASE CrimeManagement;
USE CrimeManagement;

Create tables:
CREATE TABLE Crime (
    CrimeID INT PRIMARY KEY,
    IncidentType VARCHAR(255),
    IncidentDate DATE,
    Location VARCHAR(255),
    Description TEXT,
    Status VARCHAR(20)
);

CREATE TABLE Victim (
    VictimID INT PRIMARY KEY,
    CrimeID INT,
    Name VARCHAR(255),
    ContactInfo VARCHAR(255),
    Injuries VARCHAR(255),
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

CREATE TABLE Suspect (
    SuspectID INT PRIMARY KEY,
    CrimeID INT,
    Name VARCHAR(255),
    Description TEXT,
    CriminalHistory TEXT,
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

Insert sample data:
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status)
VALUES 
    (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'), 
    (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'), 
    (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed');

INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries)
VALUES 
    (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'), 
    (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'), 
    (3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None');

INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory)
VALUES 
    (1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'), 
    (2, 2, 'Unknown', 'Investigation ongoing', NULL), 
    (3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');

 Queries:
  1. Select all open incidents
SELECT * FROM Crime WHERE Status = 'Open';

  2. Find the total number of incidents
SELECT COUNT(*) AS TotalIncidents FROM Crime;

  3. List all unique incident types
SELECT DISTINCT IncidentType FROM Crime;

  4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'
SELECT * FROM Crime WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

  5. List persons involved in incidents in descending order of age (assuming a Persons table exists with Age)
SELECT Name, Age FROM Persons ORDER BY Age DESC;

  6. Find the average age of persons involved in incidents
SELECT AVG(Age) AS AverageAge FROM Persons;

  7. List incident types and their counts, only for open cases
SELECT IncidentType, COUNT(*) AS Count FROM Crime WHERE Status = 'Open' GROUP BY IncidentType;

  8. Find persons with names containing 'Doe'
SELECT * FROM Persons WHERE Name LIKE '%Doe%';

  9. Retrieve names of persons involved in open and closed cases
SELECT DISTINCT Victim.Name FROM Victim JOIN Crime ON Victim.CrimeID = Crime.CrimeID WHERE Crime.Status IN ('Open', 'Closed')
UNION
SELECT DISTINCT Suspect.Name FROM Suspect JOIN Crime ON Suspect.CrimeID = Crime.CrimeID WHERE Crime.Status IN ('Open', 'Closed');

  10. List incident types where persons aged 30 or 35 were involved
SELECT DISTINCT Crime.IncidentType FROM Crime JOIN Victim ON Crime.CrimeID = Victim.CrimeID JOIN Persons ON Victim.Name = Persons.Name WHERE Persons.Age IN (30, 35);

  11. Find persons involved in incidents of the same type as 'Robbery'
SELECT DISTINCT Name FROM Persons WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE IncidentType = 'Robbery');

  12. List incident types with more than one open case
SELECT IncidentType FROM Crime WHERE Status = 'Open' GROUP BY IncidentType HAVING COUNT(*) > 1;

  13. List all incidents where suspects are also victims
SELECT DISTINCT c.* FROM Crime c
JOIN Suspect s ON c.CrimeID = s.CrimeID
JOIN Victim v ON s.Name = v.Name;

  14. Retrieve all incidents along with victim and suspect details
SELECT c.*, v.Name AS VictimName, v.ContactInfo, s.Name AS SuspectName, s.Description FROM Crime c
LEFT JOIN Victim v ON c.CrimeID = v.CrimeID
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

  15. Find incidents where the suspect is older than any victim
SELECT c.* FROM Crime c
JOIN Suspect s ON c.CrimeID = s.CrimeID
JOIN Victim v ON c.CrimeID = v.CrimeID
JOIN Persons sp ON s.Name = sp.Name
JOIN Persons vp ON v.Name = vp.Name
WHERE sp.Age > vp.Age;

  16. Find suspects involved in multiple incidents
SELECT Name, COUNT(*) AS IncidentCount FROM Suspect GROUP BY Name HAVING COUNT(*) > 1;

  17. List incidents with no suspects involved
SELECT * FROM Crime WHERE CrimeID NOT IN (SELECT DISTINCT CrimeID FROM Suspect);

  18. List all cases where at least one incident is 'Homicide' and all others are 'Robbery'
SELECT * FROM Crime WHERE IncidentType = 'Homicide' OR CrimeID IN (SELECT CrimeID FROM Crime WHERE IncidentType = 'Robbery');

  19. Retrieve a list of all incidents and associated suspects, showing 'No Suspect' where applicable
SELECT c.*, COALESCE(s.Name, 'No Suspect') AS SuspectName FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

  20. List all suspects involved in incidents with types 'Robbery' or 'Assault'
SELECT DISTINCT s.Name FROM Suspect s
JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE c.IncidentType IN ('Robbery', 'Assault');
