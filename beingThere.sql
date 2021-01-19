USE Master
go
DROP DATABASE IF EXISTS BeingThere
go
CREATE DATABASE BeingThere
go
USE BeingThere
go
-- DDL Making tables and indexes and checks
drop procedure if exists MakeTables;
go
create procedure MakeTables 
as
begin
    
DROP TABLE IF EXISTS tblAccount;
DROP TABLE IF EXISTS tblAttendance;
DROP TABLE IF EXISTS tblPurchaseOrder;
DROP TABLE IF EXISTS tblSupply;
DROP TABLE IF EXISTS tblPartDatabox;
DROP TABLE IF EXISTS tblMaintenance;
DROP TABLE IF EXISTS tblZoneConfigurationPart;
DROP TABLE IF EXISTS tblNextOfKin;
DROP TABLE IF EXISTS tblSupplier;
DROP TABLE IF EXISTS tblBusinessVenue;
DROP TABLE IF EXISTS tblDataboxZone;
DROP TABLE IF EXISTS tblDiscount;
DROP TABLE IF EXISTS tblDataRight;
DROP TABLE IF EXISTS tblLiveStreamRight;
DROP TABLE IF EXISTS tblView;
DROP TABLE IF EXISTS tblPayment;
DROP TABLE IF EXISTS tblPart;
DROP TABLE IF EXISTS tblSubscriptionContract;
DROP TABLE IF EXISTS tblCover;
DROP TABLE IF EXISTS tblContract;
DROP TABLE IF EXISTS tblDataboxMove;
DROP TABLE IF EXISTS tblLiveStreamControl;
DROP TABLE IF EXISTS tblAccessLevel;
DROP TABLE IF EXISTS tblSale;
DROP TABLE IF EXISTS tblDiagnose;
DROP TABLE IF EXISTS tblSubscription;
DROP TABLE IF EXISTS tblDevice;
DROP TABLE IF EXISTS tblMaintenanceSchedule;
DROP TABLE IF EXISTS tblAdministrativeExecutive;
DROP TABLE IF EXISTS tblSalesperson;
DROP TABLE IF EXISTS tblDirector;
DROP TABLE IF EXISTS tblTechnician;
DROP TABLE IF EXISTS tblData;
DROP TABLE IF EXISTS tblEmployee;
DROP TABLE IF EXISTS tblLiveStream;
DROP TABLE IF EXISTS tblDatabox;
DROP TABLE IF EXISTS tblZone;
DROP TABLE IF EXISTS tblCountry;
DROP TABLE IF EXISTS tblZoneConfiguration;
DROP TABLE IF EXISTS tblDeviceOwner;
DROP TABLE IF EXISTS tblPaymentMethod;
DROP TABLE IF EXISTS tblAddress;
DROP TABLE IF EXISTS tblSubscriptionType;
DROP TABLE IF EXISTS tblPaymentSchedule;
DROP TABLE IF EXISTS tblDepartment;
DROP TABLE IF EXISTS tblPosition;
DROP TABLE IF EXISTS tblVenueType;
DROP TABLE IF EXISTS tblSkillLevel;
DROP TABLE IF EXISTS tblEmail;
DROP TABLE IF EXISTS tblPhone;
DROP TABLE IF EXISTS tblSubscriber;
DROP TABLE IF EXISTS tblContractee;
DROP TABLE IF EXISTS tblPostcode;

CREATE TABLE tblPostcode (
PostcodeZipCode varchar(20) NOT NULL PRIMARY KEY,
Country varchar(60) NOT NULL,
City varchar(85) NOT NULL
);

CREATE TABLE tblAddress (
AddressID int IDENTITY(0000000001,1) PRIMARY KEY,
PropertyNameNo varchar(30) NOT NULL,
Street varchar(30) NOT NULL,
PostcodeZipCode varchar(20) NOT NULL FOREIGN KEY REFERENCES tblPostcode(PostcodeZipCode),
);

CREATE TABLE tblDepartment (
DepartmentName varchar(30) NOT NULL PRIMARY KEY
);

CREATE TABLE tblCountry (
CountryName varchar(60) NOT NULL PRIMARY KEY,
CountryConstraints varchar(500),
CountryLegal varchar(500) 
);

CREATE TABLE tblDeviceOwner (
OwnerID int IDENTITY(0000000001,1) PRIMARY KEY,
TermsContract varchar(30) NOT NULL,
JoinDate date NOT NULL,
TerminationDate date
);

CREATE TABLE tblEmail (
PrimaryEmail varchar(50) NOT NULL PRIMARY KEY,
SecondaryEmail varchar(50),
CONSTRAINT PrimaryEmail CHECK (PrimaryEmail Like '_%@_%._%'),
CONSTRAINT SecondaryEmail CHECK (SecondaryEmail Like '_%@_%._%')
);

CREATE TABLE tblPaymentMethod (
PaymentMethod varchar(20) NOT NULL PRIMARY KEY
);

CREATE TABLE tblPaymentSchedule (
PaymentScheduleID tinyint IDENTITY(1,1) PRIMARY KEY,
PaymentScheduleOption varchar(30) NOT NULL
);

CREATE TABLE tblPhone (
PrimaryPhone varchar(20) NOT NULL PRIMARY KEY,
SecondaryPhone varchar(20)
);

CREATE TABLE tblPosition (
PositionName varchar(30) NOT NULL PRIMARY KEY
);

CREATE TABLE tblSkillLevel (
SkillLevel varchar(20) NOT NULL PRIMARY KEY
);

CREATE TABLE tblSubscriptionType (
SubscriptionTypeID tinyint IDENTITY(1,1) PRIMARY KEY,
SubscriptionName varchar(20) NOT NULL,
FeeCharged smallmoney DEFAULT 0.00 NOT NULL
);

CREATE TABLE tblZoneConfiguration (
TypeName varchar(20) NOT NULL PRIMARY KEY,
ZoneDescription varchar(500) NOT NULL,
SetupRequirements varchar(500) NOT NULL
);

CREATE TABLE tblZone (
ZoneID int IDENTITY(0000000001,1) PRIMARY KEY,
CountryRestrictions varchar(60) FOREIGN KEY REFERENCES tblCountry(CountryName),
RegionConstraints varchar(500),
RegionDescription varchar(500) NOT NULL,
EastLatitude DECIMAL(10,7) NOT NULL,
WestLatitude DECIMAL(10,7) NOT NULL,
NorthLongitude DECIMAL(10,7) NOT NULL, 
SouthLongitude DECIMAL(10,7) NOT NULL,
ZoneType varchar(20) NOT NULL FOREIGN KEY REFERENCES tblZoneConfiguration(TypeName)
);

CREATE TABLE tblSubscriber (
CustomerID int IDENTITY(1000000001,1) PRIMARY KEY
);

CREATE TABLE tblVenueType (
VenueTypeName varchar(30) NOT NULL PRIMARY KEY
);

CREATE TABLE tblContractee (
CustomerID smallint IDENTITY(00001,1) PRIMARY KEY
);

CREATE TABLE tblDatabox (
DataboxID int IDENTITY(0000000001,1) PRIMARY KEY,
PurchaseDate date NOT NULL,
DeployedDate date,
LastMaintenanceDate date,
ZoneType varchar(20) NOT NULL FOREIGN KEY REFERENCES tblZoneConfiguration(TypeName)
);

CREATE TABLE tblLiveStream (
LiveStreamID int IDENTITY(0000000001,1) PRIMARY KEY, 
Databox int NOT NULL FOREIGN KEY REFERENCES tblDatabox(DataboxID)
);

CREATE TABLE tblData (
DataID bigint IDENTITY(0000000000000000001,1) PRIMARY KEY,
DataDate date NOT NULL,
DataTime time NOT NULL,
Latitude DECIMAL(10,7) NOT NULL,
Longitude DECIMAL(10,7) NOT NULL, 
Altitude int NOT NULL,
Temperature int NOT NULL, 
Humidity int NOT NULL,
AmbientLightStrength int NOT NULL, 
Databox int NOT NULL FOREIGN KEY REFERENCES tblDatabox(DataboxID)
);

CREATE TABLE tblEmployee (
EmployeeID smallint IDENTITY(00001,1) PRIMARY KEY,
DepartmentName varchar(30) NOT NULL FOREIGN KEY REFERENCES tblDepartment(DepartmentName),
PositionName varchar(30) NOT NULL FOREIGN KEY REFERENCES tblPosition(PositionName),
Salary money NOT NULL,
StartDate date NOT NULL,
TerminationDate date
);

CREATE TABLE tblAdministrativeExecutive (
Employee smallint NOT NULL FOREIGN KEY REFERENCES tblEmployee(EmployeeID)
);

CREATE TABLE tblSalesperson (
Employee smallint NOT NULL FOREIGN KEY REFERENCES tblEmployee(EmployeeID),
QuantitySold smallint NOT NULL DEFAULT 0
);

CREATE TABLE tblDirector (
Employee smallint NOT NULL FOREIGN KEY REFERENCES tblEmployee(EmployeeID)
);

CREATE TABLE tblTechnician (
Employee smallint NOT NULL FOREIGN KEY REFERENCES tblEmployee(EmployeeID),
SkillLevel varchar(20) NOT NULL FOREIGN KEY REFERENCES tblSkillLevel(SkillLevel)
);

CREATE TABLE tblMaintenanceSchedule (
ScheduleID int IDENTITY(0000000001,1) PRIMARY KEY,
IssueDate date NOT NULL,
Report varchar(10) NOT NULL,
ReturnDate date, 
DeviceOwner int NOT NULL FOREIGN KEY REFERENCES tblDeviceOwner(OwnerID),
Technician smallint NOT NULL FOREIGN KEY REFERENCES tblEmployee(EmployeeID),
Databox int NOT NULL FOREIGN KEY REFERENCES tblDatabox(DataboxID)
);

CREATE TABLE tblDevice (
DeviceID smallint IDENTITY(00001,1) PRIMARY KEY,
Model varchar(30) NOT NULL,
PurchaseDate date NOT NULL,
IssueDate date, 
DeviceOwner int NOT NULL FOREIGN KEY REFERENCES tblDeviceOwner(OwnerID)
);

CREATE TABLE tblDiagnose (
DiagnoseDate date NOT NULL,
FaultsReport varchar(20),
Databox int NOT NULL FOREIGN KEY REFERENCES tblDatabox(DataboxID), 
Device smallint NOT NULL FOREIGN KEY REFERENCES tblDevice(DeviceID)
);

CREATE TABLE tblSubscription (
SubscriptionID int IDENTITY(0000000001,1) PRIMARY KEY,
SubscriptionType tinyint NOT NULL FOREIGN KEY REFERENCES tblSubscriptionType(SubscriptionTypeID),
PaymentSchedule tinyint NOT NULL FOREIGN KEY REFERENCES tblPaymentSchedule(PaymentScheduleID),
SetupDate date NOT NULL,
Subscriber int NOT NULL FOREIGN KEY REFERENCES tblSubscriber(CustomerID)
);

CREATE TABLE tblDataboxMove (
MoveDate date NOT NULL,
MoveTime time NOT NULL,
Databox int NOT NULL FOREIGN KEY REFERENCES tblDatabox(DataboxID),
Subscription int NOT NULL FOREIGN KEY REFERENCES tblSubscription(SubscriptionID)
);

CREATE TABLE tblLiveStreamControl (
ControlDate date NOT NULL,
ControlTime time NOT NULL,
LiveStream int NOT NULL FOREIGN KEY REFERENCES tblLiveStream(LiveStreamID),
Subscription int NOT NULL FOREIGN KEY REFERENCES tblSubscription(SubscriptionID)
);

CREATE TABLE tblAccessLevel (
AccessGranted bit NOT NULL DEFAULT 0,
GrantingAccess int NOT NULL FOREIGN KEY REFERENCES tblSubscription(SubscriptionID),
GrantedTo int NOT NULL FOREIGN KEY REFERENCES tblSubscription(SubscriptionID)
);

CREATE TABLE tblSale (
SaleDate date NOT NULL, 
Subscription int NOT NULL FOREIGN KEY REFERENCES tblSubscription(SubscriptionID),
Salesperson smallint NOT NULL FOREIGN KEY REFERENCES tblEmployee(EmployeeID)
);

CREATE TABLE tblContract (
ContractID smallint IDENTITY(00000,1) PRIMARY KEY,
ContractDate date NOT NULL, 
Contractee smallint NOT NULL FOREIGN KEY REFERENCES tblContractee(CustomerID),
AdministrativeExecutive smallint NOT NULL FOREIGN KEY REFERENCES tblEmployee(EmployeeID)
);

CREATE TABLE tblSubscriptionContract (
AssignedDate date NOT NULL, 
ContractID smallint NOT NULL FOREIGN KEY REFERENCES tblContract(ContractID),
Subscription int NOT NULL FOREIGN KEY REFERENCES tblSubscription(SubscriptionID)
);

CREATE TABLE tblCover (
ContractID smallint NOT NULL FOREIGN KEY REFERENCES tblContract(ContractID),
ZoneID int NOT NULL FOREIGN KEY REFERENCES tblZone(ZoneID)
);

CREATE TABLE tblDataboxZone (
Databox int NOT NULL FOREIGN KEY REFERENCES tblDatabox(DataboxID),
ZoneID int NOT NULL FOREIGN KEY REFERENCES tblZone(ZoneID)
);

CREATE TABLE tblDiscount (
AmountApplied REAL CHECK (AmountApplied >= 0.00 and AmountApplied <= 3.00),    
Subscription int NOT NULL FOREIGN KEY REFERENCES tblSubscription(SubscriptionID),
Salesperson smallint NOT NULL FOREIGN KEY REFERENCES tblEmployee(EmployeeID)
);

CREATE TABLE tblDataRight (
DataID bigint NOT NULL FOREIGN KEY REFERENCES tblData(DataID),
Subscription int NOT NULL FOREIGN KEY REFERENCES tblSubscription(SubscriptionID)
);

CREATE TABLE tblLiveStreamRight (
LiveStreamID int NOT NULL FOREIGN KEY REFERENCES tblLiveStream(LiveStreamID),
Subscription int NOT NULL FOREIGN KEY REFERENCES tblSubscription(SubscriptionID)
);

CREATE TABLE tblView (
ViewDate date NOT NULL,
ViewTime time NOT NULL,
LiveStream int FOREIGN KEY REFERENCES tblLiveStream(LiveStreamID),
DataID bigint FOREIGN KEY REFERENCES tblData(DataID),
Subscriber int NOT NULL FOREIGN KEY REFERENCES tblSubscriber(CustomerID)
);

CREATE TABLE tblPayment (
PaymentID int IDENTITY(0000000001,1) PRIMARY KEY,
FeeAmount smallmoney NOT NULL,
PaymentMethod varchar(20) NOT NULL FOREIGN KEY REFERENCES tblPaymentMethod(PaymentMethod),
PaymentDate date NOT NULL,
Subscription int NOT NULL FOREIGN KEY REFERENCES tblSubscription(SubscriptionID)
);

CREATE TABLE tblPart (
PartID smallint IDENTITY(00000,1) PRIMARY KEY,
PartName varchar(30) NOT NULL,
PartDescription varchar(500),
StockLevel smallint NOT NULL 
); 

CREATE TABLE tblMaintenance (
MaintenanceRecordID int IDENTITY(0000000001,1) PRIMARY KEY,
Record varchar(20) NOT NULL, 
Technician smallint NOT NULL FOREIGN KEY REFERENCES tblEmployee(EmployeeID),
Databox int NOT NULL FOREIGN KEY REFERENCES tblDatabox(DataboxID),
Part smallint NOT NULL FOREIGN KEY REFERENCES tblPart(PartID)
);

CREATE TABLE tblZoneConfigurationPart (
ZoneType varchar(20) NOT NULL FOREIGN KEY REFERENCES tblZoneConfiguration(TypeName),
Part1 smallint NOT NULL FOREIGN KEY REFERENCES tblPart(PartID),
Part2 smallint FOREIGN KEY REFERENCES tblPart(PartID),
Part3 smallint FOREIGN KEY REFERENCES tblPart(PartID)
);

CREATE TABLE tblNextOfKin (
NextOfKinID smallint IDENTITY(00001,1) PRIMARY KEY,
FullName varchar(50) NOT NULL, 
PhoneNumber varchar(20) NOT NULL,
Relationship varchar(20) NOT NULL, 
Employee smallint FOREIGN KEY REFERENCES tblEmployee(EmployeeID),
DeviceOwner int FOREIGN KEY REFERENCES tblDeviceOwner(OwnerID)
);

CREATE TABLE tblSupplier (
SupplierID smallint IDENTITY(00001,1) PRIMARY KEY,
BusinessName varchar(30) NOT NULL,  
FullAdress int NOT NULL FOREIGN KEY REFERENCES tblAddress(AddressID),  
ContactPerson varchar(50),
Email varchar(50),
PhoneNumber varchar(20)
);

CREATE TABLE tblBusinessVenue (
VenueID smallint IDENTITY(00001,1) PRIMARY KEY,
VenueTypeName varchar(30) NOT NULL FOREIGN KEY REFERENCES tblVenueType(VenueTypeName),
FullAddress int NOT NULL FOREIGN KEY REFERENCES tblAddress(AddressID),  
PhoneNumber varchar(20)
);

CREATE TABLE tblAttendance (
VenueID smallint NOT NULL FOREIGN KEY REFERENCES tblBusinessVenue(VenueID),
Subscriber int FOREIGN KEY REFERENCES tblSubscriber(CustomerID),
Contractee smallint FOREIGN KEY REFERENCES tblContractee(CustomerID),
Employee smallint FOREIGN KEY REFERENCES tblEmployee(EmployeeID)
);

CREATE TABLE tblPurchaseOrder (
PurchaseOrderNo int IDENTITY(0000000001,1) PRIMARY KEY,
Technician smallint NOT NULL FOREIGN KEY REFERENCES tblEmployee(EmployeeID),
Supplier smallint NOT NULL FOREIGN KEY REFERENCES tblSupplier(SupplierID),
Part smallint NOT NULL FOREIGN KEY REFERENCES tblPart(PartID),
PartQuantity int NOT NULL 
);

CREATE TABLE tblSupply (
InvoiceNo varchar(20) NOT NULL PRIMARY KEY,
ReceivedDate date NOT NULL,
Supplier smallint NOT NULL FOREIGN KEY REFERENCES tblSupplier(SupplierID),
Part smallint NOT NULL FOREIGN KEY REFERENCES tblPart(PartID)
);

CREATE TABLE tblPartDatabox (
Databox int NOT NULL FOREIGN KEY REFERENCES tblDatabox(DataboxID),
Part smallint NOT NULL FOREIGN KEY REFERENCES tblPart(PartID)
);

CREATE TABLE tblAccount (
AccountID int IDENTITY(0000000001,1) PRIMARY KEY,
FirstName varchar(30) NOT NULL, 
LastName varchar(30) NOT NULL, 
FullAdress int NOT NULL FOREIGN KEY REFERENCES tblAddress(AddressID),  
Email varchar(50) NOT NULL FOREIGN KEY REFERENCES tblEmail(PrimaryEmail),
PhoneNumber varchar(20) NOT NULL FOREIGN KEY REFERENCES tblPhone(PrimaryPhone),
SecurityPassword varchar(30) NOT NULL,
Subscriber int FOREIGN KEY REFERENCES tblSubscriber(CustomerID),
Contractee smallint FOREIGN KEY REFERENCES tblContractee(CustomerID),
Employee smallint FOREIGN KEY REFERENCES tblEmployee(EmployeeID),
DeviceOwner int FOREIGN KEY REFERENCES tblDeviceOwner(OwnerID)
);
end;
go
exec MakeTables;
go

-- DML Inserting into tables
drop procedure if exists InsertTables;
go
create procedure InsertTables 
as
begin
    
