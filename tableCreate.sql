USE lab_management;

-- Create the unique_ids table first to store unique IDs
CREATE TABLE unique_ids (
	unique_id INT AUTO_INCREMENT PRIMARY KEY,
	entity_type VARCHAR(255) NOT NULL,
	entity_id INT NOT NULL
);

-- Create the rooms table
CREATE TABLE rooms (
	room_id INT AUTO_INCREMENT PRIMARY KEY,
	room_name VARCHAR(255) NOT NULL UNIQUE,
	location VARCHAR(255)
);

-- Create the freezers table
CREATE TABLE freezers (
	freezer_id INT AUTO_INCREMENT PRIMARY KEY,
	room_id INT NOT NULL,
	freezer_name VARCHAR(255) NOT NULL UNIQUE,
	FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE
);

-- Create the shelves table
CREATE TABLE shelves (
	shelf_id INT AUTO_INCREMENT PRIMARY KEY,
	freezer_id INT NOT NULL,
	shelf_position VARCHAR(50),
	FOREIGN KEY (freezer_id) REFERENCES freezers(freezer_id) ON DELETE CASCADE
);

-- Create the racks table
CREATE TABLE racks (
	rack_id INT AUTO_INCREMENT PRIMARY KEY,
	shelf_id INT NOT NULL,
	rack_position VARCHAR(50),
	FOREIGN KEY (shelf_id) REFERENCES shelves(shelf_id) ON DELETE CASCADE
);

-- Create the boxes table
CREATE TABLE boxes (
	box_id INT AUTO_INCREMENT PRIMARY KEY,
	rack_id INT NOT NULL,
	box_position VARCHAR(50),
	box_label VARCHAR(255),
	box_rows INT NOT NULL,
	box_cols INT NOT NULL,
	FOREIGN KEY (rack_id) REFERENCES racks(rack_id) ON DELETE CASCADE
);

-- Create the tubes table
CREATE TABLE tubes (
	tube_id INT AUTO_INCREMENT PRIMARY KEY,
	box_id INT NOT NULL,
	row_index INT NOT NULL,
	col_index INT NOT NULL,
	tube_label VARCHAR(255),
	sample_type VARCHAR(255),
	tags TEXT,
	professor_name VARCHAR(255) NOT NULL,
	strain_name VARCHAR(255) NOT NULL,
	unique_id VARCHAR(255) UNIQUE NOT NULL,
	created_by VARCHAR(255) NOT NULL,
	date_created DATE NOT NULL,
	date_deposited DATE NOT NULL,
	organism_type VARCHAR(255) NOT NULL,
	selectable_marker VARCHAR(255),
	notebook_number VARCHAR(255),
	FOREIGN KEY (box_id) REFERENCES boxes(box_id) ON DELETE CASCADE,
	CHECK (row_index >= 0),
	CHECK (col_index >= 0)
);



-- Create trigger for rooms table
DELIMITER $$
CREATE TRIGGER after_room_insert
AFTER INSERT ON rooms
FOR EACH ROW
BEGIN
	-- Insert a record into the unique_ids table for room
	INSERT INTO unique_ids (entity_type, entity_id)
	VALUES ('room', NEW.room_id);
END $$
DELIMITER ;

-- Create trigger for freezers table
DELIMITER $$
CREATE TRIGGER after_freezer_insert
AFTER INSERT ON freezers
FOR EACH ROW
BEGIN
	-- Insert a record into the unique_ids table for freezer
	INSERT INTO unique_ids (entity_type, entity_id)
	VALUES ('freezer', NEW.freezer_id);
END $$
DELIMITER ;

-- Create trigger for shelves table
DELIMITER $$
CREATE TRIGGER after_shelf_insert
AFTER INSERT ON shelves
FOR EACH ROW
BEGIN
	-- Insert a record into the unique_ids table for shelf
	INSERT INTO unique_ids (entity_type, entity_id)
	VALUES ('shelf', NEW.shelf_id);
END $$
DELIMITER ;

-- Create trigger for racks table
DELIMITER $$
CREATE TRIGGER after_rack_insert
AFTER INSERT ON racks
FOR EACH ROW
BEGIN
	-- Insert a record into the unique_ids table for rack
	INSERT INTO unique_ids (entity_type, entity_id)
	VALUES ('rack', NEW.rack_id);
END $$
DELIMITER ;

-- Create trigger for boxes table
DELIMITER $$
CREATE TRIGGER after_box_insert
AFTER INSERT ON boxes
FOR EACH ROW
BEGIN
	-- Insert a record into the unique_ids table for box
	INSERT INTO unique_ids (entity_type, entity_id)
	VALUES ('box', NEW.box_id);
END $$
DELIMITER ;

-- Create trigger for tubes table
DELIMITER $$
CREATE TRIGGER after_tube_insert
AFTER INSERT ON tubes
FOR EACH ROW
BEGIN
	-- Insert a record into the unique_ids table for tube
	INSERT INTO unique_ids (entity_type, entity_id)
	VALUES ('tube', NEW.tube_id);
END $$
DELIMITER ;

-- Insert dummy data into the rooms table
INSERT INTO rooms (room_name, location)
VALUES
	('Room A', 'Building A, Floor 1'),
	('Room B', 'Building A, Floor 2');

-- Insert dummy data into the freezers table
INSERT INTO freezers (room_id, freezer_name)
VALUES
	(1, 'Freezer 1'),
	(1, 'Freezer 2'),
	(2, 'Freezer 3');

-- Insert dummy data into the shelves table
INSERT INTO shelves (freezer_id, shelf_position)
VALUES
	(1, 'Top'),
	(1, 'Middle'),
	(2, 'Bottom'),
	(3, 'Top');

-- Insert dummy data into the racks table
INSERT INTO racks (shelf_id, rack_position)
VALUES
	(1, 'Rack 1'),
	(2, 'Rack 2'),
	(3, 'Rack 3'),
	(4, 'Rack 4');

-- Insert dummy data into the boxes table
INSERT INTO boxes (rack_id, box_position, box_label, box_rows, box_cols)
VALUES
	(1, 'Position 1', 'Box A', 8, 8),
	(2, 'Position 2', 'Box B', 9, 9),
	(3, 'Position 3', 'Box C', 8, 8),
	(4, 'Position 4', 'Box D', 9, 9);

-- Insert dummy data into the tubes table
INSERT INTO tubes (box_id, row_index, col_index, tube_label, sample_type, professor_name, strain_name, unique_id, created_by, date_created, date_deposited, organism_type, selectable_marker, notebook_number)
VALUES
	(1, 0, 0, 'Tube 1', 'Blood', 'Dr. Smith', 'Strain A', 'UID001', 'Alice', '2023-01-01', '2023-01-01', 'Human', 'Marker1', 'NB001'),
	(1, 0, 1, 'Tube 2', 'Saliva', 'Dr. Brown', 'Strain B', 'UID002', 'Bob', '2023-01-02', '2023-01-02', 'Human', 'Marker2', 'NB002'),
	(2, 1, 0, 'Tube 3', 'Tissue', 'Dr. Green', 'Strain C', 'UID003', 'Charlie', '2023-01-03', '2023-01-03', 'Mouse', 'Marker3', 'NB003'),
	(2, 1, 1, 'Tube 4', 'Urine', 'Dr. White', 'Strain D', 'UID004', 'Dana', '2023-01-04', '2023-01-04', 'Mouse', 'Marker4', 'NB004');
