CREATE OR REPLACE PROCEDURE SECOND_HIGHEST_ORDER_DETAILS AS
    v_Order_Reference VARCHAR2(100);
    v_Order_Date DATE;
    v_Supplier_Name VARCHAR2(100);
    v_Order_Total_Amount NUMBER;
    v_Order_Status VARCHAR2(50);
    v_Invoice_References CLOB;

BEGIN
    SELECT 
        ORDER_REFERENCE,
        ORDER_DATE,
        ORDER_DATE,
        TOTAL_AMOUNT,
        STATUS
    INTO
        v_Order_Reference,
        v_Order_Date,
        v_Supplier_Name,
        v_Order_Total_Amount,
        v_Order_Status
    FROM (
        SELECT
            REGEXP_REPLACE(O.REFERENCE, 'PO', '') AS ORDER_REFERENCE,
            O.ORDER_DATE,
            UPPER(S.NAME) AS SUPPLIER_NAME,
            O.TOTAL_AMOUNT,
            O.STATUS,
            RANK() OVER (ORDER BY O.TOTAL_AMOUNT  DESC) AS RANK_ORDER
        FROM
            ORDERS O
        LEFT JOIN
            SUPPLIER S ON O.SUPPLIER_ID = S.ID
        LEFT JOIN
            INVOICE I ON O.ID = I.ORDER_ID
        GROUP BY
            O.REFERENCE ,
            O.ORDER_DATE,
            S.NAME,
            O.TOTAL_AMOUNT,
            O.STATUS
    )
    WHERE
        RANK_ORDER = 2;
       
    SELECT
        LISTAGG(I.REFERENCE, ' | ') WITHIN GROUP (ORDER BY I.REFERENCE) AS INVOICE_REFERENCES
    INTO
        v_Invoice_References
    FROM
        INVOICE I
    WHERE
        I.ORDER_ID = (SELECT O.ID FROM ORDERS O WHERE ROWNUM = 2);

    -- Format the Order Date
    v_Order_Date := TO_CHAR(v_Order_Date, 'Month DD, YYYY');

    -- Format the Order Total Amount
    v_Order_Total_Amount := TO_CHAR(v_Order_Total_Amount, '99,999,990.00');

    -- Output the results
    DBMS_OUTPUT.PUT_LINE('Order Reference: ' || v_Order_Reference);
    DBMS_OUTPUT.PUT_LINE('Order Date: ' || v_Order_Date);
    DBMS_OUTPUT.PUT_LINE('Supplier Name: ' || v_Supplier_Name);
    DBMS_OUTPUT.PUT_LINE('Order Total Amount: ' || v_Order_Total_Amount);
    DBMS_OUTPUT.PUT_LINE('Order Status: ' || v_Order_Status);
    DBMS_OUTPUT.PUT_LINE('Invoice References: ' || v_Invoice_References);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No records found.');
END;