INSERT INTO tblPostcode 
VALUES 
('939-0751', 'Japan', 'Nyūzen'),
('479-0871', 'Japan', 'Taketoyo'),
('J7B', 'Canada', 'Lorraine'),
('993-0031', 'Japan', 'Izumi'),
('93214 CEDEX', 'France', 'La Plaine-Saint-Denis'),
('999-4201', 'Japan', 'Takahashi'),
('01069 CEDEX 9', 'France', 'Bourg-en-Bresse'),
('987-0058', 'Japan', 'Shiogama'),
('V8C', 'Canada', 'Kitimat'),
('J3M', 'Canada', 'Marieville'),
('92144 CEDEX', 'France', 'Clamart'),
('J9P', 'Canada', 'La Ronge'),
('45004 CEDEX 1', 'France', 'Orléans'),
('35914 CEDEX 9', 'France', 'Rennes'),
('75321 CEDEX 07', 'France', 'Paris 07'),
('54039 CEDEX', 'France', 'Nancy'),
('75693 CEDEX 14', 'France', 'Paris 14'),
('28225', 'United States', 'Charlotte'),
('H9A', 'Canada', 'Nakusp'),
('75210', 'United States', 'Dallas'),
('67200', 'France', 'Strasbourg'),
('29327 CEDEX', 'France', 'Quimper'),
('50404 CEDEX', 'France', 'Granville'),
('834-0122', 'Japan', 'Setaka'),
('61105', 'United States', 'Rockford'),
('91117', 'United States', 'Pasadena'),
('29563 CEDEX 9', 'France', 'Quimper'),
('66112', 'United States', 'Kansas City'),
('95697 CEDEX', 'France', 'Goussainville'),
('90831', 'United States', 'Long Beach'),
('903-0826', 'Japan', 'Naha-shi'),
('73142', 'United States', 'Oklahoma City'),
('779-3610', 'Japan', 'Wakimachi'),
('904-0401', 'Japan', 'Nakama'),
('50009 CEDEX', 'France', 'Saint-Lô'),
('92619', 'United States', 'Irvine'),
('76105', 'United States', 'Fort Worth'),
('57509 CEDEX', 'France', 'Saint-Avold'),
('42164 CEDEX', 'France', 'Andrézieux-Bouthéon'),
('33324 CEDEX', 'France', 'Bègles'),
('1072', 'New Zealand', 'Tamaki'),
('27404', 'United States', 'Greensboro'),
('38509 CEDEX', 'France', 'Voiron'),
('343-0801', 'Japan', 'Saitama'),
('K7A', 'Canada', 'Smiths Falls'),
('13654 CEDEX', 'France', 'Salon-de-Provence'),
('65810', 'United States', 'Springfield'),
('5247', 'New Zealand', 'Porirua'),
('A1K', 'Canada', 'Torbay'),
('958-0224', 'Japan', 'Kuroda'),
('44004 CEDEX 1', 'France', 'Nantes'),
('49444', 'United States', 'Muskegon'),
('43231', 'United States', 'Columbus'),
('06239 CEDEX', 'France', 'Villefranche-sur-Mer'),
('91129 CEDEX', 'France', 'Palaiseau'),
('519-3203', 'Japan', 'Shimabara'),
('3973', 'New Zealand', 'Papatowai'),
('76404 CEDEX', 'France', 'Fécamp'),
('699-0103', 'Japan', 'Yasugichō'),
('990-0711', 'Japan', 'Yoshikawa'),
('963-8878', 'Japan', 'Kōriyama'),
('17104 CEDEX', 'France', 'Saintes'),
('H9X', 'Canada', 'L''Île-Perrot'),
('86093 CEDEX 9', 'France', 'Poitiers'),
('G8H', 'Canada', 'Roberval'),
('47211 CEDEX', 'France', 'Marmande'),
('73173', 'United States', 'Oklahoma City'),
('15266', 'United States', 'Pittsburgh'),
('59468 CEDEX', 'France', 'Lomme'),
('949-6212', 'Japan', 'Mikuni'),
('77493', 'United States', 'Katy'),
('12030 CEDEX 9', 'France', 'Rodez'),
('664-0846', 'Japan', 'Itami'),
('75265', 'United States', 'Dallas'),
('E4K', 'Canada', 'Dorchester'),
('75434 CEDEX 09', 'France', 'Paris 09'),
('T4C', 'Canada', 'Cochrane'),
('1033', 'Australia', 'Sydney'),
('98115', 'United States', 'Seattle'),
('92668', 'United States', 'Orange'),
('964-0432', 'Japan', 'Mobara'),
('861-3937', 'Japan', 'Ise'),
('B0L', 'Canada', 'Rosthern'),
('97211', 'United States', 'Portland'),
('32204', 'United States', 'Jacksonville'),
('839-1301', 'Japan', 'Sakurai'),
('06804 CEDEX', 'France', 'Cagnes-sur-Mer'),
('79072 CEDEX 9', 'France', 'Niort'),
('503-0232', 'Japan', 'Hondo'),
('92013', 'United States', 'Carlsbad'),
('94364 CEDEX', 'France', 'Bry-sur-Marne'),
('34114 CEDEX', 'France', 'Frontignan'),
('44966 CEDEX 9', 'France', 'Nantes'),
('285-0927', 'Japan', 'Shisui'),
('44310', 'United States', 'Akron'),
('80089 CEDEX 2', 'France', 'Amiens'),
('19104', 'United States', 'Philadelphia'),
('370-0418', 'Japan', 'Fukayachō');

INSERT INTO tblAddress (PostcodeZipCode, PropertyNameNo, Street)
VALUES 
('370-0418', '1', 'Homewood'),
('19104', '7936', 'Debra'),
('44966 CEDEX 9', '878', 'Fallview'),
('839-1301', '82018', 'Lighthouse Bay'),
('77493', '378', 'Stone Corner'),
('839-1301', '5261', 'Caliangt'),
('44966 CEDEX 9', '7454', 'Hermina'),
('49444', '73127', 'Memorial'),
('H9X', '179', 'Armistice'),
('77493', '4', 'Granby'),
('44966 CEDEX 9', '2', 'Everett'),
('699-0103', '4', 'Crescent Oaks'),
('49444', '8', 'Ryan'),
('28225', '12', 'Heffernan'),
('77493', '9194', 'Marcy'),
('49444', '6', 'Memorial'),
('28225', '581', 'Fieldstone'),
('699-0103', '26631', 'Mockingbird'),
('28225', '981', 'Melody'),
('77493', '8573', 'Graedel'),
('44966 CEDEX 9', '5113', 'Browning'),
('28225', '89293', 'Glacier Hill'),
('49444', '83', 'Warrior'),
('44966 CEDEX 9', '890', 'Namekagon'),
('T4C', '4', 'Eagle Crest'),
('699-0103', '9', 'Sunnyside'),
('44966 CEDEX 9', '18', 'Rockefeller'),
('28225', '8', 'Lunder'),
('T4C', '131', 'Summit'),
('H9X', '66', 'Forest Run'),
('28225', '6', 'Northridge'),
('49444', '5517', 'Jay'),
('H9X', '4', 'Randy'),
('44966 CEDEX 9', '7051', 'Crowley'),
('28225', '1', 'Bultman'),
('699-0103', '6', 'Milwaukee'),
('H9X', '0', 'Linden'),
('T4C', '42', 'Cardinal'),
('T4C', '31', 'Bultman'),
('839-1301', '7', 'Mcguire');

INSERT INTO tblDepartment 
VALUES 
('Management'),
('Sales'),
('Contracts'),
('Executive'),
('Technical');

INSERT INTO tblCountry
VALUES 
('United Kingdom of Great Britain & Northern Ireland', 'Drones must not go within 500 meters of any Airport. Government building and military installationa are not to be surveyed', 'Airspace Restrictions Act 2002. Monitoring by foriegn held organisations Act 1973.'),
('United KStates of America', 'Drones must not go within 50 miles of Washington D.C., Area 51, Nevada or any other military sites', 'Homeland Security Act. Patriot Act.'),
('New Zealand', 'Avoid airport airspace at all times', ''),
('Japan', 'Maintain a distance of 1000 meters from all airports and government operations', 'Drones Act 2015'),
('Republic of France', 'Drone must not photograph or video record any government held installations', 'Surrender Act 2002');

INSERT INTO tblDeviceOwner (TermsContract, JoinDate)
VALUES 
('DO12-49583955930209', '20120618'),
('DO09-86909375903473', '20090907'),
('DO17-42210965930209', '20170712'),
('DO16-49585769563735', '20160404'),
('DO15-11532655757800', '20150921'),
('DO11-13221345558000', '20110130'),
('DO10-65452435567991', '20100226'),
('DO18-52455577889855', '20180522'),
('DO13-00064545467647', '20131114'),
('DO18-86474565400004', '20180118');

INSERT INTO tblEmail
VALUES 
('asneesbie0@joomla.org', 'agration0@plala.or.jp'),
('lwhisby1@google.com.hk', 'rconquest1@barnesandnoble.com'),
('tblackshaw2@admin.ch', 'dpomeroy2@miitbeian.gov.cn'),
('jstorck3@so-net.ne.jp', 'awhittle3@buzzfeed.com'),
('pchinery4@wordpress.com', 'mphateplace4@vkontakte.ru'),
('cbowditch5@mediafire.com', 'dbrimelow5@springer.com'),
('rjohantges6@goo.gl', 'rboltwood6@themeforest.net'),
('pconnaughton7@stumbleupon.com', 'ghinners7@infoseek.co.jp'),
('ddomleo8@cloudflare.com', 'uhorstead8@artisteer.com'),
('ccastelyn9@ucoz.ru', 'ssiemianowicz9@pcworld.com'),
('bfreezera@studiopress.com', 'hbalshawa@slate.com'),
('fhawsb@mediafire.com', 'tpeppardb@seesaa.net'),
('dklementc@examiner.com', 'imckeveneyc@latimes.com'),
('bdekeyserd@edublogs.org', 'tbelleed@sun.com'),
('pmixtere@yellowpages.com', 'cburrye@google.ru'),
('elucksf@xinhuanet.com', 'kpointingf@elegantthemes.com'),
('mmcgurkg@senate.gov', 'cpechtg@unicef.org'),
('mmilesoph@ox.ac.uk', 'dpatchingh@unicef.org'),
('hjacobowitzi@dailymotion.com', 'caucoatei@psu.edu'),
('nlozanoj@linkedin.com', 'cpetrasekj@arizona.edu'),
('amcenhillk@slate.com', 'aojedak@sun.com'),
('bbrandhaml@qq.com', 'ctreanorl@eepurl.com'),
('agoodlifem@yellowpages.com', 'eposselwhitem@usgs.gov'),
('hgirvinn@seattletimes.com', 'kgowanlockn@marriott.com'),
('mpolsino@msu.edu', 'bgovetto@europa.eu'),
('lhouseagop@newyorker.com', 'ipittsonp@samsung.com'),
('acoldbathq@biglobe.ne.jp', 'rkahaneq@hugedomains.com'),
('ckarslaker@walmart.com', 'tokillr@cafepress.com'),
('lstowes@simplemachines.org', 'cdiacks@tiny.cc'),
('acalvardt@ebay.co.uk', 'vpimblottet@slashdot.org'),
('dyeendu@skype.com', 'eboylinu@about.me'),
('mmilesopv@aboutads.info', 'mjaniakv@dedecms.com'),
('mfranciottiw@multiply.com', 'bcheeneyw@lulu.com'),
('szuckerx@deviantart.com', 'ehendrichsx@de.vu'),
('ppeyzery@google.de', 'jmapesy@blogger.com'),
('bsedmanz@dedecms.com', 'dshinglesz@merriam-webster.com'),
('dcowoppe10@noaa.gov', 'abunce10@unicef.org'),
('njay11@rediff.com', 'ncamelia11@purevolume.com'),
('aloiseau12@vistaprint.com', 'rdrew12@amazon.de'),
('varrigucci13@sun.com', 'vstickings13@state.tx.us'),
('dqueree14@kickstarter.com', 'efaichney14@shutterfly.com'),
('mdelasalle15@wikispaces.com', 'zfeaviour15@springer.com'),
('grisson16@sun.com', 'vledgeway16@webnode.com'),
('acudby17@fastcompany.com', 'otomlin17@webnode.com'),
('myashin18@storify.com', 'aporte18@reverbnation.com'),
('mmonkeman19@cocolog-nifty.com', 'sfavey19@rakuten.co.jp'),
('snattriss1a@wikipedia.org', 'mibotson1a@studiopress.com'),
('dshatliffe1b@reuters.com', 'kvanderdaal1b@washingtonpost.com'),
('aworms1c@wiley.com', 'jyakolev1c@live.com'),
('rsewall1d@archive.org', 'tfordy1d@hatena.ne.jp'),
('shannam1e@sciencedirect.com', 'bcornillot1e@ed.gov'),
('iakehurst1f@yolasite.com', 'amacgillespie1f@slideshare.net'),
('lbonnick1g@cbslocal.com', 'abeszant1g@nhs.uk'),
('nbeert1h@eepurl.com', 'myerill1h@shop-pro.jp'),
('landreaccio1i@unblog.fr', 'lasals1i@parallels.com'),
('tprester1j@whitehouse.gov', 'bnewick1j@spiegel.de'),
('edublin1k@vk.com', 'cstoodley1k@state.tx.us'),
('cbane1l@wordpress.com', 'gpentony1l@buzzfeed.com'),
('mbenardet1m@google.it', 'rdeluce1m@bloglovin.com'),
('lleverentz1n@pcworld.com', 'mbaselio1n@google.it'),
('epilkinton1o@hexun.com', 'fworling1o@cmu.edu'),
('pbavidge1p@globo.com', 'akilgannon1p@marriott.com'),
('tochterlonie1q@google.ru', 'agarvey1q@tinypic.com'),
('sparsons1r@fastcompany.com', 'hmoogan1r@arstechnica.com'),
('hyearron1s@jugem.jp', 'swaite1s@java.com'),
('dmckeran1t@dmoz.org', 'ahinks1t@gov.uk'),
('aswepson1u@who.int', 'ptungay1u@ucoz.com'),
('shalle1v@europa.eu', 'gvolant1v@twitpic.com'),
('trush1w@who.int', 'ewood1w@ask.com'),
('rwaliszek1x@vimeo.com', 'dharrill1x@usgs.gov'),
('sgian1y@ask.com', 'wklaffs1y@hatena.ne.jp'),
('lallonby1z@w3.org', 'euren1z@samsung.com'),
('cchenery20@clickbank.net', 'etoller20@people.com.cn'),
('jmulhall21@berkeley.edu', 'obean21@ucoz.ru'),
('mertelt22@ucsd.edu', 'sbiss22@nih.gov'),
('ppeaple23@feedburner.com', 'rcookney23@dropbox.com'),
('xdavidovits24@comcast.net', 'vlakeland24@over-blog.com'),
('cfitzroy25@comsenz.com', 'dsyms25@ovh.net'),
('cbalm26@google.es', 'fleleu26@icq.com'),
('kwinspeare27@smugmug.com', 'ibaugham27@facebook.com'),
('amoakes28@cnn.com', 'aspread28@reddit.com'),
('stumilty29@jiathis.com', 'bmuncer29@topsy.com'),
('gfritter2a@example.com', 'ediaper2a@cargocollective.com'),
('sbrum2b@sbwire.com', 'fwoollam2b@free.fr'),
('dpratton2c@blinklist.com', 'mstorch2c@google.de'),
('idesseine2d@usa.gov', 'mcasson2d@hc360.com'),
('slordon2e@merriam-webster.com', 'dcharnley2e@multiply.com'),
('dacedo2f@qq.com', 'efrancesc2f@washingtonpost.com'),
('mrozet2g@ed.gov', 'imcsharry2g@deliciousdays.com'),
('agalia2h@wufoo.com', 'kstack2h@webmd.com'),
('bcauser2i@freewebs.com', 'afowles2i@ox.ac.uk'),
('gpenhale2j@instagram.com', 'fferreira2j@seesaa.net'),
('lbeales2k@jalbum.net', 'mlister2k@blog.com'),
('jogready2l@phoca.cz', 'blemarquand2l@arizona.edu'),
('hgrange2m@nba.com', 'cbing2m@taobao.com'),
('crummer2n@livejournal.com', 'pfairclough2n@sciencedaily.com'),
('askellen2o@cyberchimps.com', 'sgoodband2o@google.co.uk'),
('mcabrales2p@huffingtonpost.com', 'vmaysor2p@businessweek.com'),
('dburfitt2q@redcross.org', 'clehrer2q@g.co'),
('cdreakin2r@globo.com', 'ckearle2r@vistaprint.com'),
('mritmeier2s@privacy.gov.au', 'mcherrie2s@dyndns.org'),
('wpresland2t@scribd.com', 'cmillwater2t@devhub.com'),
('sipsgrave2u@dagondesign.com', 'jjarrett2u@vistaprint.com'),
('ngianninotti2v@microsoft.com', 'cchasier2v@reddit.com'),
('bgabbidon2w@printfriendly.com', 'scoplestone2w@theguardian.com'),
('clammertz2x@redcross.org', 'rclemmow2x@nyu.edu'),
('ehancorn2y@seesaa.net', 'jhugill2y@cmu.edu'),
('sitzkovitch2z@sphinn.com', 'bfortey2z@devhub.com'),
('eplascott30@census.gov', 'hbarford30@merriam-webster.com'),
('rpawlaczyk31@apache.org', 'tlockner31@merriam-webster.com'),
('dhupe32@com.com', 'horeilly32@army.mil'),
('rjosifovitz33@usnews.com', 'ddederich33@taobao.com'),
('tkanter34@amazon.com', 'gculshew34@example.com'),
('ebrunn35@tmall.com', 'cfaulder35@engadget.com'),
('mmcnirlan36@facebook.com', 'ccaghy36@gravatar.com'),
('sdommett37@themeforest.net', 'fglenny37@webmd.com'),
('gmerriton38@usda.gov', 'ibriggdale38@ox.ac.uk'),
('bdivisek39@feedburner.com', 'gdesremedios39@yahoo.co.jp'),
('tkwietak3a@fc2.com', 'gsaw3a@live.com'),
('iavramovic3b@opera.com', 'lryman3b@hhs.gov'),
('dczajkowska3c@redcross.org', 'mdewing3c@google.es'),
('cfarrant3d@earthlink.net', 'sabramovici3d@chicagotribune.com'),
('mfury3e@posterous.com', 'amaudling3e@fema.gov'),
('dgolder3f@biblegateway.com', 'dcadwell3f@eventbrite.com'),
('gshrimptone3g@illinois.edu', 'obroom3g@odnoklassniki.ru'),
('bleser3h@1688.com', 'rhupka3h@nationalgeographic.com'),
('mburghill3i@purevolume.com', 'gdishman3i@linkedin.com'),
('lduncanson3j@cafepress.com', 'vnorthall3j@51.la'),
('bloomis3k@dot.gov', 'mstallen3k@globo.com'),
('dgoggan3l@mayoclinic.com', 'klonghorne3l@squidoo.com'),
('blaba3m@mayoclinic.com', 'kbricksey3m@bravesites.com'),
('sgerin3n@va.gov', 'amartijn3n@histats.com'),
('kdrever3o@deviantart.com', 'fmulryan3o@ca.gov'),
('njakubski3p@seesaa.net', 'jrodder3p@senate.gov'),
('skauschke3q@kickstarter.com', 'mnewton3q@google.es'),
('rmanna3r@apple.com', 'bhardwin3r@discuz.net'),
('klesurf3s@amazon.com', 'dcrutchley3s@hexun.com'),
('aboullen3t@csmonitor.com', 'nlundberg3t@webnode.com'),
('sdiament3u@apple.com', 'dhawthorne3u@nps.gov'),
('frenvoise3v@sfgate.com', 'kdavenhall3v@disqus.com'),
('bcooke3w@com.com', 'ssallier3w@stanford.edu'),
('acorneil3x@sciencedirect.com', 'carrundale3x@addtoany.com'),
('dkarczinski3y@vk.com', 'lmcturlough3y@tuttocitta.it'),
('mpagram3z@netscape.com', 'hskipton3z@prnewswire.com'),
('sbulfoot40@mapquest.com', 'cbotton40@economist.com'),
('cwilshin41@blog.com', 'eternouth41@europa.eu'),
('stitman42@dagondesign.com', 'kspennock42@loc.gov'),
('gcrinkley43@weebly.com', 'gdobeson43@bbc.co.uk'),
('besel44@vistaprint.com', 'cgeertsen44@amazon.co.uk'),
('dgarret45@wiley.com', 'mdury45@prlog.org'),
('sorteau46@google.fr', 'cvondrasek46@yelp.com'),
('tberanek47@baidu.com', 'yroyan47@gmpg.org'),
('sgoscar48@dyndns.org', 'dantliff48@oaic.gov.au'),
('wholborn49@businesswire.com', 'mespin49@cdbaby.com'),
('fmalinson4a@goodreads.com', 'cpennoni4a@t.co'),
('rbeeson4b@paypal.com', 'leddington4b@acquirethisname.com'),
('bhilbourne4c@bizjournals.com', 'ekinsey4c@utexas.edu'),
('pdrews4d@pinterest.com', 'tdymoke4d@cocolog-nifty.com'),
('ajanas4e@rediff.com', 'cthurber4e@yahoo.com'),
('lscarf4f@ocn.ne.jp', 'bphidgin4f@prweb.com'),
('hbennedick4g@shop-pro.jp', 'dtilio4g@360.cn'),
('rgullis4h@csmonitor.com', 'aastall4h@webs.com'),
('smatton4i@alibaba.com', 'rfayerbrother4i@sbwire.com'),
('dgormley4j@fastcompany.com', 'hdoblin4j@histats.com'),
('mswindin4k@bloomberg.com', 'dgoult4k@moonfruit.com'),
('dstquentin4l@sfgate.com', 'rgoulbourne4l@biglobe.ne.jp'),
('pvauls4m@businesswire.com', 'keymer4m@washington.edu'),
('wwabe4n@studiopress.com', 'gwaeland4n@abc.net.au'),
('psouthward4o@marriott.com', 'cfawks4o@jugem.jp'),
('badamov4p@apple.com', 'jsetterthwait4p@go.com'),
('hbenet4q@amazonaws.com', 'nrosso4q@epa.gov'),
('csicely4r@tmall.com', 'ikainz4r@github.io'),
('mstanway4s@vinaora.com', 'gmallabund4s@hp.com'),
('tkoopman4t@google.it', 'abeggan4t@homestead.com'),
('dpioli4u@who.int', 'amapletoft4u@cmu.edu'),
('averlinden4v@shutterfly.com', 'jmccleary4v@yahoo.com'),
('jsackur4w@netvibes.com', 'dsiggens4w@sakura.ne.jp'),
('ldowngate4x@adobe.com', 'splayle4x@mozilla.com'),
('mblunsom4y@blinklist.com', 'dgrimshaw4y@twitpic.com'),
('ggun4z@dell.com', 'lskentelbery4z@fda.gov'),
('keskriett50@sourceforge.net', 'hmcskin50@hatena.ne.jp'),
('gstenbridge51@cocolog-nifty.com', 'eosband51@ovh.net'),
('utaylour52@si.edu', 'rbottrill52@list-manage.com'),
('dcrummie53@ameblo.jp', 'vtraylen53@go.com'),
('dmacfie54@is.gd', 'mhoppner54@hatena.ne.jp'),
('mcovelle55@bbc.co.uk', 'pberry55@comcast.net'),
('pcarslaw56@myspace.com', 'khandes56@si.edu'),
('ewestbury57@taobao.com', 'dcalafato57@msu.edu'),
('chinz58@shutterfly.com', 'mbolesma58@about.me'),
('sranscome59@barnesandnoble.com', 'fedler59@nyu.edu'),
('talvarado5a@hc360.com', 'btyrwhitt5a@omniture.com'),
('hbellelli5b@mail.ru', 'dondrousek5b@themeforest.net'),
('kree5c@twitpic.com', 'zcannon5c@tinyurl.com'),
('cdubber5d@liveinternet.ru', 'libert5d@elegantthemes.com'),
('wscoffins5e@usnews.com', 'rirce5e@twitter.com'),
('slarkings5f@phoca.cz', 'oyeskov5f@un.org'),
('atowne5g@booking.com', 'mbuzek5g@amazon.co.jp'),
('egamlen5h@wordpress.com', 'cdahlberg5h@nsw.gov.au'),
('mannon5i@icq.com', 'gdanson5i@miibeian.gov.cn'),
('mskyrme5j@miitbeian.gov.cn', 'kcooley5j@exblog.jp'),
('tesby5k@guardian.co.uk', 'astrapp5k@photobucket.com'),
('gpedri5l@soundcloud.com', 'rhuet5l@si.edu'),
('mberkely5m@hud.gov', 'afackrell5m@harvard.edu'),
('lmerrgan5n@multiply.com', 'pflucks5n@usnews.com'),
('hchaunce5o@reverbnation.com', 'hharlin5o@123-reg.co.uk'),
('atuerena5p@booking.com', 'dbeane5p@bravesites.com'),
('krizzini5q@tinypic.com', 'pfairbrace5q@dedecms.com'),
('mbinnie5r@surveymonkey.com', 'ctregiddo5r@lulu.com'),
('cwrout5s@issuu.com', 'csheather5s@dell.com'),
('dglanester5t@tinypic.com', 'mfennelow5t@nba.com'),
('sboyde5u@etsy.com', 'mmcgarvey5u@addtoany.com'),
('jandreolli5v@independent.co.uk', 'cfattorini5v@hexun.com'),
('aconyers5w@360.cn', 'mrudgerd5w@vk.com'),
('rcamous5x@usa.gov', 'ptimson5x@admin.ch'),
('chitcham5y@plala.or.jp', 'ttomasicchio5y@seesaa.net'),
('nbardill5z@dedecms.com', 'rrihanek5z@comsenz.com'),
('ckenwrick60@macromedia.com', 'ghegg60@networksolutions.com'),
('hhefforde61@sohu.com', 'vbrouwer61@uol.com.br'),
('mpawson62@reference.com', 'aredding62@bloomberg.com'),
('kplume63@bloomberg.com', 'klearoyd63@devhub.com'),
('rbeggin64@gov.uk', 'vturmel64@washington.edu'),
('cricks65@bing.com', 'kbarbary65@ebay.co.uk'),
('dtack66@cyberchimps.com', 'vespinosa66@dagondesign.com'),
('mcorson67@house.gov', 'fkosel67@geocities.com'),
('jricart68@goo.ne.jp', 'npedlar68@bing.com'),
('rblaydon69@sfgate.com', 'aalbion69@biglobe.ne.jp'),
('jfritter6a@senate.gov', 'ihulkes6a@ask.com'),
('rdallon6b@jalbum.net', 'dhoffmann6b@earthlink.net'),
('jturville6c@yolasite.com', 'asooley6c@twitter.com'),
('bsexten6d@jigsy.com', 'dprint6d@oakley.com'),
('sgoudge6e@w3.org', 'fmcilwreath6e@nsw.gov.au'),
('ppassmore6f@nytimes.com', 'lblackader6f@dion.ne.jp'),
('aminerdo6g@ft.com', 'cwilsee6g@bbc.co.uk'),
('johagerty6h@skype.com', 'rbastide6h@csmonitor.com'),
('rcapps6i@quantcast.com', 'haukland6i@linkedin.com'),
('smedeway6j@smugmug.com', 'kmuehle6j@yolasite.com'),
('ljaycocks6k@google.com.br', 'mtinto6k@ezinearticles.com'),
('tpitkaithly6l@phoca.cz', 'bstoves6l@google.nl'),
('dfiddian6m@photobucket.com', 'dmccuthais6m@webs.com'),
('chinder6n@ted.com', 'wpiotrowski6n@va.gov'),
('ucreeber6o@washingtonpost.com', 'celmhurst6o@berkeley.edu'),
('osecret6p@1und1.de', 'jgillbe6p@dmoz.org'),
('csitch6q@kickstarter.com', 'aberrow6q@newsvine.com'),
('bmerredy6r@nytimes.com', 'bsturgis6r@cbslocal.com'),
('mlynas6s@wiley.com', 'acato6s@examiner.com'),
('bbertelmot6t@soundcloud.com', 'jholdworth6t@yahoo.co.jp'),
('eloghan6u@springer.com', 'blannon6u@ucsd.edu'),
('bmouncher6v@opera.com', 'bbocke6v@histats.com'),
('afarrell6w@wix.com', 'hhanster6w@mashable.com'),
('thollerin6x@live.com', 'yfritschel6x@fema.gov');

