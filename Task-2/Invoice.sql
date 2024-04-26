-- Create Invoices Table
CREATE TABLE INVOICE (
    ID         			INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    REFERENCE        	VARCHAR2(200),
    INVOICE_DATE      	DATE,
    ORDER_ID           	INT,
    AMOUNT             	NUMBER(12, 2),
    DESCRIPTION        	VARCHAR2(500),
    STATUS             	VARCHAR2(50),
    HOLD_REASON        	VARCHAR2(200),
    CONSTRAINT FK_INVOICE_ORDER FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ID)
);