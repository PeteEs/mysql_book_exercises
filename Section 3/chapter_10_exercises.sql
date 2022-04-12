/*

Create database that stores information about products

Products table
	- product_id
    - product_name
    - product_description
	- product_price
    - category_id

Categories table
	- category_id
    - category_name
    - category_description
    
*/

DROP DATABASE IF EXISTS pc;
CREATE DATABASE pc;

USE pc;

CREATE TABLE categories
(
	category_id			 INT 			PRIMARY KEY		AUTO_INCREMENT,
    category_name		 VARCHAR(50)	NOT NULL		UNIQUE,
    category_description VARCHAR(100)	NOT NULL
);

CREATE TABLE products
(
	product_id			INT				PRIMARY KEY		AUTO_INCREMENT,
    product_name		VARCHAR(50)		NOT NULL		UNIQUE,
    product_description	VARCHAR(100)	NOT NULL,
    product_price		DECIMAL(10,2)	NOT NULL,
    category_id			INT,
    CONSTRAINT products_fk_categories
		FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
);

/*

Create database that stores information about customers

country table
	- country_id
    - country_symbol
    - country_name

address table
	- address_id
    - street_address
    - city
    - state
    - postal_code
    - country_id

customers table
	- customer_id
    - first_name
    - last_name
    - address_id
         
*/

DROP DATABASE IF EXISTS ca;
CREATE DATABASE ca;

USE ca;


CREATE TABLE country
(
	country_id			INT 			PRIMARY KEY		AUTO_INCREMENT,
    country_symbol		VARCHAR(10)		NOT NULL		UNIQUE,
	country_name 		VARCHAR(100)	NOT NULL		UNIQUE
);

CREATE TABLE address
(
	address_id			INT				PRIMARY KEY		AUTO_INCREMENT,
    street_address		VARCHAR(100)	NOT NULL 		UNIQUE,
    city				VARCHAR(100)	NOT NULL,
    state				VARCHAR(100)	NOT NULL,
    postal_code			VARCHAR(50)		NOT NULL,
    country_id			INT				NOT NULL,
    CONSTRAINT address_fk_country
		FOREIGN KEY (country_id)
		REFERENCES country (country_id)
);

CREATE TABLE customers
(
	customer_id			INT				PRIMARY KEY		AUTO_INCREMENT,
    first_name			VARCHAR(50)		NOT NULL,
    last_name			VARCHAR(50)		NOT NULL,
    address_id			INT				NOT NULL,
    CONSTRAINT customers_fk_address
		FOREIGN KEY (address_id)
        REFERENCES address (address_id)
);