INSERT INTO tblPaymentMethod
VALUES 
('Bank Transfer'),
('Credit/Debit'),
('Direct Debit'),
('Standing Order'),
('Cheque');

INSERT INTO tblPaymentSchedule
VALUES 
('Weekly'),
('Fortnightly'),
('Monthly'),
('Quarterly'),
('Annually');

INSERT INTO tblPhone
VALUES 
('936-192-7628', '866-603-8792'),
('730-341-7292', '767-535-2320'),
('202-115-9829', '635-356-9194'),
('763-524-9415', '637-990-2884'),
('127-300-4459', '267-582-0403'),
('135-474-0974', '909-747-9978'),
('729-482-6102', '450-917-9871'),
('577-243-8888', '901-212-1184'),
('800-797-8638', '180-860-4989'),
('674-305-3867', '406-884-1690'),
('113-686-2134', '868-215-2895'),
('246-176-6734', '380-516-6600'),
('474-609-0948', '932-118-8078'),
('364-235-8064', '489-671-2070'),
('152-782-9250', '285-496-7672'),
('382-416-4196', '622-429-1338'),
('655-236-2978', '918-798-3492'),
('112-921-5959', '239-771-4827'),
('700-160-5221', '195-802-9933'),
('706-202-7529', '917-868-3359'),
('112-464-0427', '826-340-2384'),
('138-852-9531', '328-620-4584'),
('890-187-1217', '715-826-1751'),
('267-431-4354', '151-469-5592'),
('141-971-6755', '330-415-6725'),
('909-887-1168', '786-840-7752'),
('558-971-7602', '304-828-3327'),
('207-218-4539', '964-601-0863'),
('709-261-9910', '378-178-3475'),
('234-200-6626', '958-569-7947'),
('495-842-4279', '565-162-2955'),
('205-664-8349', '947-487-1787'),
('837-390-4866', '477-840-5220'),
('282-600-3986', '568-811-3946'),
('808-959-7145', '839-700-6739'),
('688-155-7933', '888-445-6272'),
('402-941-0840', '496-836-8597'),
('565-384-3862', '139-732-6588'),
('834-949-5554', '219-224-0526'),
('757-133-6870', '107-788-9014'),
('491-487-6110', '909-586-3624'),
('195-430-7554', '636-382-9373'),
('106-405-2307', '700-676-7109'),
('584-705-1410', '214-198-8234'),
('174-604-6838', '785-885-3080'),
('982-912-5182', '689-706-5760'),
('659-374-5602', '365-623-8464'),
('335-867-1150', '568-139-4529'),
('809-346-3587', '401-528-6848'),
('225-413-2032', '796-473-9206'),
('352-235-0836', '741-546-1527'),
('239-866-5460', '878-255-6284'),
('766-533-5932', '665-560-2837'),
('233-222-4288', '344-822-3310'),
('743-712-7176', '587-683-7047'),
('632-682-9789', '701-397-5664'),
('491-672-2737', '243-712-3392'),
('907-803-3974', '739-740-8765'),
('653-909-8592', '926-274-5898'),
('675-142-7842', '237-308-3348'),
('821-287-8581', '978-473-7935'),
('353-997-6367', '431-490-4449'),
('164-620-4467', '231-789-6253'),
('639-351-7999', '550-629-7766'),
('351-311-9565', '511-271-6311'),
('467-800-2034', '168-424-4349'),
('165-362-9796', '579-375-7476'),
('390-944-6510', '464-705-4003'),
('515-942-9077', '997-283-6845'),
('147-973-6946', '287-337-6251'),
('200-915-2940', '476-231-9640'),
('722-108-9075', '465-834-4445'),
('399-847-4446', '250-373-4163'),
('336-871-3275', '222-241-4584'),
('727-238-5187', '307-414-4602'),
('131-143-5150', '559-678-6119'),
('585-984-7440', '747-836-4152'),
('484-725-0215', '308-821-2563'),
('985-526-3666', '309-629-7267'),
('374-372-2485', '430-376-8431'),
('833-641-6936', '705-574-0586'),
('123-133-2880', '544-701-3624'),
('545-810-2666', '363-323-9989'),
('161-375-6108', '576-538-2517'),
('939-874-1065', '566-490-1959'),
('554-628-4628', '187-431-5900'),
('575-261-7575', '641-700-1904'),
('748-975-6484', '458-381-1024'),
('169-856-7651', '628-142-2460'),
('497-893-6310', '111-282-6860'),
('961-478-7481', '154-611-3572'),
('788-913-9460', '737-977-3779'),
('876-285-5746', '512-283-7314'),
('408-623-4256', '178-768-7707'),
('584-416-9956', '276-320-6221'),
('130-601-0330', '550-529-5475'),
('715-767-6447', '458-496-5748'),
('933-584-7912', '766-935-5829'),
('955-126-4866', '834-612-9705'),
('439-103-9073', '671-448-0209'),
('701-688-2805', '192-563-8659'),
('732-487-8962', '813-724-6115'),
('803-796-9437', '939-163-3466'),
('914-659-3851', '546-401-9480'),
('598-381-3680', '659-549-8545'),
('106-720-0481', '835-380-8389'),
('996-553-3114', '866-146-5086'),
('320-991-2143', '658-161-6866'),
('535-500-1673', '469-574-4070'),
('199-843-2950', '940-491-0209'),
('539-665-3198', '694-429-2328'),
('324-263-8205', '746-264-7352'),
('563-574-5756', '372-529-0795'),
('317-764-6762', '486-589-5918'),
('945-712-0688', '951-247-4752'),
('947-807-0914', '607-860-1957'),
('830-740-9597', '543-983-7034'),
('112-376-7443', '503-253-4480'),
('298-634-0641', '584-404-3574'),
('149-708-9389', '253-770-7200'),
('537-282-1764', '882-138-8868'),
('502-631-3032', '501-269-3717'),
('773-828-8626', '632-527-5474'),
('982-717-8533', '366-843-5416'),
('181-535-1250', '564-109-0222'),
('172-137-9864', '290-302-4373'),
('269-571-6474', '266-364-3490'),
('843-407-3183', '982-260-1260'),
('122-949-1171', '763-991-4810'),
('121-847-0140', '105-919-4790'),
('407-628-0168', '490-183-1364'),
('857-712-7026', '930-787-9063'),
('680-950-4199', '597-532-6552'),
('316-516-7821', '681-817-7737'),
('178-609-1578', '813-899-1064'),
('214-994-4683', '386-109-5887'),
('730-153-4504', '155-145-0631'),
('123-770-8384', '970-813-6893'),
('719-786-5349', '146-649-6055'),
('641-315-1472', '754-978-2862'),
('658-567-2247', '636-670-9382'),
('325-442-1959', '746-123-7791'),
('671-666-4110', '533-578-2440'),
('933-642-2009', '210-412-5088'),
('833-553-7752', '745-899-7239'),
('303-246-4952', '203-228-6607'),
('938-245-7711', '654-424-2537'),
('398-776-4267', '972-907-7862'),
('157-652-1788', '573-378-6396'),
('659-965-2832', '970-323-7321'),
('507-112-3548', '134-420-2900'),
('617-950-4877', '923-727-4277'),
('248-462-2172', '976-126-5137'),
('230-601-3154', '465-209-2980'),
('789-444-5813', '173-119-9864'),
('178-628-5076', '180-700-7987'),
('749-824-6848', '547-472-4329'),
('331-514-2261', '727-327-3037'),
('617-183-2060', '104-684-9684'),
('465-170-2895', '533-835-9720'),
('816-610-0317', '681-937-4595'),
('610-215-5983', '214-843-1153'),
('674-131-3546', '464-174-0875'),
('974-380-4728', '396-169-1188'),
('671-344-0232', '838-309-1082'),
('785-527-5960', '268-169-0241'),
('695-286-1700', '706-737-3433'),
('758-575-8386', '586-923-8113'),
('340-804-3750', '212-239-6473'),
('662-215-4060', '274-897-8613'),
('216-988-4070', '224-495-4842'),
('969-603-7461', '596-399-5346'),
('340-173-6033', '864-747-7278'),
('948-903-7461', '619-924-3085'),
('270-543-5599', '286-525-0886'),
('873-639-8393', '980-243-0115'),
('161-142-2402', '297-733-8291'),
('758-951-0149', '758-633-2639'),
('421-520-4670', '333-812-6698'),
('647-300-9074', '234-711-5069'),
('776-554-6661', '613-218-5836'),
('356-283-1712', '326-491-0017'),
('873-136-9592', '728-206-5734'),
('777-698-7374', '690-806-8768'),
('100-493-9076', '834-975-5450'),
('343-982-1029', '336-993-7528'),
('873-900-1479', '171-603-0524'),
('964-677-5046', '957-261-2589'),
('187-613-3872', '441-481-8594'),
('822-471-8958', '520-506-3731'),
('156-637-1486', '176-553-9684'),
('951-551-9114', '367-657-4675'),
('399-940-3321', '534-834-8195'),
('829-459-5190', '941-912-5509'),
('562-571-6508', '905-495-1578'),
('158-835-1602', '608-626-9847'),
('678-797-1156', '916-231-1932'),
('687-307-4967', '211-865-8622'),
('153-148-9502', '911-282-9211'),
('510-120-3249', '807-644-3434'),
('725-859-4311', '973-471-1337'),
('794-691-5179', '342-478-5412'),
('560-195-4756', '698-269-8598'),
('422-157-2013', '617-644-2738'),
('299-181-1842', '192-791-3687'),
('907-456-9282', '512-996-1799'),
('438-447-6005', '123-950-1171'),
('425-592-2914', '183-547-8030'),
('430-683-0575', '859-380-2730'),
('258-838-2733', '610-673-4478'),
('211-442-6612', '635-282-0586'),
('248-271-6527', '603-723-4395'),
('917-517-8327', '223-215-6631'),
('921-810-1191', '719-715-0407'),
('653-375-0230', '235-299-1848'),
('550-124-6312', '298-406-8992'),
('789-770-2595', '112-386-5734'),
('136-198-6963', '194-186-7894'),
('161-259-2218', '885-697-3879'),
('290-408-2907', '645-746-7991'),
('535-233-0837', '469-401-8900'),
('429-354-5070', '619-208-7771'),
('722-223-2819', '929-978-9229'),
('903-776-6956', '893-983-8732'),
('763-579-7242', '883-647-6807'),
('814-858-6654', '566-148-6900'),
('856-601-5353', '604-153-3370'),
('555-822-5030', '790-385-5306'),
('347-686-9585', '163-752-5529'),
('113-538-1783', '383-160-6762'),
('241-176-2259', '876-830-3779'),
('818-678-6690', '938-307-4779'),
('983-698-3210', '509-346-9933'),
('957-393-4809', '283-152-8229'),
('789-968-2691', '940-867-2031'),
('382-309-8758', '685-113-4248'),
('592-596-3539', '860-893-1131'),
('345-644-2697', '704-343-3004'),
('828-641-8242', '224-210-3845'),
('404-107-1847', '155-205-2052'),
('976-941-3893', '392-683-3717'),
('923-252-3848', '702-508-2105'),
('400-229-5014', '440-456-2499'),
('376-449-3039', '823-581-6907'),
('380-757-1978', '910-766-7577'),
('185-170-6248', '976-841-8703'),
('225-610-9879', '272-479-5878'),
('146-388-2538', '425-150-3778'),
('220-937-4226', '963-100-2413'),
('989-854-7098', '913-685-3075');
INSERT INTO tblPosition
VALUES 
('Director'),
('Administrative Executive'),
('Salesperson'),
('Technician'),
('Administration');

INSERT INTO tblSkillLevel
VALUES 
('Trainee'),
('Beginner'),
('Intermediate'),
('Advanced'),
('Expert');

INSERT INTO tblSubscriptionType
VALUES 
('Standard', 250.00),
('Gold', 450.00),
('Platinum', 1000.00),
('Super Platinum', 1500.00),
('Reserved', 0.00);

INSERT INTO tblZoneConfiguration
VALUES 
('Jungle', 'Dense vegetation, high temperatures, rainfall and humidity.', 'Cooling Fan, Moisture Monitoring Unit, Waterproof Case.'),
('Forest', 'Dense trees, wide range of temperatures annually. Dry summers and cold winters', 'Cooling Fan, Heating Unit, Waterproof Case.'),
('Savannah', 'Annual fires, diverse mammal migration, intense heat.', 'Cooling Fan, Smog Detection, Increased Speed Motor.'),
('Ice/Snow', 'Severe cold temperatues and reduced visibility.', 'Heating Unit, Waterproof Case, Night-Vision Camera.'),
('Mountain', 'High alltitude and extreme cold.', 'Heating Unit, Waterproof Case, Range Extender Pack.'),
('Desert', 'Arid and hot conditions, intense sun.', 'Cooling Fan, Heat Reflective Cover, Camera Visor'),
('Urban', 'Dense human habitation and obstacles', 'Cooling Fan, Waterproof Case.');

INSERT INTO tblZone
VALUES 
('Japan', 'Protected mammals, keep drones at a distance', 'Mainly forest with some small scattered settlements. No weather extremes.', 81.440, 80.131, 28.801, 29.991, 'Forest'),
('United Kingdom of Great Britain & Northern Ireland', '', 'Densly populate with some tall buildings, coastal city.', 92.200, 90.971, 18.801, 19.391, 'Urban'),
('New Zealand', 'Includes a military installation that must be avoided.', 'Exposed terrain with frequent weather fronts.', 12.550, 11.000, 88.544, 89.750, 'Desert'),
('Republic of France', 'Caution, major truffle growing region.', 'Low population forest, much is privately owned', 81.210, 80.131, 17.801, 18.991, 'Forest'),
('Japan', 'Keep distance from nuclear power plant on edge of forest region.', 'Coastal forest at low altitude impacted ', 81.409, 80.731, 28.955, 30.773, 'Forest'),
('New Zealand', 'Minimize impact to protect native birds, stay above defined altitude.', 'Very dense jungle terrain with mountain ranges. High tourist area.', 13.550, 12.000, 87.544, 88.750, 'Jungle'),
('United Kingdom of Great Britain & Northern Ireland', 'Protected mammals, keep drones at a distance.', 'Mainly forest with some small scattered settlements. No weather extremes.', 81.200, 80.131, 28.801, 29.991, 'Desert'),
('Japan', 'Maintain a 5 mile distance from UNESCO site.', 'Strong winds from Pacfic affect east side of mountain.', 79.200, 77.131, 27.801, 28.991, 'Mountain'),
('United KStates of America', 'Maintain a 10 mile distance from air force base.', 'High and vast mountain range with temperature extremes. Edge of mountain range on great plains can suffer from tornados', 99.200, 98.131, 32.801, 33.991, 'Savannah'),
('United KStates of America', '', 'Extreme ice and snow for much of the year with low visibility in heavy weather.', 81.011, 80.131, 28.801, 29.991, 'Ice/Snow');

SET IDENTITY_INSERT tblSubscriber ON;
INSERT INTO tblSubscriber(CustomerID) VALUES
(1000000001),
(1000000002),
(1000000003),
(1000000004),
(1000000005),
(1000000006),
(1000000007),
(1000000008),
(1000000009),
(1000000010),
(1000000011),
(1000000012),
(1000000013),
(1000000014),
(1000000015),
(1000000016),
(1000000017),
(1000000018),
(1000000019),
(1000000020),
(1000000021),
(1000000022),
(1000000023),
(1000000024),
(1000000025),
(1000000026),
(1000000027),
(1000000028),
(1000000029),
(1000000030);
SET IDENTITY_INSERT tblSubscriber OFF;

INSERT INTO tblVenueType
VALUES 
('Website'),
('Office'),
('Store'),
('Stall'),
('Headquarters');

SET IDENTITY_INSERT tblContractee ON;
INSERT INTO tblContractee(CustomerID) VALUES
(00001),
(00002),
(00003),
(00004),
(00005),
(00006),
(00007),
(00008),
(00009),
(00010),
(00011),
(00012),
(00013),
(00014),
(00015),
(00016),
(00017),
(00018),
(00019),
(00020),
(00021),
(00022),
(00023),
(00024),
(00025),
(00026),
(00027),
(00028),
(00029),
(00030);
SET IDENTITY_INSERT tblContractee OFF;

