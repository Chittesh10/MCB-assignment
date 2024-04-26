-- Create Supplier Table
CREATE TABLE SUPPLIER (
    ID        		   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    NAME               VARCHAR2(200),
    CONTACT_NAME       VARCHAR2(200),
    ADDRESS            VARCHAR2(200),
    CONTACT_NUMBER     VARCHAR2(20),
    EMAIL              VARCHAR2(100)
);