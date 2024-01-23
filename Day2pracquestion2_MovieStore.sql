-- Create Movie table

CREATE TABLE Movie (
    movie_number INT PRIMARY KEY,
    title VARCHAR(255),
    format VARCHAR(10),
    category VARCHAR(50)
);

-- Create VideoStore table

CREATE TABLE VideoStore (
    store_name VARCHAR(255) PRIMARY KEY,
    phone_number VARCHAR(20) UNIQUE
);

-- Create Category table (for the relationship between Movie and Category)


CREATE TABLE Category (
    movie_number INT,
    category VARCHAR(50),
    PRIMARY KEY (movie_number, category),
    FOREIGN KEY (movie_number) REFERENCES Movie(movie_number)
);

-- Create Member table

CREATE TABLE Member (
    member_phone_number VARCHAR(20) PRIMARY KEY,
    favorite_category VARCHAR(50),
    CONSTRAINT CHK_Member_Category CHECK (favorite_category IN ('action', 'adventure', 'comedy'))
);

-- Create GoldenMember table (inherits from Member)

CREATE TABLE GoldenMember (
    member_phone_number VARCHAR(20) PRIMARY KEY,
    credit_card VARCHAR(16),
    FOREIGN KEY (member_phone_number) REFERENCES Member(member_phone_number)
);

-- Create BronzeMember table (inherits from Member)

CREATE TABLE BronzeMember (
    member_phone_number VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY (member_phone_number) REFERENCES Member(member_phone_number)
);

-- Create Dependent table

CREATE TABLE Dependents (
    dependent_name VARCHAR(255),
    member_phone_number VARCHAR(20),
    PRIMARY KEY (dependent_name, member_phone_number),
    FOREIGN KEY (member_phone_number) REFERENCES Member(member_phone_number)
);

-- Create Rents table (for the relationship between Member and Movie)

CREATE TABLE Rents (
    member_phone_number VARCHAR(20),
    movie_number INT,
    rental_date DATETIME,
    return_date DATETIME,
    PRIMARY KEY (member_phone_number, movie_number),
    FOREIGN KEY (member_phone_number) REFERENCES Member(member_phone_number),
    FOREIGN KEY (movie_number) REFERENCES Movie(movie_number)
);

-- Create RentsDependent table (for the relationship between Dependent and Movie)

CREATE TABLE RentsDependent (
    dependent_name VARCHAR(255),
	member_phone_number VARCHAR(20),
    movie_number INT,
    rental_date DATETIME,
    return_date DATETIME,
    PRIMARY KEY (dependent_name, movie_number),
    FOREIGN KEY (dependent_name, member_phone_number) REFERENCES Dependents(dependent_name, member_phone_number),
    FOREIGN KEY (movie_number) REFERENCES Movie(movie_number)
);