SET DATEFORMAT DMY
INSERT INTO tblDatabox
VALUES  
('18/01/2020', '22/09/2019', '21/04/2020', 'Jungle'),
('06/06/2019', '25/12/2019', '30/03/2020', 'Jungle'),
('16/11/2019', '30/01/2020', '26/04/2020', 'Mountain'),
('28/02/2020', '18/03/2020', '16/07/2019', 'Forest'),
('20/02/2020', '28/09/2019', '08/11/2019', 'Savannah'),
('07/02/2020', '01/07/2019', '22/04/2020', 'Jungle'),
('30/12/2019', '24/05/2020', '30/07/2019', 'Forest'),
('27/10/2019', '15/02/2020', '29/09/2019', 'Desert'),
('24/06/2019', '21/01/2020', '08/01/2020', 'Ice/Snow'),
('07/02/2020', '11/05/2020', '18/04/2020', 'Jungle'),
('17/05/2020', '25/04/2020', '30/01/2020', 'Desert'),
('25/04/2020', '06/04/2020', '08/09/2019', 'Forest'),
('02/03/2020', '25/11/2019', '01/12/2019', 'Jungle'),
('28/03/2020', '30/06/2019', '16/05/2020', 'Forest'),
('18/08/2019', '18/05/2020', '14/10/2019', 'Urban'),
('15/10/2019', '27/04/2020', '25/06/2019', 'Jungle'),
('10/10/2019', '24/09/2019', '11/10/2019', 'Mountain'),
('07/07/2019', '31/10/2019', '04/07/2019', 'Savannah'),
('17/11/2019', '20/11/2019', '14/07/2019', 'Ice/Snow'),
('08/09/2019', '20/03/2020', '16/08/2019', 'Jungle'),
('12/07/2019', '30/08/2019', '21/10/2019', 'Forest'),
('23/03/2020', '12/07/2019', '01/09/2019', 'Jungle'),
('27/01/2020', '13/06/2019', '23/05/2020', 'Savannah'),
('02/03/2020', '30/04/2020', '26/02/2020', 'Mountain'),
('21/10/2019', '06/05/2020', '11/07/2019', 'Urban'),
('15/03/2020', '06/01/2020', '04/07/2019', 'Forest'),
('05/12/2019', '27/06/2019', '29/04/2020', 'Mountain'),
('08/03/2020', '20/03/2020', '21/09/2019', 'Savannah'),
('17/09/2019', '21/09/2019', '18/10/2019', 'Forest'),
('12/06/2020', '22/03/2020', '02/12/2019', 'Desert'),
('27/01/2020', '30/08/2019', '21/11/2019', 'Ice/Snow'),
('05/12/2019', '21/07/2019', '14/03/2020', 'Savannah'),
('11/06/2020', '11/03/2020', '05/12/2019', 'Forest'),
('22/08/2019', '09/04/2020', '14/06/2019', 'Forest'),
('06/09/2019', '22/11/2019', '01/05/2020', 'Forest'),
('11/11/2019', '21/10/2019', '16/07/2019', 'Urban'),
('28/12/2019', '19/04/2020', '23/11/2019', 'Mountain'),
('02/01/2020', '03/03/2020', '29/02/2020', 'Urban'),
('06/02/2020', '08/10/2019', '27/03/2020', 'Savannah'),
('16/04/2020', '29/04/2020', '18/12/2019', 'Desert'),
('01/10/2019', '20/07/2019', '26/01/2020', 'Forest'),
('04/03/2020', '29/08/2019', '15/03/2020', 'Savannah'),
('24/11/2019', '19/04/2020', '06/06/2020', 'Jungle'),
('17/08/2019', '29/03/2020', '28/07/2019', 'Jungle'),
('17/06/2019', '04/11/2019', '22/08/2019', 'Desert'),
('08/04/2020', '08/07/2019', '24/07/2019', 'Forest'),
('01/08/2019', '07/10/2019', '04/09/2019', 'Urban'),
('22/08/2019', '26/08/2019', '15/11/2019', 'Jungle'),
('18/12/2019', '03/05/2020', '31/08/2019', 'Ice/Snow'),
('30/05/2020', '13/04/2020', '05/01/2020', 'Savannah'),
('30/06/2019', '14/02/2020', '05/01/2020', 'Jungle'),
('13/06/2019', '23/01/2020', '29/04/2020', 'Urban'),
('07/03/2020', '02/05/2020', '05/10/2019', 'Forest'),
('23/09/2019', '11/04/2020', '28/10/2019', 'Savannah'),
('25/11/2019', '25/08/2019', '02/08/2019', 'Desert'),
('22/11/2019', '05/08/2019', '11/07/2019', 'Jungle'),
('14/07/2019', '21/01/2020', '23/02/2020', 'Forest'),
('13/07/2019', '04/08/2019', '01/10/2019', 'Forest'),
('06/05/2020', '26/01/2020', '18/08/2019', 'Forest'),
('21/07/2019', '15/01/2020', '11/09/2019', 'Forest'),
('08/08/2019', '02/06/2020', '13/08/2019', 'Ice/Snow'),
('05/05/2020', '06/07/2019', '04/07/2019', 'Desert'),
('21/01/2020', '06/10/2019', '26/05/2020', 'Desert'),
('18/04/2020', '30/11/2019', '19/02/2020', 'Jungle'),
('06/06/2020', '21/10/2019', '25/03/2020', 'Mountain'),
('17/05/2020', '19/10/2019', '02/05/2020', 'Urban'),
('27/12/2019', '11/07/2019', '08/01/2020', 'Forest'),
('07/03/2020', '01/11/2019', '11/07/2019', 'Urban'),
('19/03/2020', '10/09/2019', '08/05/2020', 'Jungle'),
('31/03/2020', '20/12/2019', '07/05/2020', 'Ice/Snow'),
('30/12/2019', '02/03/2020', '17/11/2019', 'Urban'),
('25/05/2020', '27/10/2019', '16/08/2019', 'Jungle'),
('03/07/2019', '10/12/2019', '19/01/2020', 'Desert'),
('21/03/2020', '08/11/2019', '23/11/2019', 'Jungle'),
('06/05/2020', '01/09/2019', '19/12/2019', 'Urban'),
('27/11/2019', '20/02/2020', '06/12/2019', 'Urban'),
('09/05/2020', '14/04/2020', '27/09/2019', 'Forest'),
('09/07/2019', '17/03/2020', '19/08/2019', 'Mountain'),
('06/01/2020', '17/07/2019', '27/05/2020', 'Jungle'),
('05/05/2020', '18/03/2020', '13/05/2020', 'Savannah'),
('18/09/2019', '01/03/2020', '30/12/2019', 'Forest'),
('26/08/2019', '30/10/2019', '26/06/2019', 'Ice/Snow'),
('03/01/2020', '31/10/2019', '12/12/2019', 'Forest'),
('15/08/2019', '29/12/2019', '10/04/2020', 'Desert'),
('02/08/2019', '04/06/2020', '11/03/2020', 'Urban'),
('19/04/2020', '03/03/2020', '06/09/2019', 'Forest'),
('30/05/2020', '22/04/2020', '23/05/2020', 'Jungle'),
('24/10/2019', '25/11/2019', '04/09/2019', 'Desert'),
('12/12/2019', '20/02/2020', '22/09/2019', 'Ice/Snow'),
('26/07/2019', '26/09/2019', '12/12/2019', 'Savannah'),
('31/03/2020', '17/01/2020', '04/02/2020', 'Savannah'),
('13/12/2019', '23/04/2020', '30/03/2020', 'Urban'),
('22/09/2019', '26/09/2019', '13/03/2020', 'Jungle'),
('08/11/2019', '13/02/2020', '05/08/2019', 'Savannah'),
('20/10/2019', '13/12/2019', '30/03/2020', 'Desert'),
('04/09/2019', '16/07/2019', '12/03/2020', 'Urban'),
('07/10/2019', '15/01/2020', '25/05/2020', 'Jungle'),
('23/01/2020', '09/03/2020', '10/05/2020', 'Jungle'),
('17/07/2019', '04/03/2020', '27/10/2019', 'Savannah'),
('25/12/2019', '15/06/2019', '17/09/2019', 'Forest');

INSERT INTO tblLiveStream
VALUES 
(0000000001),
(0000000002),
(0000000003),
(0000000004),
(0000000005),
(0000000006),
(0000000007),
(0000000008),
(0000000009),
(0000000010),
(0000000011),
(0000000012),
(0000000013),
(0000000014),
(0000000015),
(0000000016),
(0000000017),
(0000000018),
(0000000019),
(0000000020),
(0000000021),
(0000000022),
(0000000023),
(0000000024),
(0000000025),
(0000000026),
(0000000027),
(0000000028),
(0000000029),
(0000000030),
(0000000031),
(0000000032),
(0000000033),
(0000000034),
(0000000035),
(0000000036),
(0000000037),
(0000000038),
(0000000039),
(0000000040),
(0000000041),
(0000000042),
(0000000043),
(0000000044),
(0000000045),
(0000000046),
(0000000047),
(0000000048),
(0000000049),
(0000000050),
(0000000051),
(0000000052),
(0000000053),
(0000000054),
(0000000055),
(0000000056),
(0000000057),
(0000000058),
(0000000059),
(0000000060),
(0000000061),
(0000000062),
(0000000063),
(0000000064),
(0000000065),
(0000000066),
(0000000067),
(0000000068),
(0000000069),
(0000000070),
(0000000071),
(0000000072),
(0000000073),
(0000000074),
(0000000075),
(0000000076),
(0000000077),
(0000000078),
(0000000079),
(0000000080),
(0000000081),
(0000000082),
(0000000083),
(0000000084),
(0000000085),
(0000000086),
(0000000087),
(0000000088),
(0000000089),
(0000000090),
(0000000091),
(0000000092),
(0000000093),
(0000000094),
(0000000095),
(0000000096),
(0000000097),
(0000000098),
(0000000099),
(0000000100);

INSERT INTO tblData
VALUES 
('16/10/2019', '14:26', 34.24475, 62.19165, 9401, 60, 84, 25865.4698, 0000000001),
('31/08/2019', '15:47', 5.6972693, 7.0605998, 7551, 74, 13, 91589.0001, 0000000002),
('11/07/2019', '0:53', 58.3634707, 59.8100344, 673, 22, 84, 39825.5463, 0000000003),
('09/09/2019', '12:17', 25.49872, 119.790168, 424, 99, 95, 21316.8014, 0000000003),
('12/10/2019', '15:52', -7.2284727, -39.3121233, 5518, 6, 85, 49204.3164, 0000000100),
('15/08/2019', '21:56', 21.912701, 111.902604, 4715, 85, 69, 63686.3658, 0000000100),
('10/06/2020', '16:24', 40.2047139, 44.5128424, 5850, 46, 42, 69172.8506, 0000000004),
('26/09/2019', '16:55', 18.1686828, 120.7050032, 9782, 50, 63, 15978.3608, 0000000005),
('03/12/2019', '5:20', 29.57858, 110.191933, 12552, 30, 59, 78386.0471, 0000000006),
('04/06/2020', '4:59', 27.8469, 105.049027, 6058, 16, 59, 91593.743, 0000000007),
('15/07/2019', '3:03', 46.1005467, 19.6650593, 10244, 94, 62, 97836.0873, 0000000007),
('17/02/2020', '23:07', 35.8712549, 120.0058196, 11397, 44, 83, 28647.2849, 0000000007),
('08/11/2019', '1:14', 33.9616991, 113.2193846, 2002, 12, 40, 34220.5438, 0000000008),
('27/10/2019', '13:34', 39.46662, 112.094594, 1277, 74, 55, 59870.8287, 0000000008),
('25/05/2020', '10:31', 41.7811503, -8.6240851, 9113, 56, 56, 6944.7448, 0000000009),
('13/06/2019', '4:25', 29.9518573, -90.067925, 14671, 47, 57, 4497.0563, 0000000010),
('17/07/2019', '19:13', 46.36313, 30.64891, 3109, 84, 10, 30030.1737, 0000000010),
('19/05/2020', '13:07', -7.3100537, 112.6407229, 3512, 62, 23, 1468.2755, 0000000010),
('05/06/2020', '15:47', 14.34399, 45.72623, 7304, 68, 23, 58301.4846, 0000000011),
('15/07/2019', '13:28', 6.1071457, -3.8553507, 8345, 60, 1, 61677.7461, 0000000012),
('15/07/2019', '14:13', 53.7133491, 40.9922209, 3030, 52, 68, 36616.1894, 0000000012),
('23/07/2019', '5:41', 43.9277535, 2.1504611, 4257, 52, 59, 34629.0741, 0000000012),
('21/08/2019', '4:08', 9.0691769, -62.0458106, 1423, 45, 84, 40809.8973, 0000000099),
('12/08/2019', '9:45', -38.9351182, -68.2320043, 7492, 70, 79, 29001.3209, 0000000099),
('05/08/2019', '0:35', -34.6234902, -58.4955016, 12883, 61, 90, 29091.0214, 0000000001),
('21/02/2020', '2:43', 54.2395971, 29.6623761, 5586, 51, 18, 44203.4884, 0000000099),
('12/03/2020', '9:07', 8.2885006, 124.7789045, 9567, 27, 61, 94639.6222, 0000000099),
('14/02/2020', '2:14', 15.6240255, 120.3903545, 8772, 2, 42, 6249.0871, 0000000067),
('22/05/2020', '6:50', 51.0279541, 18.4228918, 8997, 2, 73, 43362.3765, 0000000067),
('16/07/2019', '21:08', 38.8163486, -104.8512993, 9620, 60, 55, 54481.2244, 0000000019),
('25/02/2020', '7:07', 42.9856238, 25.6162991, 9568, 37, 48, 84577.0114, 0000000080),
('28/07/2019', '17:44', 10.9856014, 124.5316391, 1806, 65, 82, 85305.776, 0000000080),
('05/09/2019', '0:41', 6.2962841, -71.9045649, 236, 66, 85, 51276.4156, 0000000080),
('13/06/2019', '9:47', 51.1749425, 53.0211497, 14369, 78, 23, 48663.3463, 0000000078),
('11/06/2020', '3:19', 16.5836127, 42.9149297, 3937, 86, 16, 65793.6193, 0000000078),
('06/05/2020', '16:23', 35.553144, 116.783833, 12622, 47, 2, 42858.1329, 0000000078),
('23/04/2020', '6:16', 39.0054084, 21.6386381, 3095, 65, 1, 34374.8381, 0000000078),
('17/04/2020', '17:47', 38.042805, 114.514893, 6089, 54, 43, 79081.3904, 0000000098),
('01/05/2020', '22:57', 41.45472, 20.02556, 6219, 79, 35, 36966.8076, 0000000098),
('08/06/2020', '8:14', 8.0693651, 123.535497, 11906, 12, 74, 54508.0619, 0000000009),
('09/10/2019', '23:51', 42.046011, -8.4825685, 1439, 85, 40, 10819.7029, 0000000045),
('10/01/2020', '9:00', -7.698725, 113.8465758, 11072, 26, 65, 69651.464, 0000000045),
('10/08/2019', '23:02', 53.126506, 92.94376, 4765, 57, 66, 88395.8604, 0000000054),
('06/07/2019', '15:33', 34.393136, 115.865746, 5314, 42, 97, 87716.94, 0000000054),
('24/08/2019', '7:10', -21.0209448, -41.1547688, 9667, 75, 70, 82582.1078, 0000000001),
('20/07/2019', '16:18', -29.7619121, -57.0858428, 13256, 31, 7, 27138.6931, 0000000054),
('13/10/2019', '10:26', -8.5111152, 118.4163103, 6754, 91, 54, 5156.167, 0000000001),
('30/06/2019', '7:54', 38.56077, 114.250474, 2340, 64, 96, 61434.8646, 0000000001),
('29/04/2020', '18:09', -17.8766507, 30.6775054, 7041, 53, 88, 3948.382, 0000000065),
('12/01/2020', '8:18', 26.6849798, 100.7492159, 13349, 85, 24, 63574.8793, 0000000065),
('05/12/2019', '6:40', 58.4249631, 29.3677109, 5307, 60, 58, 7161.3131, 0000000065),
('04/01/2020', '16:45', 56.057734, 24.4027094, 4985, 3, 70, 13344.8937, 0000000065),
('26/10/2019', '9:47', -7.3594399, 112.6839275, 13029, 92, 9, 66108.7572, 0000000066),
('13/11/2019', '14:21', 49.8098094, 15.5297943, 11896, 65, 56, 72135.412, 0000000032),
('21/09/2019', '22:48', 43.6165639, 27.091526, 5347, 74, 41, 83259.0983, 0000000032),
('15/02/2020', '18:37', 60.7610412, -135.1742264, 6135, 24, 70, 6452.4511, 0000000034),
('15/10/2019', '5:24', 40.1999522, -8.5031422, 9624, 74, 8, 87465.2813, 0000000033),
('07/10/2019', '6:30', 28.854554, 120.740782, 517, 81, 45, 13259.6344, 0000000026),
('08/02/2020', '23:21', 39.0638705, -108.5506486, 5864, 100, 66, 8148.0079, 0000000026),
('26/07/2019', '21:10', 29.230933, 89.841983, 3532, 1, 10, 36598.1368, 0000000026),
('11/04/2020', '5:59', 43.179594, 123.855668, 1821, 96, 4, 61225.301, 0000000026),
('11/12/2019', '0:49', -8.2361656, 113.2874692, 13169, 99, 28, 39719.8925, 0000000023),
('23/04/2020', '9:13', 45.3859182, -71.936914, 9308, 7, 75, 47454.4788, 0000000099),
('10/06/2020', '3:06', 23.009805, 113.088924, 12845, 54, 94, 770.3978, 0000000090),
('01/01/2020', '0:05', 37.800886, -25.6125131, 2845, 47, 62, 41633.8784, 0000000090),
('30/04/2020', '7:40', 50.7885238, 37.8995347, 13568, 25, 90, 11834.693, 0000000090),
('10/05/2020', '5:02', 37.6533531, 138.9099913, 11771, 48, 11, 22393.5154, 0000000090),
('04/09/2019', '16:31', 29.407391, 106.543713, 9339, 39, 59, 10103.5121, 0000000090),
('19/09/2019', '14:18', 17.1413481, 102.7824777, 8498, 21, 94, 39814.7681, 0000000090),
('20/02/2020', '14:15', 39.706618, 21.6288728, 12987, 28, 93, 15076.55, 0000000090),
('02/10/2019', '2:12', 55.6027928, 43.763221, 1120, 37, 71, 68703.9238, 0000000090),
('10/12/2019', '17:54', 2.3815417, 11.2665498, 6010, 97, 30, 41426.293, 0000000090),
('01/07/2019', '0:01', 26.753593, 110.138232, 9833, 43, 27, 98785.1634, 0000000070),
('10/01/2020', '18:50', 54.7208946, 37.5455632, 2248, 2, 5, 31978.8036, 0000000001),
('22/01/2020', '13:10', -7.4234223, 108.7422767, 3855, 27, 83, 19763.0541, 0000000001),
('22/04/2020', '15:35', 55.224467, 45.8810866, 8268, 11, 100, 4178.151, 0000000001),
('16/03/2020', '12:04', 39.664138, -8.5173008, 5912, 82, 71, 3707.0255, 0000000001),
('22/09/2019', '5:12', 37.90889, 126.16111, 10918, 41, 6, 89381.5252, 0000000001),
('12/08/2019', '12:16', 33.3297722, 133.2308851, 6819, 49, 60, 11655.0706, 0000000081),
('08/11/2019', '21:59', -7.2630131, 112.7211714, 14512, 74, 1, 3188.1579, 0000000071),
('17/04/2020', '13:52', 45.0030925, 43.7825227, 5309, 16, 10, 3156.3256, 0000000031),
('18/04/2020', '23:38', 18.4581133, -69.3044885, 5605, 94, 17, 65499.0303, 0000000011),
('03/07/2019', '6:16', 18.4305759, -69.9663985, 14310, 87, 34, 29699.0997, 0000000041),
('08/09/2019', '19:20', -25.7677734, 31.0242101, 6392, 14, 53, 82718.9426, 0000000051),
('06/08/2019', '21:49', 19.7605927, -99.1476908, 1118, 67, 16, 25610.5503, 0000000041),
('06/08/2019', '14:28', 14.6462828, 100.1479182, 513, 24, 23, 60085.7397, 0000000001),
('04/03/2020', '4:22', 24.7242467, 56.4607919, 13493, 21, 55, 79248.0834, 0000000001),
('16/12/2019', '20:31', 31.3219, 121.01853, 2321, 52, 11, 7357.8951, 0000000001),
('18/07/2019', '4:20', 6.568518, 79.960149, 1559, 79, 19, 83473.9034, 0000000001),
('03/02/2020', '13:00', -4.3681626, -39.4035876, 11546, 92, 29, 60882.0223, 0000000001),
('21/08/2019', '2:37', 58.6316895, 80.1006379, 13356, 26, 79, 83301.2165, 0000000001),
('17/06/2019', '15:57', 48.8132669, 2.4114143, 8284, 62, 13, 27694.2725, 0000000001),
('05/08/2019', '10:55', 8.931132, -75.030651, 5287, 40, 17, 17348.6548, 0000000001),
('03/12/2019', '7:02', 43.0318353, 23.377264, 6589, 5, 82, 57756.1522, 0000000001),
('27/04/2020', '10:25', 46.2983568, -0.8937702, 9876, 4, 13, 33399.5248, 0000000001),
('30/04/2020', '9:48', 50.1224689, 27.506767, 4867, 14, 32, 87603.256, 0000000001),
('21/06/2019', '5:01', -6.2686878, 139.9469432, 9671, 3, 31, 94700.0927, 0000000001),
('21/06/2019', '11:28', 55.5674405, 71.358565, 14668, 13, 21, 94787.3395, 0000000001),
('17/02/2020', '14:30', 34.0319016, 131.0103712, 8232, 58, 71, 27783.6519, 0000000001),
('28/02/2020', '11:34', 44.840524, 82.353656, 3278, 97, 54, 84991.5415, 0000000001),
('06/02/2020', '21:38', 29.234232, 116.835701, 165, 33, 8, 70238.7104, 0000000001),
('20/02/2020', '9:27', 24.914102, 118.604038, 12111, 62, 93, 27127.7048, 0000000001),
('25/01/2020', '14:13', 40.356194, -8.0224709, 4503, 93, 71, 45833.4638, 0000000001),
('16/09/2019', '12:19', 32.0467278, 118.7864923, 11197, 31, 54, 89050.0999, 0000000001),
('03/05/2020', '12:46', -28.5323842, 26.9999584, 1190, 72, 38, 97316.127, 0000000001),
('27/10/2019', '0:27', 7.156124, 79.949646, 6426, 27, 49, 42864.6974, 0000000001),
('22/03/2020', '2:47', 29.5530941, 118.9353968, 6251, 16, 16, 19816.3405, 0000000001),
('14/02/2020', '20:20', 22.54817, 114.131764, 5079, 8, 51, 64201.3091, 0000000001),
('10/12/2019', '21:02', 37.136977, 140.4367415, 3160, 31, 8, 54542.8039, 0000000001),
('28/08/2019', '0:39', 24.9936281, 121.3009798, 12878, 34, 34, 64355.5391, 0000000001),
('06/04/2020', '11:57', 33.32836, 35.92144, 13986, 75, 67, 33510.9816, 0000000001),
('19/10/2019', '0:02', 50.1757487, 27.0559924, 9980, 99, 14, 4494.7046, 0000000001),
('29/11/2019', '5:08', 29.859178, 106.410852, 1382, 2, 25, 51839.1813, 0000000001),
('12/08/2019', '23:02', 39.95, -75.16, 11273, 45, 21, 39334.2763, 0000000001),
('29/01/2020', '17:14', 31.2303904, 121.4737021, 11668, 23, 81, 98817.025, 0000000001),
('22/05/2020', '10:01', 58.9583506, 5.7740124, 14661, 92, 24, 33785.9157, 0000000001),
('09/08/2019', '15:39', 25.558201, 103.256615, 6144, 89, 42, 17885.2549, 0000000001),
('07/03/2020', '12:29', -8.8899, 121.2806, 8564, 58, 14, 98372.2951, 0000000001),
('01/01/2020', '3:08', 37.7340363, -8.4593678, 8640, 27, 61, 37782.4947, 0000000001),
('13/08/2019', '2:21', 31.790235, 34.759291, 760, 8, 81, 99925.032, 0000000001),
('30/05/2020', '15:27', 52.1861944, 5.3099089, 13969, 64, 1, 98057.6491, 0000000001),
('05/09/2019', '21:04', 33.9042954, 73.3907315, 3456, 18, 85, 35620.6361, 0000000001),
('21/05/2020', '21:28', 45.4698284, 13.6405292, 8311, 11, 95, 85720.4649, 0000000001),
('10/12/2019', '22:04', 52.7865762, 52.2631971, 3810, 23, 36, 67048.9554, 0000000001),
('10/10/2019', '23:09', 23.104725, 113.668388, 14405, 30, 31, 80379.5943, 0000000001),
('28/06/2019', '17:31', 49.1606317, 6.9179709, 8181, 63, 77, 27802.7615, 0000000001),
('29/06/2019', '5:53', 34.6870111, -5.4502624, 1957, 73, 53, 61192.7709, 0000000001),
('11/03/2020', '1:12', 35.8875, 14.51694, 8149, 53, 25, 37311.4593, 0000000001),
('20/02/2020', '11:34', 14.83361, 43.53639, 4952, 57, 23, 79746.5721, 0000000001),
('26/10/2019', '5:17', 22.974898, 113.993115, 8333, 6, 85, 10810.1288, 0000000001),
('15/01/2020', '6:51', -15.1471649, -73.3406579, 8689, 88, 88, 72916.2495, 0000000001),
('23/06/2019', '7:51', 63.4388688, 10.4232348, 6126, 28, 97, 10544.7748, 0000000001),
('11/03/2020', '15:40', 55.7368049, 37.8286538, 13294, 52, 34, 73496.0688, 0000000001),
('11/04/2020', '1:58', 34.2398892, 135.2395881, 3143, 99, 15, 39773.546, 0000000001),
('06/08/2019', '15:50', 38.0249, 22.73294, 11854, 82, 72, 59194.8544, 0000000001),
('16/08/2019', '3:25', 41.3899483, -8.3685941, 7525, 98, 85, 3677.5775, 0000000001),
('24/11/2019', '5:58', 16.842826, 120.402603, 1105, 63, 93, 50392.7632, 0000000001),
('18/09/2019', '1:59', -7.1311, 108.5671, 3056, 85, 3, 1756.0542, 0000000001),
('23/10/2019', '18:04', 6.6242047, -72.7924612, 7600, 14, 12, 44252.139, 0000000001),
('06/08/2019', '13:28', 49.8529322, 14.7029932, 10348, 71, 37, 74184.1103, 0000000001),
('07/11/2019', '5:19', -22.6578882, -42.3965262, 1, 15, 98, 82078.3668, 0000000001),
('31/10/2019', '0:11', 56.7458379, 24.4061069, 14369, 73, 2, 33129.4974, 0000000001),
('18/03/2020', '10:50', -2.5503853, -44.070196, 3085, 73, 55, 44906.8798, 0000000001),
('25/01/2020', '15:14', 32.6434902, 35.9396453, 8124, 53, 39, 63128.478, 0000000001),
('16/04/2020', '3:11', -28.1804757, 30.1531568, 6376, 64, 86, 54991.4612, 0000000001),
('18/10/2019', '17:14', 49.9166289, 19.1520875, 4533, 89, 59, 69431.9202, 0000000001),
('23/09/2019', '20:20', 46.3899032, 16.6974271, 14073, 5, 4, 21483.1949, 0000000001),
('18/05/2020', '1:41', 60.5201867, 23.2169967, 11607, 21, 61, 43384.4589, 0000000001),
('22/08/2019', '9:08', 16.4498, 107.5623501, 5720, 63, 17, 63406.5885, 0000000001),
('07/04/2020', '6:14', 15.2884878, 120.5714361, 9661, 17, 41, 62725.315, 0000000001),
('31/08/2019', '1:36', 50.9603536, 14.3596743, 1316, 48, 71, 21490.7694, 0000000001),
('26/03/2020', '1:42', -12.3502374, 44.5278242, 11063, 16, 83, 45414.3473, 0000000001),
('15/03/2020', '19:23', 7.0739678, -73.1692652, 3581, 7, 83, 84759.4743, 0000000001),
('17/07/2019', '20:05', 51.441874, 6.886548, 1797, 24, 33, 62315.3935, 0000000001),
('07/07/2019', '0:02', 45.5322977, 20.2153721, 12063, 25, 99, 98997.8085, 0000000001),
('13/08/2019', '3:05', -6.4334, 105.9098, 1449, 11, 69, 10017.8007, 0000000001),
('18/04/2020', '11:00', 14.565668, 121.0317737, 9001, 59, 80, 48963.8812, 0000000001),
('12/07/2019', '6:28', -9.8550137, 124.2949409, 7368, 48, 33, 7280.1597, 0000000001),
('04/05/2020', '7:30', 14.6790319, 100.6985155, 13209, 99, 34, 56948.5453, 0000000001),
('30/10/2019', '18:32', 7.3042466, 122.258933, 7704, 54, 32, 84844.6103, 0000000001),
('19/11/2019', '0:54', 59.406891, 18.0157421, 5593, 15, 46, 82551.0733, 0000000001),
('27/02/2020', '7:26', 26.7500171, 33.9359756, 902, 23, 14, 48195.7811, 0000000001),
('11/02/2020', '9:30', 51.7173795, 15.4240467, 3554, 47, 42, 72652.0177, 0000000001),
('02/09/2019', '4:36', 34.0740905, 70.2884528, 7668, 41, 85, 46881.7327, 0000000001),
('20/05/2020', '3:48', -1.2936976, -50.5135589, 3084, 32, 70, 1941.7244, 0000000001),
('18/03/2020', '18:55', 43.2456198, 26.9297347, 1892, 52, 22, 57701.1525, 0000000001),
('12/01/2020', '23:03', 50.1681621, 40.3703941, 14834, 73, 31, 27854.8481, 0000000001),
('24/03/2020', '17:31', 59.853262, 17.6356163, 7974, 46, 4, 16803.3426, 0000000001),
('12/07/2019', '7:31', -7.5450262, 111.6556388, 14202, 58, 40, 6339.6792, 0000000001),
('27/01/2020', '11:26', 28.2412186, 112.9513185, 12746, 23, 35, 57744.6721, 0000000001),
('15/10/2019', '9:44', -7.6543174, 109.2920742, 2635, 49, 80, 51081.639, 0000000001),
('18/03/2020', '2:15', 55.6345009, 13.0744097, 11956, 43, 12, 59308.3472, 0000000001),
('29/07/2019', '3:40', 12.0969337, 124.508607, 14091, 59, 59, 4339.099, 0000000001),
('08/09/2019', '15:27', 44.335532, 85.625121, 13094, 57, 16, 82833.5458, 0000000001),
('03/04/2020', '7:38', 29.0825, 48.13028, 6769, 59, 100, 37549.5614, 0000000001),
('05/12/2019', '6:26', 35.761829, 115.029215, 5280, 62, 27, 20125.8216, 0000000001),
('18/04/2020', '2:11', 22.251924, 112.794065, 9261, 59, 41, 63936.2485, 0000000001),
('01/05/2020', '21:04', 40.5944059, -74.0711359, 13825, 44, 69, 85953.575, 0000000001),
('13/09/2019', '21:53', 32.085094, 35.180832, 3251, 99, 94, 29616.2932, 0000000001),
('14/11/2019', '8:34', 32.990664, 112.528308, 2257, 82, 55, 87336.8058, 0000000001),
('13/05/2020', '8:55', 41.2615617, -8.1756398, 6066, 83, 4, 15448.3365, 0000000001),
('22/06/2019', '7:47', -7.5273, 110.336609, 11175, 60, 21, 16908.8926, 0000000001),
('20/08/2019', '8:18', 4.9918699, -73.87076, 9919, 93, 75, 82281.6021, 0000000001),
('26/11/2019', '7:10', 32.935752, 104.692473, 8685, 43, 69, 71666.3486, 0000000001),
('11/11/2019', '9:36', 26.6674, 113.449709, 2323, 92, 6, 57461.366, 0000000001),
('03/07/2019', '8:19', 40.8358295, 20.1089899, 684, 51, 51, 8716.0005, 0000000001),
('30/01/2020', '4:20', -8.3654775, 113.5371368, 12168, 30, 46, 80884.405, 0000000001),
('28/01/2020', '0:38', 30.292001, 71.6657348, 770, 22, 95, 40415.8288, 0000000001),
('18/01/2020', '3:30', 53.3621047, 58.9682091, 7198, 16, 96, 8766.5404, 0000000001),
('21/03/2020', '9:21', 30.8337059, 35.6160558, 6463, 15, 14, 73117.7393, 0000000001),
('09/09/2019', '17:56', 31.9780238, 35.8492033, 10708, 52, 87, 36067.7048, 0000000001),
('21/11/2019', '4:23', -21.2335652, -45.2325476, 10495, 3, 29, 87247.0815, 0000000001),
('04/05/2020', '12:36', 9.1224847, -79.2930312, 12738, 44, 7, 95704.194, 0000000001),
('25/10/2019', '12:32', 38.0099999, 67.7914041, 6180, 66, 84, 79480.6882, 0000000001),
('08/01/2020', '12:45', 34.1985119, -118.4980744, 1393, 78, 11, 88942.1525, 0000000001),
('19/03/2020', '1:11', 49.8162612, 15.4768669, 14094, 93, 37, 46258.5137, 0000000001),
('06/03/2020', '1:22', 48.1214727, 11.5322563, 5545, 10, 23, 18790.2769, 0000000001),
('09/05/2020', '18:58', 14.563755, -89.352441, 11893, 92, 91, 95269.0759, 0000000001),
('20/07/2019', '3:33', 32.968121, 130.6358305, 7006, 85, 71, 76216.1229, 0000000001),
('16/04/2020', '22:45', 40.75, -73.99, 5396, 78, 3, 84418.8052, 0000000001),
('16/10/2019', '0:33', 48.64278, 97.61861, 2236, 24, 47, 62084.826, 0000000001),
('06/10/2019', '11:41', 31.719806, 112.257788, 9852, 79, 92, 75044.4626, 0000000001),
('20/10/2019', '15:49', 39.997756, 116.190434, 9637, 3, 60, 39616.2823, 0000000001),
('20/04/2020', '20:10', 18.9351075, -70.405585, 2689, 59, 54, 81329.8754, 0000000001),
('02/10/2019', '4:20', 56.6444907, 14.224297, 10931, 36, 3, 20518.0452, 0000000001),
('15/03/2020', '19:19', 27.872028, 112.969479, 4717, 35, 12, 54821.0276, 0000000001),
('06/05/2020', '14:11', 0.2827307, 34.7518631, 14347, 79, 15, 266.8237, 0000000001),
('19/05/2020', '14:50', 42.3890735, 47.9897691, 14797, 86, 8, 96996.9468, 0000000001),
('28/11/2019', '4:59', 45.2767109, 18.3876045, 11768, 14, 80, 58204.7724, 0000000001),
('13/03/2020', '17:01', 14.6593627, 120.9886269, 12321, 28, 65, 37670.1292, 0000000001),
('12/02/2020', '2:51', 50.6999479, 13.8459307, 13499, 16, 13, 5062.9835, 0000000001),
('15/05/2020', '11:26', 14.4712676, 121.0441201, 14470, 6, 61, 70861.238, 0000000001),
('02/09/2019', '23:14', -22.3990179, 18.9739954, 3618, 90, 57, 37988.3766, 0000000001),
('03/07/2019', '14:18', -12.3446835, -75.8704611, 1424, 6, 87, 82637.2486, 0000000001),
('12/06/2020', '11:00', 23.5585593, 89.9041371, 534, 63, 39, 49874.7391, 0000000001),
('25/03/2020', '12:28', 54.2207765, 18.9709477, 2354, 55, 28, 13331.4327, 0000000001),
('03/05/2020', '19:39', 38.876483, 121.549925, 12667, 90, 80, 26097.0468, 0000000001),
('19/02/2020', '14:42', 49.4841887, 17.3382537, 10924, 10, 62, 74407.3451, 0000000001),
('17/09/2019', '7:50', -6.1493907, 143.6474817, 11137, 80, 19, 34464.9188, 0000000001),
('19/02/2020', '17:43', 24.076563, 89.61457, 8246, 54, 13, 81356.9116, 0000000001),
('16/08/2019', '8:58', 47.8018062, 38.4885354, 3925, 19, 66, 17497.9454, 0000000001),
('08/09/2019', '19:46', 35.03566, 37.475109, 1166, 85, 77, 30239.0327, 0000000001),
('22/04/2020', '3:58', 29.696195, 106.79542, 8964, 30, 97, 97301.3328, 0000000001),
('10/05/2020', '8:00', -7.0967, 113.6588, 14884, 32, 75, 49797.4744, 0000000001),
('25/10/2019', '2:38', 14.5634196, 121.0307955, 12874, 52, 35, 19776.0041, 0000000001),
('22/01/2020', '10:05', 47.484145, 6.923811, 4287, 23, 88, 8852.5233, 0000000001),
('13/04/2020', '18:43', 63.2706498, 18.6972941, 1901, 80, 67, 71213.7037, 0000000001),
('15/07/2019', '15:06', 64.8734795, 20.3845205, 12074, 20, 56, 32045.8274, 0000000001),
('14/05/2020', '9:42', 41.0251448, 22.0056062, 6220, 92, 43, 52072.2123, 0000000001),
('02/12/2019', '16:42', 14.6353584, 121.0020785, 6054, 17, 23, 58818.832, 0000000001),
('26/11/2019', '18:03', 52.5124538, 4.6573346, 9256, 35, 56, 76634.4046, 0000000001),
('01/10/2019', '3:14', 49.660696, 25.1434666, 2975, 33, 9, 77970.4244, 0000000001),
('06/12/2019', '7:26', 9.4811641, -66.9719947, 8288, 80, 17, 6668.3256, 0000000001),
('27/03/2020', '2:44', 31.026665, 119.910952, 4271, 22, 78, 19051.6134, 0000000001),
('23/04/2020', '4:27', 40.97465, 117.943348, 101, 99, 54, 43168.6822, 0000000001),
('26/08/2019', '17:47', 58.1531344, 8.079923, 6619, 16, 68, 1044.797, 0000000001),
('15/11/2019', '8:47', -19.3298294, 47.6849007, 10151, 93, 59, 40239.0697, 0000000001),
('24/05/2020', '23:01', -42.7700601, -65.0306302, 12582, 6, 52, 81586.3165, 0000000001),
('31/05/2020', '15:17', 28.237987, 83.9955879, 10718, 25, 100, 71579.3621, 0000000001),
('16/03/2020', '21:52', 48.015883, 37.80285, 13825, 60, 60, 97665.6497, 0000000001),
('22/12/2019', '20:27', 5.3523231, 100.3573891, 2033, 82, 70, 83519.2981, 0000000001),
('25/05/2020', '19:26', 36.7240776, 51.1141183, 1983, 16, 68, 31260.5368, 0000000001),
('25/05/2020', '15:42', -6.918322, -78.127167, 8318, 6, 41, 73466.1841, 0000000001),
('06/10/2019', '4:33', 17.6891622, -91.7190274, 14647, 81, 54, 634.7575, 0000000001),
('02/07/2019', '10:03', 13.2999, 122.5217, 11470, 52, 45, 30276.7595, 0000000001),
('08/12/2019', '17:16', 51.22999, -101.3565, 13397, 44, 8, 17107.8902, 0000000001),
('05/07/2019', '12:58', 45.7784442, -71.9229466, 821, 2, 26, 66698.1603, 0000000001),
('27/06/2019', '15:07', 13.0748879, 120.7213113, 10557, 3, 1, 58446.526, 0000000001),
('27/08/2019', '23:34', -7.9903162, 113.7365072, 12140, 9, 16, 43573.5369, 0000000001),
('11/09/2019', '5:10', 49.8501369, 21.894173, 7829, 65, 97, 54863.3079, 0000000001),
('20/05/2020', '21:21', 38.308683, 101.588353, 10226, 55, 62, 10913.1314, 0000000001),
('11/04/2020', '6:49', -1.4923925, -78.0024134, 14042, 89, 50, 39347.5741, 0000000001),
('26/03/2020', '15:46', 14.0707852, 120.7601581, 5013, 73, 4, 21113.1855, 0000000001),
('29/11/2019', '10:49', -23.4739979, -53.088539, 2722, 6, 3, 86016.8198, 0000000001),
('19/09/2019', '3:00', 46.349041, 3.556485, 5443, 18, 45, 14287.6488, 0000000001),
('04/02/2020', '10:06', 7.2466086, 16.4346979, 14153, 44, 49, 19103.7205, 0000000001),
('30/06/2019', '22:30', 44.9114638, 15.9259321, 4741, 8, 46, 88146.9006, 0000000001),
('09/11/2019', '8:23', -7.3170603, 109.2891005, 10219, 82, 24, 81821.6447, 0000000001),
('22/09/2019', '1:37', -0.819175, 120.167297, 13924, 5, 10, 75053.1901, 0000000001),
('17/03/2020', '1:29', -20.5842082, -63.8950786, 10451, 74, 79, 25805.1761, 0000000001),
('02/10/2019', '11:17', 45.521519, 3.5276642, 9015, 90, 34, 44172.2005, 0000000001),
('20/06/2019', '11:45', 60.2025952, 24.904004, 10930, 77, 63, 15777.768, 0000000001),
('26/06/2019', '13:00', 20.003169, 110.353972, 6963, 93, 36, 45118.7494, 0000000001),
('28/05/2020', '17:43', 29.289648, 120.241565, 8373, 48, 87, 60503.9475, 0000000001),
('09/03/2020', '9:43', -9.4020529, 34.0195827, 14334, 2, 1, 59074.4694, 0000000001),
('28/11/2019', '0:26', 48.1030253, 102.5606182, 7495, 40, 62, 82661.7846, 0000000001),
('13/05/2020', '22:44', 35.23251, 69.37719, 7027, 30, 62, 53015.8756, 0000000001),
('25/02/2020', '22:00', 46.7530428, -71.2196569, 14523, 12, 61, 34882.2234, 0000000001),
('24/11/2019', '7:19', 14.5514305, 121.0092101, 14183, 54, 62, 94650.3643, 0000000001),
('05/10/2019', '22:16', 27.398759, 116.350531, 7789, 19, 5, 69102.2342, 0000000001),
('02/04/2020', '12:58', 39.749144, 116.143267, 8984, 33, 38, 49489.4653, 0000000001),
('25/03/2020', '9:30', 37.429832, 110.88907, 7189, 63, 80, 62332.8349, 0000000001),
('17/06/2019', '0:28', 49.5931724, 17.1260751, 10105, 79, 35, 39533.4114, 0000000001),
('10/11/2019', '20:55', 0.1156645, 99.9360207, 10167, 13, 8, 42281.0177, 0000000001),
('09/11/2019', '12:25', -15.1471649, -73.3406579, 8164, 61, 58, 98633.9158, 0000000001),
('04/07/2019', '6:31', -10.8531643, -37.1269791, 1566, 34, 26, 9018.8578, 0000000001),
('17/03/2020', '13:08', 37.020948, 122.093267, 1624, 9, 65, 31594.0521, 0000000001),
('20/10/2019', '9:34', 40.1430734, -8.7570417, 13834, 61, 82, 10366.4362, 0000000001),
('11/03/2020', '17:57', 11.5105782, 122.0865444, 397, 36, 1, 45219.2399, 0000000001),
('28/06/2019', '9:54', -8.7476, 116.1921, 9806, 66, 8, 41631.1678, 0000000001),
('16/06/2019', '20:35', 55.6613674, 37.4429397, 5918, 8, 47, 25221.9253, 0000000001),
('26/03/2020', '13:03', 48.7803815, 2.4549884, 6438, 11, 84, 80285.8753, 0000000001),
('29/08/2019', '13:43', 49.8363158, 36.6813123, 11032, 46, 2, 35967.2208, 0000000001),
('23/10/2019', '4:49', 52.5496772, 13.3643415, 6379, 41, 22, 69326.3271, 0000000001),
('20/06/2019', '22:21', 35.237207, 102.827734, 3393, 17, 89, 91023.6826, 0000000001),
('17/04/2020', '22:05', -7.1240121, 111.6049608, 10339, 66, 67, 25821.7305, 0000000001),
('06/07/2019', '10:49', 51.5244042, 5.7576526, 6208, 42, 81, 91797.3021, 0000000001),
('21/12/2019', '22:10', 13.7558622, 7.986535, 14356, 51, 44, 88219.0917, 0000000001),
('19/12/2019', '6:10', -6.956164, 106.7714, 7939, 29, 38, 86469.0036, 0000000001),
('14/06/2019', '13:19', 7.9500846, -75.3594016, 4666, 43, 89, 96552.8247, 0000000001),
('22/03/2020', '12:58', -8.3647935, 124.0857174, 1861, 82, 96, 15475.3004, 0000000001),
('31/05/2020', '6:14', 59.6185698, 54.3310196, 8948, 64, 78, 75091.4409, 0000000023),
('01/06/2020', '6:43', 15.6682977, 120.5003747, 11787, 40, 3, 53838.9712, 0000000023),
('13/07/2019', '22:46', 47.2215999, 5.9675963, 5600, 50, 56, 55978.8854, 0000000023),
('17/07/2019', '4:42', 29.528923, 104.990101, 8820, 56, 32, 28529.8413, 0000000023),
('08/08/2019', '10:35', 52.8874021, 30.0360311, 9622, 99, 80, 43213.766, 0000000023),
('09/04/2020', '2:31', 36.0917434, 140.1139616, 6979, 1, 10, 51900.8435, 0000000023),
('17/12/2019', '2:00', 30.909922, 115.943284, 1732, 11, 43, 28410.3556, 0000000023),
('03/11/2019', '17:24', 46.2506074, 5.1133935, 6221, 71, 64, 48214.0037, 0000000023),
('11/04/2020', '10:47', 29.185721, 117.468181, 1937, 44, 55, 66268.6912, 0000000023),
('15/08/2019', '15:36', 46.6328109, -1.811786, 13097, 84, 66, 98002.9163, 0000000023),
('04/12/2019', '5:31', -8.3647581, 123.2162159, 5039, 89, 6, 28948.3324, 0000000023),
('07/04/2020', '4:13', -15.4979257, -67.8823146, 7057, 82, 70, 11006.6422, 0000000023),
('22/10/2019', '4:23', -8.933278, -77.42086, 9215, 91, 36, 68626.8609, 0000000001),
('31/01/2020', '8:03', -7.380316, 107.9917034, 8128, 15, 23, 49779.9617, 0000000001),
('25/12/2019', '9:46', 59.8581364, 17.6545551, 14421, 58, 39, 63321.2241, 0000000001),
('06/10/2019', '18:30', -6.2852298, 106.7813363, 9341, 25, 97, 80640.0132, 0000000001),
('04/10/2019', '19:11', 30.6701145, 31.5883709, 4421, 52, 51, 97609.4213, 0000000019),
('13/10/2019', '19:13', 36.86278, 66.16656, 2823, 43, 100, 11982.4346, 0000000020),
('26/08/2019', '6:55', 19.268942, -99.1825465, 1047, 94, 33, 8721.4456, 0000000020),
('07/02/2020', '11:31', 13.0748879, 120.7213113, 13390, 14, 10, 45033.325, 0000000020),
('11/03/2020', '0:58', 14.84276, -88.493797, 5052, 68, 24, 52941.1505, 0000000014),
('26/06/2019', '9:20', 6.8276228, -5.2893433, 9641, 29, 36, 66334.1034, 0000000015),
('15/03/2020', '20:33', 32.0607438, 45.2384164, 1933, 85, 49, 73643.1295, 0000000029),
('23/08/2019', '11:56', 29.39441, 113.016085, 1748, 96, 67, 65369.9585, 0000000029),
('23/04/2020', '2:40', 21.6495224, -79.2451149, 12559, 3, 42, 9893.6134, 0000000023),
('31/01/2020', '5:31', 33.8430437, 44.5219358, 13725, 62, 81, 73321.0274, 0000000030),
('23/03/2020', '8:45', 25.461545, 118.31969, 8984, 74, 34, 91427.0177, 0000000030),
('07/08/2019', '23:01', 5.5298168, -0.705779, 13397, 76, 87, 66421.9227, 0000000017),
('13/05/2020', '3:24', 32.20125, 35.03416, 7500, 93, 36, 56277.5349, 0000000017),
('13/08/2019', '22:33', 1.5316053, -77.4128193, 4103, 25, 77, 20390.8496, 0000000017),
('08/05/2020', '13:18', 51.370484, 22.3461706, 2079, 20, 94, 94288.6362, 0000000025),
('25/09/2019', '4:05', 52.08234, 5.1175293, 7150, 36, 38, 1005.4884, 0000000024),
('11/04/2020', '0:49', -8.5261, 121.9715, 7184, 5, 89, 85576.019, 0000000024),
('14/07/2019', '5:35', 9.4387872, -70.490794, 8101, 86, 62, 95214.0801, 0000000022),
('22/01/2020', '9:59', 14.631218, 121.0628238, 4253, 93, 36, 82470.22, 0000000021),
('14/01/2020', '10:59', -8.6332229, 121.5598345, 12065, 24, 6, 56912.7902, 0000000021),
('02/08/2019', '19:13', 3.2093353, 101.6716295, 1158, 75, 97, 64964.3306, 0000000018),
('13/11/2019', '1:39', 54.3886617, -1.555363, 4096, 27, 94, 38917.8871, 0000000014),
('28/01/2020', '0:56', 2.9182648, 101.6982899, 12437, 12, 56, 13929.4244, 0000000005),
('17/08/2019', '16:26', 24.1092009, 117.1199596, 4103, 43, 13, 61054.2542, 0000000006),
('13/11/2019', '10:50', 33.7654607, -84.38709, 4725, 87, 82, 99431.5614, 0000000008),
('01/04/2020', '16:21', 49.1931313, -0.3907558, 7183, 61, 73, 46381.8006, 0000000007),
('21/02/2020', '2:28', 13.794468, 100.327706, 2603, 25, 98, 36745.5437, 0000000002),
('23/10/2019', '7:36', 25.038296, 102.664376, 6611, 48, 12, 36086.4982, 0000000009),
('16/09/2019', '5:24', 35.748233, 114.297201, 8765, 92, 62, 65855.2262, 00000000015),
('29/10/2019', '21:57', 39.026091, -95.7226884, 12056, 98, 49, 16230.8527, 0000000014),
('17/07/2019', '7:36', 19.1945799, 101.483498, 1705, 1, 78, 2871.4313, 0000000015),
('25/05/2020', '3:09', 57.6597922, 12.0140077, 257, 12, 89, 97425.758, 0000000014),
('07/06/2020', '13:01', -8.8315362, 115.1264522, 4968, 53, 76, 81739.8328, 0000000034),
('21/05/2020', '23:52', 6.5390358, 21.9910008, 6067, 53, 71, 31107.9319, 0000000024),
('07/08/2019', '7:39', 58.295323, 57.6968252, 2090, 10, 91, 33247.3342, 0000000024),
('14/11/2019', '11:53', -22.38146, 27.59223, 4567, 78, 3, 97547.419, 0000000034),
('19/12/2019', '21:07', 35.5673752, 10.8084675, 7496, 48, 83, 17643.5242, 0000000012),
('07/12/2019', '22:21', 45.4002994, 29.5961736, 1430, 58, 39, 25270.6801, 0000000007),
('25/12/2019', '17:46', 44.0854864, 43.1007634, 1750, 92, 81, 90034.9529, 0000000004);

SET DATEFORMAT DMY
INSERT INTO tblEmployee
VALUES 
('Management', 'Director', 225000, '26/09/2019', NULL),
('Management', 'Administrative Executive', 124500, '01/03/2015', NULL),
('Management', 'Technician', 110000, '11/12/2015', NULL),
('Management', 'Salesperson', 178100, '30/05/2018', NULL),
('Management', 'Salesperson', 154100, '01/10/2018', NULL),
('Sales', 'Salesperson', 225000, '26/09/2019', NULL),
('Sales', 'Salesperson', 76000, '04/09/2019', NULL),
('Sales', 'Salesperson', 59000, '01/06/2017', NULL),
('Sales', 'Salesperson', 67000, '12/09/2014', NULL),
('Sales', 'Salesperson', 67000, '22/08/2019', NULL),
('Contracts', 'Administrative Executive', 101000, '19/01/2020', NULL),
('Contracts', 'Administrative Executive', 98000, '21/07/2016', NULL),
('Contracts', 'Administrative Executive', 101000, '19/01/2020', NULL),
('Contracts', 'Administrative Executive', 98000, '21/07/2016', NULL),
('Contracts', 'Administrative Executive', 101000, '15/02/2020', NULL),
('Technical', 'Technician', 69000, '16/10/2016', NULL),
('Technical', 'Technician', 69000, '16/10/2016', NULL),
('Technical', 'Technician', 65000, '06/02/2019', NULL),
('Technical', 'Technician', 77000, '30/11/2018', NULL),
('Technical', 'Administration', 49000, '31/01/2019', NULL);

INSERT INTO tblAdministrativeExecutive
VALUES 
(00002),
(00011),
(00012),
(00013),
(00014),
(00015);

INSERT INTO tblSalesperson
VALUES 
(00004, 14),
(00005, 59),
(00006, 67),
(00007, 104),
(00008, 97),
(00009, 34),
(00010, 178);

INSERT INTO tblDirector
VALUES 
(00001);

INSERT INTO tblTechnician
VALUES 
(00003, 'Expert'),
(00016, 'Intermediate'),
(00017, 'Beginner'),
(00018, 'Intermediate'),
(00019, 'Advanced'),
(00020, 'Trainee');

INSERT INTO tblMaintenanceSchedule
VALUES 
('28/08/2019', '5644494068', '06/12/2019', 0000000001, 00016, 0000000001),
('19/10/2019', '5119950698', '22/05/2020', 0000000002, 00017, 0000000002),
('04/04/2020', '2306656891', '01/09/2019', 0000000003, 00018, 0000000003),
('09/04/2020', '6563271814', '08/11/2019', 0000000004, 00019, 0000000004),
('02/05/2020', '1158680738', '24/02/2020', 0000000005, 00017, 0000000005),
('15/12/2019', '9020197283', '22/06/2019', 0000000006, 00019, 0000000006),
('13/07/2019', '3467408250', '19/10/2019', 0000000007, 00016, 0000000007),
('18/09/2019', '5956675018', '22/06/2019', 0000000008, 00016, 0000000008),
('14/02/2020', '6354856268', '30/10/2019', 0000000009, 00018, 0000000009),
('09/05/2020', '6291897936', '10/08/2019', 0000000010, 00018, 0000000010),
('17/02/2020', '5636668315', '02/03/2020', 0000000001, 00017, 0000000011),
('13/12/2019', '1874360155', '05/01/2020', 0000000002, 00019, 0000000012),
('01/06/2020', '8790048539', '27/07/2019', 0000000003, 00016, 0000000013),
('20/08/2019', '3707685735', '10/11/2019', 0000000004, 00019, 0000000014),
('29/05/2020', '4301757351', '23/12/2019', 0000000005, 00016, 0000000015),
('19/06/2019', '6098042421', '21/11/2019', 0000000006, 00016, 0000000016),
('29/01/2020', '2604094847', '03/04/2020', 0000000007, 00017, 0000000017),
('18/07/2019', '8132699523', '21/04/2020', 0000000008, 00018, 0000000018),
('13/02/2020', '4357669236', '04/09/2019', 0000000009, 00016, 0000000019),
('22/02/2020', '8448116273', '21/05/2020', 0000000010, 00018, 0000000020);

SET DATEFORMAT DMY
INSERT INTO tblDevice
VALUES 
('Boyle-Crist', '27/01/2020', '31/10/2019', 0000000001),
('Ziemann-Bogan', '03/10/2019', '23/01/2020', 0000000002),
('Hudson Group', '23/08/2019', '20/10/2019', 0000000003),
('Olson-Hoeger', '19/01/2020', '15/04/2020', 0000000004),
('Wisoky-Torp', '04/12/2019', '15/10/2019', 0000000005),
('Smith, Dare and Predovic', '16/05/2020', '24/03/2020', 0000000006),
('Christiansen-Aufderhar', '30/08/2019', '14/11/2019', 0000000007),
('Ferry LLC', '17/04/2020', '09/07/2019', 0000000008),
('Gaylord, Stokes and Armstrong', '09/10/2019', '14/06/2019', 0000000009),
('Mertz and Sons', '17/12/2019', '02/09/2019', 0000000010),
('Considine, Bauch and Mann', '05/04/2020', '18/04/2020', 0000000001),
('Boyle, Rice and Halvorson', '01/12/2019', '19/01/2020', 0000000002),
('Bradtke, Parisian and Hyatt', '16/04/2020', '08/08/2019', 0000000003),
('Sipes-Glover', '25/07/2019', '23/07/2019', 0000000004),
('Streich-Jacobs', '14/01/2020', '10/04/2020', 0000000005),
('Erdman LLC', '21/02/2020', '27/04/2020', 0000000006),
('Ortiz, Dach and Fay', '22/05/2020', '28/02/2020', 0000000007),
('Breitenberg, Bergstrom', '27/04/2020', '30/03/2020', 0000000008),
('Hackett Inc', '07/05/2020', '13/08/2019', 0000000009),
('Ernser and Sons', '20/04/2020', '24/04/2020', 0000000010);

INSERT INTO tblDiagnose
VALUES 
('09/05/2020', '88092735313931814346', 0000000001, 00001),
('09/04/2020', '38083020049094288610', 0000000002, 00002),
('08/05/2020', '91484689926160494725', 0000000003, 00003),
('10/06/2020', '33991793995375562571', 0000000004, 00004),
('06/05/2020', '26241203868075272898', 0000000005, 00005),
('10/01/2020', '61839326209354789329', 0000000006, 00006),
('22/03/2020', '66360768943375566701', 0000000007, 00007),
('28/11/2019', '81342165597498045475', 0000000008, 00008),
('16/11/2019', '81452906160013083634', 0000000009, 00009),
('15/01/2020', '93849664092705187400', 0000000010, 00010),
('18/03/2020', '94339707313541779795', 0000000011, 00011),
('15/08/2019', '43600439941527165057', 0000000012, 00012),
('19/09/2019', '89925485606020261625', 0000000015, 00013),
('02/05/2020', '38602468686332964879', 0000000014, 00015),
('15/08/2019', '51815421741926299355', 0000000013, 00014),
('11/04/2020', '36235628932248483277', 0000000016, 00016),
('03/08/2019', '64120937487600381132', 0000000017, 00017),
('20/09/2019', '27848392050753903039', 0000000018, 00018),
('27/10/2019', '25256084151533326173', 0000000019, 00019),
('18/10/2019', '94457089580884043892', 0000000020, 00020);

INSERT INTO tblSubscription
VALUES 
('2', '4', '18/10/2019', 1000000001),
('3', '2', '02/05/2020', 1000000002),
('4', '1', '28/11/2019', 1000000003),
('2', '3', '10/10/2019', 1000000004),
('4', '2', '19/11/2020', 1000000005),
('3', '2', '18/03/2019', 1000000006),
('2', '5', '10/07/2019', 1000000007),
('2', '5', '11/01/2019', 1000000008),
('1', '4', '12/02/2020', 1000000009),
('2', '2', '18/10/2019', 1000000010),
('2', '1', '20/01/2019', 1000000011),
('1', '1', '18/05/2020', 1000000012),
('1', '3', '18/10/2019', 1000000013),
('1', '4', '12/06/2016', 1000000014),
('1', '4', '19/12/2020', 1000000015),
('1', '3', '15/04/2019', 1000000016),
('1', '5', '18/06/2019', 1000000017),
('1', '2', '24/07/2018', 1000000018),
('1', '1', '22/09/2016', 1000000020);

INSERT INTO tblDataboxMove
VALUES 
('04/01/2020', '18:25', 0000000001, 0000000004),
('19/11/2019', '1:55', 0000000002, 0000000003),
('19/11/2019', '10:28', 0000000003, 0000000002),
('22/03/2020', '2:12', 0000000004, 0000000001),
('10/09/2019', '23:03', 0000000005, 0000000008),
('26/04/2020', '9:08', 0000000006, 0000000005),
('03/08/2019', '4:58', 0000000007, 0000000006),
('29/11/2019', '2:15', 0000000008, 0000000007),
('16/09/2019', '5:19', 0000000009, 0000000001),
('30/03/2020', '7:26', 0000000010, 0000000002),
('08/09/2019', '3:16', 0000000011, 0000000005),
('01/10/2019', '18:41', 0000000012, 0000000007),
('25/09/2019', '0:47', 0000000013, 0000000004),
('16/02/2020', '1:17', 0000000014, 0000000004),
('17/02/2020', '19:03', 0000000015, 0000000006),
('30/07/2019', '8:42', 0000000016, 0000000005),
('15/01/2020', '19:46', 0000000017, 0000000004),
('10/10/2019', '22:14', 0000000018, 0000000003),
('31/10/2019', '23:36', 0000000019, 0000000002),
('15/12/2019', '11:29', 0000000020, 0000000001);

INSERT INTO tblLiveStreamControl
VALUES 
('04/01/2020', '18:25', 0000000001, 0000000004),
('19/11/2019', '1:55', 0000000002, 0000000003),
('19/11/2019', '10:28', 0000000003, 0000000002),
('22/03/2020', '2:12', 0000000004, 0000000001),
('10/09/2019', '23:03', 0000000005, 0000000008),
('26/04/2020', '9:08', 0000000006, 0000000005),
('03/08/2019', '4:58', 0000000007, 0000000006),
('29/11/2019', '2:15', 0000000008, 0000000007),
('16/09/2019', '5:19', 0000000009, 0000000001),
('30/03/2020', '7:26', 0000000010, 0000000002),
('08/09/2019', '3:16', 0000000011, 0000000005),
('01/10/2019', '18:41', 0000000012, 0000000007),
('25/09/2019', '0:47', 0000000013, 0000000004),
('16/02/2020', '1:17', 0000000014, 0000000004),
('17/02/2020', '19:03', 0000000015, 0000000006),
('30/07/2019', '8:42', 0000000016, 0000000005),
('15/01/2020', '19:46', 0000000017, 0000000004),
('10/10/2019', '22:14', 0000000018, 0000000003),
('31/10/2019', '23:36', 0000000019, 0000000002),
('15/12/2019', '11:29', 0000000020, 0000000001);

INSERT INTO tblAccessLevel
VALUES 
(0, 0000000001, 0000000004),
(1, 0000000002, 0000000003),
(0, 0000000003, 0000000002),
(1, 0000000004, 0000000001),
(1, 0000000005, 0000000008),
(1, 0000000006, 0000000005),
(1, 0000000007, 0000000006),
(1, 0000000008, 0000000007),
(1, 0000000009, 0000000001),
(0, 0000000010, 0000000002),
(0, 0000000011, 0000000005),
(0, 0000000012, 0000000007),
(0, 0000000013, 0000000004),
(1, 0000000014, 0000000004),
(1, 0000000015, 0000000006),
(1, 0000000016, 0000000005),
(1, 0000000017, 0000000004),
(1, 0000000018, 0000000003),
(1, 0000000019, 0000000002);

INSERT INTO tblSale
VALUES 
('04/01/2020', 0000000001, 00005),
('19/11/2019', 0000000002, 00009),
('19/11/2019', 0000000003, 00007),
('22/03/2020', 0000000004, 00006),
('10/09/2019', 0000000005, 00008),
('26/04/2020', 0000000006, 00005),
('03/08/2019', 0000000007, 00008),
('29/11/2019', 0000000008, 00007),
('16/09/2019', 0000000009, 00008),
('30/03/2020', 0000000010, 00007),
('08/09/2019', 0000000011, 00006),
('01/10/2019', 0000000012, 00004),
('25/09/2019', 0000000013, 00005),
('16/02/2020', 0000000014, 00004),
('17/02/2020', 0000000015, 00010),
('30/07/2019', 0000000016, 00010),
('15/01/2020', 0000000017, 00008),
('10/10/2019', 0000000018, 00007),
('31/10/2019', 0000000019, 00005);

INSERT INTO tblContract
VALUES 
('04/01/2020', 00001, 00011),
('19/11/2019', 00002, 00015),
('19/11/2019', 00003, 00011),
('22/03/2020', 00004, 00013),
('10/09/2019', 00005, 00012),
('26/04/2020', 00006, 00013),
('03/08/2019', 00007, 00011),
('29/11/2019', 00008, 00014),
('16/09/2019', 00009, 00011),
('30/03/2020', 00010, 00014),
('08/09/2019', 00011, 00015),
('01/10/2019', 00012, 00002),
('25/09/2019', 00013, 00012),
('16/02/2020', 00014, 00011),
('17/02/2020', 00015, 00011),
('30/07/2019', 00016, 00012),
('15/01/2020', 00017, 00015),
('10/10/2019', 00018, 00014),
('31/10/2019', 00019, 00013),
('15/12/2019', 00020, 00015);

INSERT INTO tblSubscriptionContract
VALUES 
('04/01/2020', 00001, 0000000001),
('19/11/2019', 00002, 0000000002),
('19/11/2019', 00003, 0000000003),
('22/03/2020', 00004, 0000000004),
('10/09/2019', 00005, 0000000005),
('26/04/2020', 00006, 0000000006),
('03/08/2019', 00007, 0000000007),
('29/11/2019', 00008, 0000000008),
('16/09/2019', 00009, 0000000009),
('30/03/2020', 00010, 0000000010),
('08/09/2019', 00011, 0000000011),
('01/10/2019', 00012, 0000000012),
('25/09/2019', 00013, 0000000013),
('16/02/2020', 00014, 0000000014),
('17/02/2020', 00015, 0000000015),
('30/07/2019', 00016, 0000000016),
('15/01/2020', 00017, 0000000017),
('10/10/2019', 00018, 0000000018),
('31/10/2019', 00019, 0000000019);

INSERT INTO tblCover
VALUES 
(00001, 0000000001),
(00002, 0000000002),
(00003, 0000000003),
(00004, 0000000004),
(00005, 0000000005),
(00006, 0000000006),
(00007, 0000000007),
(00008, 0000000008),
(00009, 0000000009),
(00010, 0000000010),
(00011, 0000000003),
(00010, 0000000004),
(00001, 0000000005),
(00002, 0000000006),
(00003, 0000000007),
(00004, 0000000008),
(00005, 0000000004),
(00006, 0000000005),
(00007, 0000000001),
(00008, 0000000010);

INSERT INTO tblDataboxZone
VALUES 
(0000000001, 0000000001),
(0000000002, 0000000002),
(0000000003, 0000000003),
(0000000004, 0000000004),
(0000000005, 0000000005),
(0000000006, 0000000006),
(0000000007, 0000000007),
(0000000008, 0000000008),
(0000000009, 0000000009),
(0000000010, 0000000010),
(0000000011, 0000000003),
(0000000010, 0000000004),
(0000000001, 0000000005),
(0000000002, 0000000006),
(0000000003, 0000000007),
(0000000004, 0000000008),
(0000000005, 0000000004),
(0000000006, 0000000005),
(0000000007, 0000000001),
(0000000008, 0000000010);

INSERT INTO tblDiscount
VALUES 
(0.85, 0000000019, 00005),
(1.99, 0000000018, 00006),
(3.00, 0000000017, 00007),
(2.75, 0000000016, 00008),
(1.00, 0000000015, 00009),
(2.20, 0000000014, 00010),
(1.50, 0000000001, 00004),
(0.75, 0000000002, 00005),
(0.99, 0000000003, 00006),
(3.00, 0000000004, 00007),
(2.90, 0000000005, 00008),
(1.40, 0000000006, 00009),
(1.55, 0000000009, 00010);

INSERT INTO tblDataRight
VALUES 
(0000000000000000001, 0000000001),
(0000000000000000002, 0000000001),
(0000000000000000003, 0000000001),
(0000000000000000004, 0000000002),
(0000000000000000005, 0000000002),
(0000000000000000006, 0000000003),
(0000000000000000007, 0000000004),
(0000000000000000008, 0000000007),
(0000000000000000009, 0000000010),
(0000000000000000010, 0000000012),
(0000000000000000011, 0000000001),
(0000000000000000012, 0000000001),
(0000000000000000013, 0000000001),
(0000000000000000014, 0000000002),
(0000000000000000015, 0000000002),
(0000000000000000016, 0000000003),
(0000000000000000017, 0000000004),
(0000000000000000018, 0000000007),
(0000000000000000019, 0000000010),
(0000000000000000020, 0000000012);

INSERT INTO tblLiveStreamRight
VALUES 
(0000000001, 0000000001),
(0000000002, 0000000001),
(0000000003, 0000000001),
(0000000004, 0000000002),
(0000000005, 0000000002),
(0000000006, 0000000003),
(0000000007, 0000000004),
(0000000008, 0000000007),
(0000000009, 0000000010),
(0000000010, 0000000012),
(0000000011, 0000000001),
(0000000012, 0000000001),
(0000000013, 0000000001),
(0000000014, 0000000002),
(0000000015, 0000000002),
(0000000016, 0000000003),
(0000000017, 0000000004),
(0000000018, 0000000007),
(0000000019, 0000000010),
(0000000020, 0000000012);

INSERT INTO tblView
VALUES 
('03/11/2019', '7:01', 0000000004, 0000000000000000101, 1000000011),
('04/12/2019', '4:36', 0000000013, 0000000000000000245, 1000000012),
('28/12/2019', '9:58', 0000000014, 0000000000000000190, 1000000010),
('22/04/2020', '15:48', 0000000007, 0000000000000000085, 1000000005),
('17/03/2020', '17:15', 0000000008, 0000000000000000302, 1000000010),
('01/02/2020', '0:53', 0000000009, 0000000000000000325, 1000000013),
('16/05/2020', '18:17', 0000000015, 0000000000000000287, 1000000014),
('29/09/2019', '4:46', 0000000019, 0000000000000000332, 1000000018),
('07/12/2019', '0:32', 0000000005, 0000000000000000141, 1000000002),
('20/02/2020', '7:38', 0000000005, 0000000000000000321, 1000000014),
('13/10/2019', '20:46', 0000000002, 0000000000000000306, 1000000002),
('23/12/2019', '14:51', 0000000019, 0000000000000000317, 1000000002),
('30/03/2020', '9:35', 0000000008, 0000000000000000276, 1000000020),
('06/06/2020', '19:03', 0000000013, 0000000000000000177, 1000000017),
('10/10/2019', '21:51', 0000000001, 0000000000000000188, 1000000005),
('20/07/2019', '19:42', 0000000007, 0000000000000000166, 1000000008),
('09/01/2020', '5:15', 0000000015, 0000000000000000280, 1000000014),
('04/06/2020', '15:25', 0000000003, 0000000000000000180, 1000000012),
('18/06/2019', '21:15', 0000000019, 0000000000000000187, 1000000003),
('28/11/2019', '19:00', 0000000004, 0000000000000000292, 1000000019);

INSERT INTO tblPayment
VALUES 
(100.00, 'Bank Transfer', '04/01/2020', 0000000001),
(25.00, 'Credit/Debit', '19/11/2019', 0000000002),
(72.50, 'Direct Debit', '19/11/2019', 0000000003),
(59.00, 'Standing Order', '22/03/2020', 0000000004),
(105.00, 'Cheque', '10/09/2019', 0000000005),
(60.00, 'Bank Transfer', '26/04/2020', 0000000006),
(95.00, 'Standing Order', '03/08/2019', 0000000007),
(49.99, 'Bank Transfer', '29/11/2019', 0000000008),
(65.50, 'Direct Debit', '16/09/2019', 0000000009),
(98.00, 'Standing Order', '30/03/2020', 0000000010),
(55.00, 'Credit/Debit', '08/09/2019', 0000000011),
(99.00, 'Standing Order', '01/10/2019', 0000000012),
(110.25, 'Bank Transfer', '25/09/2019', 0000000013),
(56.00, 'Credit/Debit', '16/02/2020', 0000000014),
(75.99, 'Direct Debit', '17/02/2020', 0000000015),
(160.00, 'Bank Transfer', '30/07/2019', 0000000016),
(85.75, 'Standing Order', '15/01/2020', 0000000017),
(35.00, 'Credit/Debit', '10/10/2019', 0000000018),
(75.00, 'Standing Order', '31/10/2019', 0000000019);

INSERT INTO tblPart
VALUES 
('Quo Lux', 'Stand-alone empowering capability', 7),
('Subin', 'Cross-group regional function', 12),
('Zathin', 'Customizable human-resource contingency', 14),
('Aerified', 'Mandatory context-sensitive adapter', 4),
('Sub-Ex', 'Total optimal artificial intelligence', 14),
('Latlux', 'Monitored client-server project', 10),
('Lotstring', 'Universal local orchestration', 15),
('Kanlam', 'Extended zero administration pricing structure', 8),
('Sonsing', 'Mandatory asynchronous definition', 7),
('Quo Lux', 'Cloned 24 hour flexibility', 11),
('Mat Lam Tam', 'Reactive 24 hour capability', 20),
('Stronghold', 'Face to face local challenge', 18),
('Sonsing', 'Managed motivating database', 2),
('Y-Solowarm', 'Reduced static intranet', 1),
('Subin', 'Function-based needs-based capability', 16),
('Konklab', 'Implemented needs-based forecast', 11),
('Vagram', 'Reduced object-oriented initiative', 11),
('Vagram', 'Upgradable uniform ability', 8),
('Sonsing', 'Function-based mobile circuit', 4),
('Overhold', 'Quality-focused transitional synergy', 6),
('Sonsing', 'Operative coherent help-desk', 15),
('Zaam-Dox', 'Switchable system-worthy process improvement', 8),
('Otcom', 'Automated dynamic synergy', 8),
('Trippledex', 'Self-enabling bifurcated intranet', 7),
('Overhold', 'Ergonomic modular portal', 8),
('Zontrax', 'Decentralized maximized core', 6),
('Transcof', 'Compatible context-sensitive local area network', 18),
('Otcom', 'Enterprise-wide contextually-based implementation', 19),
('Gembucket', 'Pre-emptive composite algorithm', 15),
('Viva', 'Extended mobile interface', 18);

INSERT INTO tblMaintenance
VALUES 
('0940949059', 00010, 0000000001, 00024),
('8910592583', 00014, 0000000002, 00014),
('2744873659', 00016, 0000000003, 00017),
('8654028017', 00014, 0000000004, 00013),
('1012494802', 00013, 0000000005, 00013),
('2492010295', 00015, 0000000006, 00024),
('8307056675', 00012, 0000000007, 00016),
('5104929434', 00015, 0000000008, 00009),
('1291285474', 00012, 0000000009, 00016),
('8468840939', 00015, 0000000010, 00009),
('3355786594', 00014, 0000000011, 00017),
('7769586062', 00010, 0000000012, 00006),
('6706467553', 00014, 0000000013, 00007),
('6214227206', 00013, 0000000014, 00005),
('5023213927', 00014, 0000000015, 00008),
('3920343700', 00012, 0000000016, 00014),
('2241056103', 00011, 0000000017, 00003),
('7720900073', 00016, 0000000018, 00011),
('4798751774', 00014, 0000000019, 00014),
('5601774978', 00013, 0000000020, 00011);

INSERT INTO tblZoneConfigurationPart
VALUES 
('Jungle', '2', '4', '29'),
('Forest', '1', '26', '21'),
('Savannah', '14', '10', '7'),
('Ice/Snow', '15', '3', '13'),
('Mountain', '5', '12', '25'),
('Desert', '9', '8', '1'),
('Urban', '16', '19','6');

INSERT INTO tblNextOfKin
VALUES 
('Berty Kleiner', '(366) 9090942', 'Wife', 00001, NULL),
('Denis Crummy', '(790) 8109722', 'Husband', NULL, 0000000001),
('Munroe Bohlens', '(383) 9856326', 'Partner', 00002, NULL),
('Kelcy Greatorex', '(929) 3496166', 'Mother', 00003, NULL),
('Lucias Milam', '(615) 6160482', 'Wife', 00004, NULL),
('Pierce Pirrey', '(385) 7439347', 'Husband', 00005, NULL),
('Austin Stripling', '(531) 4946522', 'Son', 00006, NULL),
('Artemas Jambrozek', '(747) 9819425', 'Friend', 00007, NULL),
('Malissia Arunowicz', '(549) 9601580', 'Partner', 00008, NULL),
('Tracey Roberds', '(445) 6939499', 'Relative', 00009, NULL),
('Tilda Coade', '(948) 1847684', 'Parent', 00010, NULL),
('Malinda Jachimak', '(224) 9164227', 'Daughter', 00011, NULL),
('Nikki Gantzman', '(221) 3789846', 'Auntie', 00012, NULL),
('Herman Rose', '(455) 8938790', 'Relative', 00013, NULL),
('Orland Sowden', '(136) 8473458', 'Wife', 00014, NULL),
('Monte Jullian', '(463) 1672858', 'Husband', 00015, NULL),
('Katey Clutterbuck', '(642) 1220249', 'Family Friend', 00016, NULL),
('Dan Stringman', '(112) 8366650', 'Boyfriend', 00017, NULL),
('Creigh Peddar', '(908) 6610559', 'Husband', 00018, NULL),
('Birch Ellacott', '(392) 6012648', 'Girlfriend', 00019, NULL),
('Trip Goodman', '(429) 1400559', 'Wife', 00020, NULL),
('Roz Marco', '(500) 7806308', 'Housemate', NULL, 0000000002),
('Bamby Stepto', '(864) 1600342', 'Landlord', NULL, 0000000003),
('Egor Sutlieff', '(778) 3264953', 'Wife', NULL, 0000000004),
('Joli Coddrington', '(407) 6708832', 'Partner', NULL, 0000000005),
('Barby Chessill', '(221) 3739342', 'Partner', NULL, 0000000006),
('Kale Tipens', '(893) 6969344', 'Partner', NULL, 0000000007),
('Claresta Pitkeathly', '(804) 1009146', 'Partner', NULL, 0000000008),
('Ernestine Gianuzzi', '(901) 4510683', 'Partner', NULL, 0000000009),
('Delcine Botley', '(391) 1227679', 'Partner', NULL, 0000000010);

INSERT INTO tblSupplier
VALUES 
('Dynex Capital, Inc.', 0000000001, 'Briano Olive', 'bolive0@elpais.com', '(880) 2356160'),
('Blackrock MuniYield', 0000000002, 'Joeann Iacovuzzi', 'jiacovuzzi1@usnews.com', '(110) 2367233'),
('WMIH Corp.', 0000000003, 'Osborne Chrstine', 'ochrstine2@shareasale.com', '(359) 4143006'),
('PetMed Express', 0000000004, 'Erskine Skip', 'eskip3@deviantart.com', '(714) 2729765'),
('VALE S.A.', 0000000005, 'Mickie Chatel', 'mchatel4@house.gov', '(762) 9198099'),
('Yingli Green Energy', 0000000006, 'Hayden Haselden', 'hhaselden5@joomla.org', '(774) 3980991'),
('RiceBran Technologies', 0000000007, 'Bea Revey', 'brevey6@livejournal.com', '(838) 1430185'),
('Southern California', 0000000008, 'Skip Southouse', 'ssouthouse7@bbc.co.uk', '(697) 6273534'),
('Renren Inc.', 0000000009, 'Haydon Tofpik', 'htofpik8@nasa.gov', '(189) 7852648'),
('Noble Energy Inc.', 0000000010, 'Jarid Paolazzi', 'jpaolazzi9@lycos.com', '(654) 3483649'),
('Carver Bancorp, Inc.', 0000000011, 'Kalvin Janisson', 'kjanissona@usatoday.com', '(866) 7965461'),
('Akorn, Inc.', 0000000012, 'Vyky Tizard', 'vtizardb@usa.gov', '(733) 5392954'),
('Fair Isaac Corporation', 0000000013, 'Beverie McKew', 'bmckewc@netscape.com', '(586) 9437424'),
('Entergy New Orleans', 0000000014, 'Susanna Kornilyev', 'skornilyevd@abc.net.au', '(567) 4877183'),
('Easterly Acquisition', 0000000015, 'Paulie Loutheane', 'ploutheanee@instagram.com', '(523) 6914670'),
('Legg Mason Low Ltd', 0000000016, 'Weidar Gindghill', 'wgindghillf@phoca.cz', '(835) 4451994'),
('Advent Claymore Ltd', 0000000017, 'Natassia Warcup', 'nwarcupg@joomla.org', '(119) 5956972'),
('Invesco Municipal Ltd', 0000000018, 'Mattie Winslet', 'mwinsleth@alexa.com', '(732) 4882817'),
('NextEra Energy, Inc.', 0000000019, 'Reilly Shippey', 'rshippeyi@forbes.com', '(437) 4193602'),
('Aqua America, Inc.', 0000000020, 'Albertine Gribben', 'agribbenj@yelp.com', '(241) 9309767'),
('Nuveen Core Equity', 0000000021, 'Joelle Ianson', 'jiansonk@sfgate.com', '(654) 9641932'),
('Highland/iBoxx', 0000000022, 'Gideon Osgarby', 'gosgarbyl@wikia.com', '(889) 3396285'),
('Basic Energy', 0000000023, 'Bo Philpot', 'bphilpotm@washington.edu', '(235) 4793586'),
('Berkshire Hathaway', 0000000024, 'Diane-marie Dilliway', 'ddilliwayn@youtu.be', '(605) 6890209'),
('Gildan Activewear', 0000000025, 'Annabel Stout', 'astouto@163.com', '(911) 6380140');

INSERT INTO tblBusinessVenue
VALUES 
('Office', 0000000001, '(820) 5883815'),
('Headquarters', 0000000002, '(403) 8957786'),
('Store', 0000000003, '(646) 1587054'),
('Store', 0000000004, '(636) 3623305'),
('Office', 0000000005, '(391) 4979770'),
('Stall', 0000000006, '(571) 7341293'),
('Store', 0000000007, '(578) 1999420'),
('Store', 0000000008, '(266) 6044320'),
('Stall', 0000000009, '(613) 4669886'),
('Store', 0000000010, '(807) 1456981');

INSERT INTO tblAttendance
VALUES 
(00001, 1000000008, NULL, NULL),
(00001, NULL, 00001, NULL),
(00002, NULL, NULL, 00001),
(00002, NULL, NULL, 00002),
(00003, NULL, NULL, 00003),
(00003, NULL, NULL, 00004),
(00004, NULL, NULL, 00005),
(00004, NULL, NULL, 00006),
(00005, NULL, NULL, 00007),
(00006, NULL, NULL, 00008),
(00005, NULL, 00002, NULL),
(00006, 1000000006, NULL, NULL),
(00007, NULL, 00003, NULL),
(00007, 1000000007, NULL, NULL),
(00008, NULL, 00004, NULL),
(00008, 1000000001, NULL, NULL),
(00009, 1000000002, NULL, NULL),
(00009, 1000000003, NULL, NULL),
(00010, 1000000004, NULL, NULL),
(00010, 1000000005, NULL, NULL);

INSERT INTO tblPurchaseOrder
VALUES 
(00016, 00001, 00001, 10),
(00016, 00002, 00002, 150),
(00017, 00004, 00003, 5),
(00017, 00005, 00004, 7),
(00018, 00006, 00005, 15),
(00018, 00007, 00006, 45),
(00019, 00009, 00007, 30),
(00019, 00009, 00008, 5),
(00020, 00002, 00009, 10),
(00020, 00020, 00010, 10),
(00016, 00013, 00011, 1),
(00016, 00015, 00012, 2),
(00017, 00016, 00013, 25),
(00017, 00018, 00014, 70),
(00018, 00018, 00015, 80),
(00018, 00019, 00016, 95),
(00019, 00021, 00017, 15),
(00019, 00022, 00018, 10),
(00020, 00004, 00019, 2),
(00020, 00003, 00020, 10);

INSERT INTO tblSupply
VALUES 
('4A033B1', '02/06/2020', 00001, 00001),
('BU080ZZ', '24/04/2020', 00002, 00002),
('0RP13AZ', '18/04/2020', 00004, 00003),
('0WHR3YZ', '13/07/2019', 00005, 00004),
('0D1B87H', '28/08/2019', 00006, 00005),
('0SWC09Z', '17/01/2020', 00007, 00006),
('0DW68DZ', '02/04/2020', 00009, 00007),
('0T160J6', '23/10/2019', 00009, 00008),
('0JR90KZ', '19/11/2019', 00002, 00009),
('04760Z6', '08/05/2020', 00020, 00010),
('06B13ZZ', '09/10/2019', 00013, 00011),
('0J970ZX', '09/01/2020', 00015, 00012),
('09B88ZZ', '13/02/2020', 00016, 00013),
('0X060KZ', '14/09/2019', 00018, 00014),
('03130J9', '18/01/2020', 00018, 00015),
('0K574ZZ', '22/04/2020', 00019, 00016),
('0P9N0ZZ', '17/12/2019', 00021, 00017),
('06RJ47Z', '09/05/2020', 00022, 00018),
('2W31X3Z', '15/11/2019', 00004, 00019),
('079L00Z', '21/12/2019', 00003, 00020);

INSERT INTO tblPartDatabox
VALUES 
(0000000094, 00019),
(0000000062, 00025),
(0000000034, 00008),
(0000000004, 00017),
(0000000058, 00006),
(0000000032, 00002),
(0000000072, 00021),
(0000000010, 00008),
(0000000021, 00025),
(0000000034, 00002),
(0000000100, 00003),
(0000000065, 00009),
(0000000074, 00007),
(0000000066, 00003),
(0000000061, 00003),
(0000000068, 00006),
(0000000059, 00022),
(0000000007, 00016),
(0000000034, 00005),
(0000000098, 00007),
(0000000099, 00011),
(0000000038, 00012),
(0000000042, 00002),
(0000000050, 00015),
(0000000015, 00005),
(0000000095, 00004),
(0000000078, 00013),
(0000000099, 00024),
(0000000052, 00010),
(0000000040, 00022),
(0000000073, 00010),
(0000000093, 00008),
(0000000087, 00016),
(0000000005, 00001),
(0000000035, 00014),
(0000000065, 00021),
(0000000060, 00010),
(0000000011, 00020),
(0000000063, 00012),
(0000000058, 00012),
(0000000041, 00003),
(0000000023, 00022),
(0000000093, 00011),
(0000000096, 00009),
(0000000023, 00001),
(0000000011, 00007),
(0000000008, 00018),
(0000000091, 00023),
(0000000014, 00014),
(0000000059, 00019);

INSERT INTO tblAccount
VALUES 
('Clémence', 'Filochov', 0000000001, 'lstowes@simplemachines.org', '936-192-7628', '7nI8gb89EmP', 1000000001, NULL, NULL, NULL),
('Maëlle', 'Curnnok', 0000000002, 'acalvardt@ebay.co.uk', '730-341-7292', '5AMm65XEpY', 1000000002, NULL, NULL, NULL),
('Yè', 'Pullin', 0000000003, 'dyeendu@skype.com', '202-115-9829', 'bh759uj', 1000000003, NULL, NULL, NULL),
('Léonore', 'Melsome', 0000000004, 'mmilesopv@aboutads.info', '763-524-9415', 'abu08RTF', 1000000004, NULL, NULL, NULL),
('Naéva', 'Simyson', 0000000005, 'mfranciottiw@multiply.com', '127-300-4459', 'V05O0l', 1000000005, NULL, NULL, NULL),
('Maïté', 'Swindle', 0000000006, 'szuckerx@deviantart.com', '135-474-0974', 'Hgcd5y5Tv', 1000000006, NULL, NULL, NULL),
('Bérénice', 'Imesen', 0000000007, 'ppeyzery@google.de', '729-482-6102', 'SHe6FXr7LE', 1000000007, NULL, NULL, NULL),
('Maï', 'Baton', 0000000008, 'bsedmanz@dedecms.com', '577-243-8888', 'GKTc8NPIIxvh', 1000000008, NULL, NULL, NULL),
('Miléna', 'Corcut', 0000000009, 'dcowoppe10@noaa.gov', '800-797-8638', 'CHBWfB4Hr', 1000000009, NULL, NULL, NULL),
('Françoise', 'Jirek', 000000001, 'njay11@rediff.com', '674-305-3867', 'TW8S3vsRf', 1000000010, NULL, NULL, NULL),
('Léandre', 'Belward', 0000000011, 'aloiseau12@vistaprint.com', '113-686-2134', 'wn9uOjyvs', 1000000011, NULL, NULL, NULL),
('Médiamass', 'Cancelier', 0000000012, 'varrigucci13@sun.com', '246-176-6734', 'oIpt2gm', 1000000012, NULL, NULL, NULL),
('Yè', 'Dally', 0000000013, 'dqueree14@kickstarter.com', '474-609-0948', 'EJUtyWnG', 1000000013, NULL, NULL, NULL),
('Maëlle', 'Pesselt', 0000000014, 'mdelasalle15@wikispaces.com', '364-235-8064', 'NDGQVd', 1000000014, NULL, NULL, NULL),
('Audréanne', 'Eversfield', 0000000015, 'grisson16@sun.com', '152-782-9250', 'LsWVW4rhb', 1000000015, NULL, NULL, NULL),
('Léonie', 'Kobelt', 0000000016, 'acudby17@fastcompany.com', '382-416-4196', 'U6goeiZVBCM', 1000000016, NULL, NULL, NULL),
('Naéva', 'Pala', 0000000017, 'myashin18@storify.com', '655-236-2978', 'E2uuiEeJ', 1000000017, NULL, NULL, NULL),
('Lài', 'Mowles', 0000000018, 'mmonkeman19@cocolog-nifty.com', '112-921-5959', 'CugcS8l', 1000000018, NULL, NULL, NULL),
('Médiamass', 'Kleinerman', 000000005, 'snattriss1a@wikipedia.org', '700-160-5221', 'S6qAREDBCk', 1000000019, NULL, NULL, NULL),
('Alizée', 'Faithfull', 0000000019, 'dshatliffe1b@reuters.com', '706-202-7529', 'o8EPgZ0Pqp4', 1000000020, NULL, NULL, NULL),
('Eléa', 'Hammerton', 000000002, 'aworms1c@wiley.com', '112-464-0427', '52DpvtF6HLXS', 1000000021, NULL, NULL, NULL),
('Nuó', 'Walker', 0000000021, 'rsewall1d@archive.org', '138-852-9531', '1idEU4fA34', 1000000022, NULL, NULL, NULL),
('Ophélie', 'Stavers', 0000000022, 'shannam1e@sciencedirect.com', '890-187-1217', 'E6MtPZEPvnxh', 1000000023, NULL, NULL, NULL),
('Torbjörn', 'Mears', 0000000023, 'ckarslaker@walmart.com', '267-431-4354', 'TNgK06', NULL, 00001, NULL, NULL),
('Gaïa', 'Mitchely', 0000000024, 'acoldbathq@biglobe.ne.jp', '141-971-6755', '3FdwK7z', NULL, 00002, NULL, NULL),
('Kallisté', 'Boddis', 0000000025, 'lhouseagop@newyorker.com', '909-887-1168', '0zo1uYeuPvZK', NULL, 00003, NULL, NULL),
('Léonie', 'OGready', 0000000026, 'mpolsino@msu.edu', '558-971-7602', '3fbDsD', NULL, 00005, NULL, NULL),
('Clélia', 'Cantle', 0000000028, 'agoodlifem@yellowpages.com', '709-261-9910', 'mPfSx2sv30', NULL, 00006, NULL, NULL),
('Anaël', 'Sayce', 0000000029, 'bbrandhaml@qq.com', '234-200-6626', 'eLRXXPBthvs', NULL, NULL, 00001, NULL),
('Marie-ève', 'Gommey', 000000003, 'amcenhillk@slate.com', '495-842-4279', 'dozRGY0', NULL, NULL, 00002, NULL),
('Cloé', 'Sawney', 0000000031, 'nlozanoj@linkedin.com', '205-664-8349', 'a7P6hQqE', NULL, NULL, 00003, NULL),
('Lauréna', 'Jozwiak', 0000000032, 'hjacobowitzi@dailymotion.com', '837-390-4866', 'GUmT1LB', NULL, NULL, 00004, NULL),
('Mélinda', 'Mustchin', 0000000033, 'mmilesoph@ox.ac.uk', '282-600-3986', 'HH8pGPozfG', NULL, NULL, 00005, NULL),
('Lèi', 'Mahoney', 0000000034, 'mmcgurkg@senate.gov', '808-959-7145', 'JB7PjXYCG', NULL, NULL, 00006, NULL),
('Méryl', 'Elson', 0000000035, 'elucksf@xinhuanet.com', '688-155-7933', 'Ch72Dydy', NULL, NULL, 00007, NULL),
('Thérèse', 'Brunton', 0000000036, 'pmixtere@yellowpages.com', '402-941-0840', '7GQzCovRo', NULL, NULL, 00008, NULL),
('Maëly', 'Dewett', 0000000037, 'bdekeyserd@edublogs.org', '565-384-3862', 'pRQ9JFgZh', NULL, NULL, 00009, NULL),
('Angélique', 'Bandy', 0000000038, 'dklementc@examiner.com', '834-949-5554', 'tMHDFa', NULL, NULL, 00010, NULL),
('Solène', 'Weinmann', 0000000039, 'fhawsb@mediafire.com', '757-133-6870', '9sePucW9Ns', NULL, NULL, 00011, NULL);
end;
go
exec InsertTables;
go

CREATE NONCLUSTERED INDEX IX_FirstName ON tblAccount(FirstName)
go
CREATE NONCLUSTERED INDEX IX_LastName ON tblAccount(LastName)
go
CREATE NONCLUSTERED INDEX IX_Latitude ON tblData(Latitude)
go
CREATE NONCLUSTERED INDEX IX_Longitude ON tblData(Longitude)
go
CREATE NONCLUSTERED INDEX IX_Altitude ON tblData(Altitude)
go
CREATE NONCLUSTERED INDEX IX_Report ON tblMaintenanceSchedule(Report)
go

-- Transaction A 
-- A sales person subscribes to a new standard subscription to a 
-- BT Databox . The transaction receives the sales person Id, a 
-- discount %, all subscriber details, and a BT Databox ID. 
-- N.B. ContractID replaces DataboxID

DROP PROCEDURE IF EXISTS SubscribeToDatabox; 
go
CREATE PROCEDURE SubscribeToDatabox 
	  @pFirstName AS VARCHAR(30), 
	  @pLastName AS VARCHAR(30),
	  @pFullAdress AS INTEGER,
	  @pEmail AS VARCHAR(50),
	  @pPhoneNumber AS VARCHAR(20),
	  @pSecurityPassword AS VARCHAR(30),
	  @pSetupDate AS DATE,
	  @pSubscriptionTypeID AS TINYINT,
	  @pPaymentSchedule AS TINYINT,
	  @pContractID AS INTEGER,
	  @pAmountApplied AS REAL,
	  @pSalespersonID AS INTEGER

as
begin
       DECLARE @tblTempOne TABLE (CustomerID INTEGER);
	   DECLARE @tblTempTwo TABLE (SubscriptionID INTEGER);
	  
	   INSERT INTO tblSubscriber
	   OUTPUT INSERTED.CustomerID INTO @tblTempOne
	   DEFAULT VALUES;

	   INSERT INTO tblAccount(FirstName, LastName, FullAdress, Email, PhoneNumber, SecurityPassword, Subscriber)
	   VALUES (@pFirstName, @pLastName, @pFullAdress, @pEmail, @pPhoneNumber, @pSecurityPassword, (SELECT CustomerID from @tblTempOne))

	   INSERT INTO tblSubscription(SetupDate, SubscriptionType, PaymentSchedule, Subscriber)
	   OUTPUT INSERTED.SubscriptionID INTO @tblTempTwo
	   VALUES (@pSetupDate, @pSubscriptionTypeID, @pPaymentSchedule,(SELECT CustomerID from @tblTempOne))

	   INSERT INTO tblSubscriptionContract(AssignedDate, Subscription, ContractID) 
	   VALUES (@pSetupDate, (SELECT SubscriptionID from @tblTempTwo), @pContractID);

	   INSERT INTO tblDiscount(AmountApplied, Subscription, Salesperson)
	   VALUES (@pAmountApplied, (SELECT SubscriptionID from @tblTempTwo), @pSalespersonID);

	   INSERT INTO tblSale(SaleDate, Subscription, Salesperson)
	   VALUES (@pSetupDate, (SELECT SubscriptionID from @tblTempTwo), @pSalespersonID);
end;
go

-- TESTING A 
exec SubscribeToDatabox 'Test', 'Testing', 1, 'badamov4p@apple.com', '789-444-5813', 'Password', '2020/01/01', 2, 1, 1, 3, 1;
go

select * from tblAccount;
select * from tblSubscriber;
select * from tblSubscription;
select * from tblSubscriptionContract;
select * from tblDiscount;
select * from tblSale;

-- Transaction B
-- For each sales person list the subscribers they have sold a 
-- subscription to. The transaction receives the sales person's 
-- name as input, and presents each subscriber's name, address, 
-- and the % they were discounted.

DROP PROCEDURE IF EXISTS ShowSales;
go
CREATE PROCEDURE ShowSales 
		@pFirstName AS VARCHAR(30),
		@pLastName AS VARCHAR(30)

AS
BEGIN
 SELECT (ac.FirstName + ' ' + ac.LastName) AS 'Salesperson Name', (aa.FirstName + ' ' + aa.LastName) AS 'Subscriber Name', PropertyNameNo, Street, City, Country, po.PostcodeZipCode, AmountApplied AS 'Discount Applied'
 FROM	tblAccount ac
		JOIN tblEmployee ep on ac.Employee = ep.EmployeeID
		JOIN tblSalesperson sp on ep.EmployeeID = sp.Employee
		JOIN tblDiscount di on sp.Employee = di.Salesperson
		JOIN tblSubscription sb on di.Subscription = sb.SubscriptionID
		JOIN tblSubscriber sr on sb.Subscriber = sr.CustomerID
		JOIN tblAccount aa on sr.CustomerID = aa.Subscriber
		JOIN tblAddress ad on aa.FullAdress = ad.AddressID
		JOIN tblPostcode po on ad.PostcodeZipCode = po.PostcodeZipCode
 WHERE	ac.FirstName = @pFirstName AND ac.LastName = @pLastName
 
END;
go

-- TESTING B
EXEC ShowSales 'Lauréna', 'Jozwiak';
go

-- Transaction C
-- List the location in latitude, longitude coordinates, 
-- of each BT Databox that is currently in a contract. 
-- The transaction presents the Contracting organisation's name, 
-- a BT DataboxID, a Latitude, and a Longitude.

DROP PROCEDURE IF EXISTS ListDataboxesByOrganisation;
go
CREATE PROCEDURE ListDataboxesByOrganisation
AS
BEGIN
 SELECT (FirstName +' '+ LastName) AS "Contractee" , DataboxID AS 'Databox ID', Latitude, Longitude 
 FROM	tblAccount ac 
		JOIN tblContractee ce on ac.Contractee = ce.CustomerID
		JOIN tblContract cn on ce.CustomerID = cn.Contractee
		JOIN tblCover cv on cn.ContractID = cv.ContractID
		JOIN tblZone zo on cv.ZoneID = zo.ZoneID
		JOIN tblDataboxZone dz on zo.ZoneID = dz.ZoneID
		JOIN tblDatabox db on dz.Databox = db.DataboxID
		JOIN tblData dt on db.DataboxID = dt.Databox

END;
go
-- TESTING C
EXEC ListDataBoxesByOrganisation;
go 


-- Transaction D
-- For a contract list all the data collected. The transaction 
-- receives the contracting organisation's name and presents for 
-- each collected data record, the contracting organisation's name, 
-- a BT Databox ID, Temperature, Humidity and Ambient light strength.

DROP PROCEDURE IF EXISTS ListContractData;
go
CREATE PROCEDURE ListContractData
		@pContractID INTEGER

AS
BEGIN
 SELECT (FirstName +' '+ LastName) AS "Contractee" , DataboxID AS 'Databox ID', Temperature, Humidity, AmbientLightStrength AS 'Ambient Light Strength'
 FROM	tblAccount ac 
		JOIN tblContractee ce on ac.Contractee = ce.CustomerID
		JOIN tblContract cn on ce.CustomerID = cn.Contractee
		JOIN tblCover cv on cn.ContractID = cv.ContractID
		JOIN tblZone zo on cv.ZoneID = zo.ZoneID
		JOIN tblDataboxZone dz on zo.ZoneID = dz.ZoneID
		JOIN tblDatabox db on dz.Databox = db.DataboxID
		JOIN tblData dt on db.DataboxID = dt.Databox
 WHERE	cn.ContractID = @pContractID
END;
go
-- TESTING D
EXEC ListContractData '2';
go 


-- Transaction E
-- For each BT Databox present the list of subscribers who are viewing 
-- a live 3D video stream. The transaction lists BT Databox ID, Subscriber 
-- Name, Stream ID.

DROP PROCEDURE IF EXISTS ViewingLiveStream;
go
CREATE PROCEDURE ViewingLiveStream
AS
BEGIN
 SELECT DataboxID, FirstName, LastName, LiveStreamID 
 FROM	tblDatabox db
		JOIN tblLiveStream ls on db.DataboxID = ls.Databox
		JOIN tblView vw on ls.LiveStreamID = vw.LiveStream
		JOIN tblSubscriber sc on vw.Subscriber = sc.CustomerID
		JOIN tblAccount ac on sc.CustomerID = ac.Subscriber

END;
go
-- TESTING E
EXEC ViewingLiveStream;
go 



-- Transaction F
-- For a given BT Databox list all the suppliers of parts.
-- The transaction receives the  BT Databox ID, and presents 
-- the Supplier Name and, Part Name.

DROP PROCEDURE IF EXISTS BTDataboxSupplierParts;
go
CREATE PROCEDURE BTDataboxSupplierParts
		@pDataboxID INTEGER
AS
BEGIN
 SELECT DataboxID AS 'Databox ID', BusinessName AS 'Supplier Name', PartName AS 'Part Name'
 FROM	tblDatabox db
		JOIN tblPartDatabox pd on db.DataboxID = pd.Databox
		JOIN tblPart pr on pd.Part = pr.PartID
		JOIN tblSupply sp on pr.PartID = sp.Part
		JOIN tblSupplier su on sp.Supplier = su.SupplierID
 WHERE	db.DataboxiD = @pDataboxID

END;
go
-- TESTING F
EXEC BTDataboxSupplierParts '98';
go 


-- Transaction G
-- Update the location and Zone of a  BT Databox. The transaction 
-- receives the  BT Databox ID, a location and a Zone expressed 
-- as a list of coordinates in latitude, longitude pairs. It 
-- updates the location of the  BT Databox and its corresponding Zone. 

DROP PROCEDURE IF EXISTS UpdateLocationZone;
go
CREATE PROCEDURE UpdateLocationZone
	  @pDatabox AS INTEGER,
	  @pZoneID AS INTEGER, 
	  @pLatitude AS TINYINT,
	  @pLongitude AS TINYINT,
	  @pDataID AS INTEGER

AS
BEGIN
 UPDATE tblDataboxZone
 SET ZoneID = @pZoneID
 WHERE Databox = @pDatabox;

 UPDATE tblData
 SET Latitude = @pLatitude, Longitude = @pLongitude
 WHERE Databox = @pDatabox AND DataID = @pDataID;

 SELECT DataboxID, Latitude AS 'Databox Latitude', Longitude AS 'Databox Longitude', EastLatitude AS 'Zone East Latitude', WestLatitude AS 'Zone West Latitude', NorthLongitude AS 'Zone North Longitude', SouthLongitude AS 'Zone South Longitude'
 FROM	tblData da
		JOIN tblDatabox db on da.Databox = db.DataboxID
		JOIN tblDataboxZone dz on db.DataboxID = dz.Databox
		JOIN tblZone zo on dz.ZoneID = zo.ZoneID

 WHERE	DataboxID = @pDatabox

END;
go
-- TESTING G
EXEC UpdateLocationZone '2', '3', 34.398, 36.001, '2';
go 


-- Transaction H
-- Delete the data collected for a given Contract. The transaction 
-- receives a Contract ID, the data collected for a Contract is deleted.

DROP PROCEDURE IF EXISTS DeleteContractData;
go
CREATE PROCEDURE DeleteContractData
	  @pContractID AS INTEGER

AS
BEGIN
 DELETE tblDataRight
 FROM	tblDataRight dr
		JOIN tblData da on dr.DataID = da.DataID
		JOIN tblDatabox db on da.Databox = db.DataboxID
		JOIN tblDataboxZone dz on db.DataboxID = dz.Databox
		JOIN tblZone zo on dz.ZoneID = zo.ZoneID
		JOIN tblCover cv on zo.ZoneID = cv.ZoneID
		JOIN tblContract co on cv.ContractID = co.ContractID
 WHERE  co.ContractID = @pContractID

 DELETE	tblData
 FROM	tblData da
		JOIN tblDatabox db on da.Databox = db.DataboxID
		JOIN tblDataboxZone dz on db.DataboxID = dz.Databox
		JOIN tblZone zo on dz.ZoneID = zo.ZoneID
		JOIN tblCover cv on zo.ZoneID = cv.ZoneID
		JOIN tblContract co on cv.ContractID = co.ContractID
 WHERE	co.ContractID = @pContractID

END;
go
-- TESTING H
EXEC DeleteContractData '2';
go


-- Transaction I
-- Write a query to  be used to Insert data from a BT Databox 
-- to its stored data on the Being There database. The transaction 
-- receives the  BT Databox ID.

DROP PROCEDURE IF EXISTS InsertDataboxData;
go
CREATE PROCEDURE InsertDataboxData
	  @pDataDate date,
	  @pDataTime time,
	  @pLatitude INTEGER,
	  @pLongitude INTEGER, 
	  @pAltitude INTEGER,
	  @pTemperature INTEGER, 
	  @pHumidity INTEGER,
	  @pAmbientLightStrength INTEGER, 
	  @pDataboxID AS INTEGER

AS
BEGIN

	  INSERT INTO tblData(DataDate, DataTime, Latitude, Longitude, Altitude, Temperature, Humidity, AmbientLightStrength, Databox) 
	  VALUES (@pDataDate, @pDataTime, @pLatitude, @pLongitude, @pAltitude, @pTemperature, @pHumidity, @pAmbientLightStrength, @pDataboxID)

END;
go
-- TESTING I
EXEC InsertDataboxData '26/09/2019', '16:55', 18.1686828, 12.7050032, 9782, 50, 63, 25978.3608, 0000000007;
go

